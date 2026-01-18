# CI/CD Pipeline Templates

Ready-to-use templates for various CI platforms.

## GitHub Actions

### Basic Test Pipeline

```yaml
# .github/workflows/test.yml
name: Test

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]

jobs:
  lint:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: '20'
          cache: 'npm'
      - run: npm ci
      - run: npm run lint
      - run: npm run typecheck

  unit-tests:
    runs-on: ubuntu-latest
    needs: lint
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: '20'
          cache: 'npm'
      - run: npm ci
      - run: npm run test:unit -- --coverage
      - uses: codecov/codecov-action@v4
        with:
          files: coverage/lcov.info
          fail_ci_if_error: true

  integration-tests:
    runs-on: ubuntu-latest
    needs: lint
    services:
      postgres:
        image: postgres:15
        env:
          POSTGRES_USER: test
          POSTGRES_PASSWORD: test
          POSTGRES_DB: test
        ports:
          - 5432:5432
        options: >-
          --health-cmd pg_isready
          --health-interval 10s
          --health-timeout 5s
          --health-retries 5
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: '20'
          cache: 'npm'
      - run: npm ci
      - run: npm run test:integration
        env:
          DATABASE_URL: postgresql://test:test@localhost:5432/test

  e2e-tests:
    runs-on: ubuntu-latest
    needs: [unit-tests, integration-tests]
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: '20'
          cache: 'npm'
      - run: npm ci
      - run: npx playwright install --with-deps
      - run: npm run test:e2e
      - uses: actions/upload-artifact@v4
        if: failure()
        with:
          name: playwright-report
          path: playwright-report/
          retention-days: 7
```

### Parallel E2E Tests (Sharded)

```yaml
# .github/workflows/e2e.yml
name: E2E Tests

on:
  push:
    branches: [main]
  pull_request:

jobs:
  e2e:
    runs-on: ubuntu-latest
    strategy:
      fail-fast: false
      matrix:
        shard: [1, 2, 3, 4]
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: '20'
          cache: 'npm'
      - run: npm ci
      - run: npx playwright install --with-deps
      - run: npx playwright test --shard=${{ matrix.shard }}/4
      - uses: actions/upload-artifact@v4
        if: always()
        with:
          name: blob-report-${{ matrix.shard }}
          path: blob-report/
          retention-days: 1

  merge-reports:
    needs: e2e
    runs-on: ubuntu-latest
    if: always()
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: '20'
      - run: npm ci
      - uses: actions/download-artifact@v4
        with:
          pattern: blob-report-*
          merge-multiple: true
          path: blob-report
      - run: npx playwright merge-reports --reporter html ./blob-report
      - uses: actions/upload-artifact@v4
        with:
          name: playwright-report
          path: playwright-report/
          retention-days: 7
```

## GitLab CI

### Full Pipeline

```yaml
# .gitlab-ci.yml
stages:
  - lint
  - test
  - e2e
  - report

variables:
  NODE_VERSION: "20"
  POSTGRES_DB: test
  POSTGRES_USER: test
  POSTGRES_PASSWORD: test

.node-setup:
  image: node:${NODE_VERSION}
  cache:
    key:
      files:
        - package-lock.json
    paths:
      - node_modules/
  before_script:
    - npm ci

lint:
  extends: .node-setup
  stage: lint
  script:
    - npm run lint
    - npm run typecheck

unit-tests:
  extends: .node-setup
  stage: test
  script:
    - npm run test:unit -- --coverage
  coverage: '/All files[^|]*\|[^|]*\s+([\d\.]+)/'
  artifacts:
    reports:
      coverage_report:
        coverage_format: cobertura
        path: coverage/cobertura-coverage.xml

integration-tests:
  extends: .node-setup
  stage: test
  services:
    - name: postgres:15
      alias: db
  variables:
    DATABASE_URL: postgresql://test:test@db:5432/test
  script:
    - npm run test:integration

e2e-tests:
  extends: .node-setup
  stage: e2e
  image: mcr.microsoft.com/playwright:v1.40.0-focal
  script:
    - npm ci
    - npx playwright test
  artifacts:
    when: always
    paths:
      - playwright-report/
    expire_in: 7 days
  parallel:
    matrix:
      - SHARD: ["1/4", "2/4", "3/4", "4/4"]
```

## CircleCI

### Basic Pipeline

```yaml
# .circleci/config.yml
version: 2.1

orbs:
  node: circleci/node@5.1

executors:
  node-executor:
    docker:
      - image: cimg/node:20.10
      - image: cimg/postgres:15.0
        environment:
          POSTGRES_USER: test
          POSTGRES_PASSWORD: test
          POSTGRES_DB: test

jobs:
  lint:
    executor: node-executor
    steps:
      - checkout
      - node/install-packages
      - run: npm run lint
      - run: npm run typecheck

  unit-tests:
    executor: node-executor
    steps:
      - checkout
      - node/install-packages
      - run: npm run test:unit -- --coverage
      - store_test_results:
          path: test-results
      - store_artifacts:
          path: coverage

  integration-tests:
    executor: node-executor
    steps:
      - checkout
      - node/install-packages
      - run:
          name: Wait for DB
          command: dockerize -wait tcp://localhost:5432 -timeout 1m
      - run: npm run test:integration
        environment:
          DATABASE_URL: postgresql://test:test@localhost:5432/test

  e2e-tests:
    docker:
      - image: mcr.microsoft.com/playwright:v1.40.0-focal
    parallelism: 4
    steps:
      - checkout
      - node/install-packages
      - run: |
          SHARD="$((${CIRCLE_NODE_INDEX}+1))"
          npx playwright test --shard=${SHARD}/${CIRCLE_NODE_TOTAL}
      - store_artifacts:
          path: playwright-report

workflows:
  test:
    jobs:
      - lint
      - unit-tests:
          requires: [lint]
      - integration-tests:
          requires: [lint]
      - e2e-tests:
          requires: [unit-tests, integration-tests]
```

## Jenkins

### Declarative Pipeline

```groovy
// Jenkinsfile
pipeline {
    agent {
        docker {
            image 'node:20'
        }
    }

    environment {
        CI = 'true'
        NODE_ENV = 'test'
    }

    stages {
        stage('Install') {
            steps {
                sh 'npm ci'
            }
        }

        stage('Lint') {
            steps {
                sh 'npm run lint'
                sh 'npm run typecheck'
            }
        }

        stage('Unit Tests') {
            steps {
                sh 'npm run test:unit -- --coverage'
            }
            post {
                always {
                    publishCoverage adapters: [coberturaAdapter('coverage/cobertura-coverage.xml')]
                    junit 'test-results/*.xml'
                }
            }
        }

        stage('Integration Tests') {
            steps {
                script {
                    docker.image('postgres:15').withRun('-e POSTGRES_PASSWORD=test') { db ->
                        sh """
                            export DATABASE_URL=postgresql://postgres:test@${db.id}:5432/postgres
                            npm run test:integration
                        """
                    }
                }
            }
        }

        stage('E2E Tests') {
            agent {
                docker {
                    image 'mcr.microsoft.com/playwright:v1.40.0-focal'
                }
            }
            steps {
                sh 'npm ci'
                sh 'npx playwright test'
            }
            post {
                always {
                    archiveArtifacts artifacts: 'playwright-report/**/*', allowEmptyArchive: true
                }
            }
        }
    }

    post {
        failure {
            mail to: 'team@example.com',
                 subject: "Pipeline Failed: ${currentBuild.fullDisplayName}",
                 body: "Check: ${env.BUILD_URL}"
        }
    }
}
```

## Common Patterns

### Coverage Enforcement

```yaml
# GitHub Actions example
- name: Check coverage threshold
  run: |
    COVERAGE=$(cat coverage/coverage-summary.json | jq '.total.lines.pct')
    if (( $(echo "$COVERAGE < 80" | bc -l) )); then
      echo "Coverage $COVERAGE% is below 80% threshold"
      exit 1
    fi
```

### Flaky Test Detection

```yaml
# Run tests multiple times to detect flakiness
- name: Flaky test detection
  run: |
    for i in {1..5}; do
      npm run test:e2e || exit 1
    done
```

### Caching Dependencies

```yaml
# GitHub Actions
- uses: actions/cache@v4
  with:
    path: |
      ~/.npm
      node_modules
      ~/.cache/ms-playwright
    key: ${{ runner.os }}-deps-${{ hashFiles('**/package-lock.json') }}
```

### Artifact Retention

```yaml
# Keep test reports for debugging
- uses: actions/upload-artifact@v4
  if: always()
  with:
    name: test-results
    path: |
      coverage/
      playwright-report/
      test-results/
    retention-days: 14
```

---

*Adapt these templates to your specific CI platform and project requirements.*
