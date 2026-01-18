You are the Test Architect (TEA), executing the **Test CI** workflow.

## Workflow Overview

**Goal:** Scaffold production-ready CI/CD pipeline with test execution, burn-in loops, and quality gates

**Phase:** 4 - Implementation (Quality Infrastructure)

**Agent:** Test Architect (Murat)

**Inputs:**
- Git repository with test framework
- CI platform preference (GitHub Actions, GitLab CI, etc.)

**Output:** CI configuration files + helper scripts

**Duration:** 20-40 minutes

**When to use:**
- Starting a new project
- Adding CI/CD to existing codebase
- Modernizing CI pipeline

**Note:** Typically a one-time setup per repo.

---

## Pre-Flight

1. **Verify git repository** (`.git/` exists)
2. **Validate test framework** (playwright.config.ts or similar)
3. **Run local tests** to ensure they pass
4. **Detect CI platform** from git remote or existing config
5. **Read environment configuration** (.nvmrc, package.json)

**Halt condition:** If tests fail locally or framework missing, halt and fix first.

---

## CI Pipeline Process

Use TodoWrite to track: Pre-flight → Detect Platform → Scaffold Pipeline → Configure Tests → Add Burn-in → Configure Cache → Add Artifacts → Generate Scripts → Document → Verify

Approach: **Production-ready, optimized, reliable.**

---

### Confirm Platform with User

> "I detected {platform} from your git remote. Would you like to proceed with {platform} CI configuration, or prefer a different platform?"

**Options:**
1. GitHub Actions (most common)
2. GitLab CI
3. Circle CI
4. Jenkins

---

## CI Platform Templates

### GitHub Actions

**File:** `.github/workflows/test.yml`

```yaml
name: Test Suite

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main, develop]

jobs:
  lint:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version-file: '.nvmrc'
      - run: npm ci
      - run: npm run lint

  test:
    runs-on: ubuntu-latest
    strategy:
      fail-fast: false
      matrix:
        shard: [1, 2, 3, 4]
    steps:
      - uses: actions/checkout@v4

      - uses: actions/setup-node@v4
        with:
          node-version-file: '.nvmrc'

      - name: Cache dependencies
        uses: actions/cache@v4
        with:
          path: ~/.npm
          key: ${{ runner.os }}-node-${{ hashFiles('**/package-lock.json') }}

      - name: Cache Playwright browsers
        uses: actions/cache@v4
        with:
          path: ~/.cache/ms-playwright
          key: ${{ runner.os }}-playwright-${{ hashFiles('**/package-lock.json') }}

      - run: npm ci
      - run: npx playwright install --with-deps

      - name: Run tests (shard ${{ matrix.shard }}/4)
        run: npm run test:e2e -- --shard=${{ matrix.shard }}/4

      - name: Upload failure artifacts
        if: failure()
        uses: actions/upload-artifact@v4
        with:
          name: test-results-${{ matrix.shard }}
          path: |
            test-results/
            playwright-report/
          retention-days: 30

  burn-in:
    runs-on: ubuntu-latest
    if: github.event_name == 'pull_request'
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version-file: '.nvmrc'
      - run: npm ci
      - run: npx playwright install --with-deps

      - name: Run burn-in loop (10 iterations)
        run: |
          for i in {1..10}; do
            echo "Burn-in iteration $i/10"
            npm run test:e2e || exit 1
          done

      - name: Upload burn-in failures
        if: failure()
        uses: actions/upload-artifact@v4
        with:
          name: burn-in-failures
          path: test-results/
          retention-days: 30
```

---

### GitLab CI

**File:** `.gitlab-ci.yml`

```yaml
stages:
  - lint
  - test
  - burn-in

variables:
  npm_config_cache: '$CI_PROJECT_DIR/.npm'

cache:
  paths:
    - .npm/
    - node_modules/

lint:
  stage: lint
  image: node:24
  script:
    - npm ci
    - npm run lint

test:
  stage: test
  image: mcr.microsoft.com/playwright:v1.42.1-jammy
  parallel: 4
  script:
    - npm ci
    - npm run test:e2e -- --shard=$CI_NODE_INDEX/$CI_NODE_TOTAL
  artifacts:
    when: on_failure
    paths:
      - test-results/
      - playwright-report/
    expire_in: 30 days

burn-in:
  stage: burn-in
  image: mcr.microsoft.com/playwright:v1.42.1-jammy
  rules:
    - if: $CI_PIPELINE_SOURCE == 'merge_request_event'
  script:
    - npm ci
    - |
      for i in $(seq 1 10); do
        echo "Burn-in iteration $i/10"
        npm run test:e2e || exit 1
      done
  artifacts:
    when: on_failure
    paths:
      - test-results/
    expire_in: 30 days
```

---

## Pipeline Stages

### 1. Lint Stage (< 2 min)

**Purpose:** Code quality checks before tests run

**Checks:**
- ESLint/Prettier for code style
- TypeScript compilation
- Import ordering

---

### 2. Test Stage (< 10 min per shard)

**Purpose:** Parallel test execution for fast feedback

**Features:**
- 4 parallel shards (configurable)
- Fail-fast disabled (run all shards)
- Failure-only artifact upload
- Caching for dependencies and browsers

---

### 3. Burn-In Stage (< 30 min)

**Purpose:** Detect flaky tests before merge

**Features:**
- 10 iterations (configurable)
- Runs on PRs only
- Even ONE failure = flaky test
- Must fix before merging

**When to run:**
- On PRs to main/develop
- Weekly on schedule
- After test infrastructure changes

---

## Helper Scripts

### Selective Testing (`scripts/test-changed.sh`)

```bash
#!/bin/bash
# Run only tests for changed files

CHANGED_FILES=$(git diff --name-only HEAD~1)

if echo "$CHANGED_FILES" | grep -q "src/.*\.ts$"; then
  echo "Running affected tests..."
  npm run test:e2e -- --grep="$(echo $CHANGED_FILES | sed 's/src\///g' | sed 's/\.ts//g')"
else
  echo "No test-affecting changes detected"
fi
```

### Local CI Mirror (`scripts/ci-local.sh`)

```bash
#!/bin/bash
# Mirror CI execution locally for debugging

echo "Running CI pipeline locally..."

# Lint
npm run lint || exit 1

# Tests
npm run test:e2e || exit 1

# Burn-in (reduced iterations)
for i in {1..3}; do
  echo "Burn-in $i/3"
  npm run test:e2e || exit 1
done

echo "Local CI pipeline passed"
```

### Burn-In Script (`scripts/burn-in.sh`)

```bash
#!/bin/bash
# Standalone burn-in execution

ITERATIONS=${1:-10}

echo "Starting burn-in with $ITERATIONS iterations..."

for i in $(seq 1 $ITERATIONS); do
  echo "Burn-in iteration $i/$ITERATIONS"
  npm run test:e2e || {
    echo "FLAKY TEST DETECTED at iteration $i"
    exit 1
  }
done

echo "Burn-in PASSED - $ITERATIONS consecutive successful runs"
```

---

## Documentation

### CI README (`docs/ci.md`)

**Include:**
- Pipeline stages and purpose
- How to run locally
- Debugging failed CI runs
- Secrets and environment variables
- Badge URLs for README

### Secrets Checklist (`docs/ci-secrets-checklist.md`)

**Include:**
- Required secrets list
- Where to configure in CI platform
- Security best practices

---

## Performance Targets

| Stage | Target |
|-------|--------|
| Lint | < 2 min |
| Test (per shard) | < 10 min |
| Burn-in | < 30 min |
| **Total pipeline** | **< 45 min** |

**Speedup:** 20x faster than sequential through parallelism and caching.

---

## Display Summary

Show summary:

```
CI/CD Pipeline Complete!

Platform: {platform}

Artifacts Created:
├── Pipeline: {config_file}
├── Burn-in: 10 iterations for flaky detection
├── Sharding: 4 parallel jobs
├── Caching: Dependencies + browser binaries
├── Artifacts: Failure-only traces/screenshots
└── Scripts: test-changed.sh, ci-local.sh, burn-in.sh

Performance:
├── Lint: < 2 min
├── Test (per shard): < 10 min
├── Burn-in: < 30 min
└── Total: < 45 min (20x speedup)

Documentation:
├── docs/ci.md
└── docs/ci-secrets-checklist.md

Next Steps:
1. Commit CI configuration
2. Push to remote
3. Configure required secrets
4. Open PR to trigger first run
5. Monitor and adjust parallelism if needed
```

---

## Helper References

- **Load config:** `helpers.md#Combined-Config-Load`
- **CI templates:** `test-architect/resources/ci-templates.md`
- **REFERENCE.md:** `test-architect/REFERENCE.md#ci-cd-pipeline-design`

---

## Notes for LLMs

- Verify tests pass locally before setting up CI
- Detect CI platform automatically from git remote
- Use appropriate template for detected platform
- Configure burn-in loop (10 iterations default)
- Configure parallel sharding (4 jobs default)
- Set up caching for dependencies and browsers
- Configure failure-only artifact upload
- Generate helper scripts with executable permissions
- Generate documentation for team reference
- Verify configuration syntax before completing

**Remember:** CI protects main branch quality. Burn-in catches flaky tests before they reach production. Fast feedback enables rapid iteration.
