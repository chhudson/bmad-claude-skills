# Test Architect Reference Guide

Detailed reference material for the Test Architect (TEA) skill. This document contains in-depth patterns, knowledge fragments, and best practices for all testing workflows.

## Table of Contents

1. [Test Levels Framework](#test-levels-framework)
2. [Fixture Architecture](#fixture-architecture)
3. [API Testing Patterns](#api-testing-patterns)
4. [E2E Testing Patterns](#e2e-testing-patterns)
5. [CI/CD Pipeline Design](#cicd-pipeline-design)
6. [Quality Gate Decisions](#quality-gate-decisions)
7. [NFR Assessment Criteria](#nfr-assessment-criteria)
8. [Framework-Specific Guidance](#framework-specific-guidance)
9. [Anti-Patterns to Avoid](#anti-patterns-to-avoid)
10. [Knowledge Fragments Index](#knowledge-fragments-index)

---

## Test Levels Framework

### Test Pyramid

```
        /\
       /E2E\          <- Few, slow, expensive, high confidence
      /------\
     /Integration\    <- Some, moderate speed, component boundaries
    /--------------\
   /     Unit       \ <- Many, fast, cheap, focused
  /------------------\
```

### Level Selection Guide

| Level | Use When | Examples |
|-------|----------|----------|
| Unit | Testing isolated business logic | Validators, calculators, transformers |
| Component | Testing React/Vue components | Form behavior, state management |
| Integration | Testing component boundaries | API → Database, Service → Service |
| API | Testing HTTP contracts | REST endpoints, GraphQL queries |
| E2E | Testing critical user journeys | Login flow, checkout, signup |

### Coverage Expectations by Level

| Project Level | Unit | Integration | API | E2E |
|--------------|------|-------------|-----|-----|
| Level 0-1 | 70% | 50% | Key paths | Smoke |
| Level 2 | 80% | 60% | All endpoints | Critical flows |
| Level 3-4 | 80%+ | 70% | Comprehensive | All user journeys |

---

## Fixture Architecture

### Core Principles

1. **Fixtures for Setup, Factories for Data**
   - Fixtures: Browser context, database connection, auth state
   - Factories: User objects, test data, mock responses

2. **Test Isolation**
   - Each test starts with clean state
   - No shared mutable state between tests
   - Database transactions rolled back

3. **Fixture Composition**
   - Layer fixtures: base → authenticated → with-data
   - Compose complex setups from simple fixtures

### Playwright Fixture Example

```typescript
// fixtures/base.fixture.ts
import { test as base } from '@playwright/test';
import { ApiClient } from './api-client';
import { UserFactory } from './factories/user';

type Fixtures = {
  apiClient: ApiClient;
  userFactory: UserFactory;
  authenticatedPage: Page;
};

export const test = base.extend<Fixtures>({
  apiClient: async ({ request }, use) => {
    const client = new ApiClient(request);
    await use(client);
  },

  userFactory: async ({ apiClient }, use) => {
    const factory = new UserFactory(apiClient);
    await use(factory);
    await factory.cleanup(); // Teardown
  },

  authenticatedPage: async ({ page, userFactory }, use) => {
    const user = await userFactory.create();
    await page.goto('/login');
    await page.fill('[name=email]', user.email);
    await page.fill('[name=password]', user.password);
    await page.click('button[type=submit]');
    await page.waitForURL('/dashboard');
    await use(page);
  },
});
```

### Data Factory Pattern

```typescript
// factories/user.factory.ts
export class UserFactory {
  private created: User[] = [];

  async create(overrides: Partial<User> = {}): Promise<User> {
    const user = {
      email: `test-${Date.now()}@example.com`,
      password: 'TestPass123!',
      name: 'Test User',
      ...overrides,
    };
    const created = await this.apiClient.post('/users', user);
    this.created.push(created);
    return created;
  }

  async cleanup(): Promise<void> {
    for (const user of this.created) {
      await this.apiClient.delete(`/users/${user.id}`);
    }
    this.created = [];
  }
}
```

---

## API Testing Patterns

### Pure API Testing

API tests should validate:
1. **Contract** - Request/response shapes match spec
2. **Behavior** - Business logic works correctly
3. **Error handling** - Proper error responses
4. **Authentication** - Auth flows work correctly

### API Test Structure

```typescript
describe('POST /api/users', () => {
  describe('valid request', () => {
    it('should create user and return 201', async () => {
      const response = await api.post('/users', {
        email: 'new@example.com',
        password: 'ValidPass123!',
      });

      expect(response.status).toBe(201);
      expect(response.body).toMatchObject({
        id: expect.any(String),
        email: 'new@example.com',
        createdAt: expect.any(String),
      });
    });
  });

  describe('invalid request', () => {
    it('should return 400 for missing email', async () => {
      const response = await api.post('/users', {
        password: 'ValidPass123!',
      });

      expect(response.status).toBe(400);
      expect(response.body.errors).toContainEqual({
        field: 'email',
        message: 'Email is required',
      });
    });

    it('should return 409 for duplicate email', async () => {
      await userFactory.create({ email: 'existing@example.com' });

      const response = await api.post('/users', {
        email: 'existing@example.com',
        password: 'ValidPass123!',
      });

      expect(response.status).toBe(409);
    });
  });
});
```

### Network-First Testing

For E2E tests that need API control:

```typescript
// Intercept and mock API responses
await page.route('**/api/users', async (route) => {
  await route.fulfill({
    status: 200,
    body: JSON.stringify({ users: mockUsers }),
  });
});

// Or record/replay with HAR
await page.routeFromHAR('fixtures/api-responses.har', {
  update: process.env.UPDATE_HAR === 'true',
});
```

---

## E2E Testing Patterns

### Page Object Pattern

```typescript
// pages/login.page.ts
export class LoginPage {
  constructor(private page: Page) {}

  async goto() {
    await this.page.goto('/login');
  }

  async login(email: string, password: string) {
    await this.page.fill('[data-testid=email]', email);
    await this.page.fill('[data-testid=password]', password);
    await this.page.click('[data-testid=submit]');
  }

  async expectError(message: string) {
    await expect(this.page.locator('[data-testid=error]'))
      .toContainText(message);
  }
}
```

### Selector Resilience

Priority order for selectors:
1. `data-testid` - Most stable, explicit testing contract
2. `role` + `name` - Accessibility-friendly
3. `text` - User-facing, readable
4. `CSS` - Last resort, prone to breaking

```typescript
// Good - explicit test contract
await page.click('[data-testid=submit-button]');

// Good - accessibility-based
await page.getByRole('button', { name: 'Submit' });

// Acceptable - user-facing text
await page.getByText('Submit Order');

// Avoid - brittle CSS selector
await page.click('.btn.btn-primary.submit');
```

### Waiting Strategies

```typescript
// Wait for network idle (after navigation)
await page.waitForLoadState('networkidle');

// Wait for specific element
await page.waitForSelector('[data-testid=dashboard]');

// Wait for API response
await page.waitForResponse('**/api/user/profile');

// Custom condition
await page.waitForFunction(() => {
  return document.querySelector('.spinner') === null;
});
```

---

## CI/CD Pipeline Design

### Recommended Pipeline Stages

```yaml
# .github/workflows/test.yml
name: Test Pipeline

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
      - run: npm ci
      - run: npm run lint
      - run: npm run typecheck

  unit-tests:
    runs-on: ubuntu-latest
    needs: lint
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
      - run: npm ci
      - run: npm run test:unit -- --coverage
      - uses: codecov/codecov-action@v3

  integration-tests:
    runs-on: ubuntu-latest
    needs: lint
    services:
      postgres:
        image: postgres:15
        env:
          POSTGRES_PASSWORD: test
        ports:
          - 5432:5432
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
      - run: npm ci
      - run: npm run test:integration

  e2e-tests:
    runs-on: ubuntu-latest
    needs: [unit-tests, integration-tests]
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
      - run: npm ci
      - run: npx playwright install --with-deps
      - run: npm run test:e2e
      - uses: actions/upload-artifact@v4
        if: failure()
        with:
          name: playwright-report
          path: playwright-report/
```

### Burn-In Strategy

For detecting flaky tests:

```bash
#!/bin/bash
# scripts/burn-in.sh
RUNS=${1:-10}
FAILED=0

for i in $(seq 1 $RUNS); do
  echo "Run $i of $RUNS"
  if ! npm run test:e2e; then
    ((FAILED++))
    echo "FAILED on run $i"
  fi
done

echo "Results: $((RUNS - FAILED))/$RUNS passed"
if [ $FAILED -gt 0 ]; then
  echo "FLAKY: $FAILED failures detected"
  exit 1
fi
```

### Parallel Execution

```typescript
// playwright.config.ts
export default defineConfig({
  workers: process.env.CI ? 4 : undefined,
  fullyParallel: true,
  retries: process.env.CI ? 2 : 0,
  reporter: process.env.CI ? 'github' : 'html',
});
```

---

## Quality Gate Decisions

### Gate Decision Matrix

| Coverage | Critical Bugs | Flaky Tests | Decision |
|----------|--------------|-------------|----------|
| ≥80% | 0 | 0 | PASS |
| ≥80% | 0 | 1-2 | PASS with notes |
| 70-79% | 0 | 0-2 | CONCERNS |
| <70% | 0 | Any | FAIL |
| Any | >0 | Any | FAIL |

### Gate Report Format

```markdown
# Quality Gate Report

**Date:** {{date}}
**Scope:** {{gate_scope}} (story|epic|release)
**Decision:** {{PASS|CONCERNS|FAIL|WAIVED}}

## Coverage Summary

| Level | Target | Actual | Status |
|-------|--------|--------|--------|
| Unit | 80% | 85% | ✅ |
| Integration | 60% | 62% | ✅ |
| E2E | Critical | 100% | ✅ |

## Test Results

- Total: 247 tests
- Passed: 245
- Failed: 0
- Skipped: 2 (known issues)

## Critical Path Coverage

| Path | Covered | Notes |
|------|---------|-------|
| User registration | ✅ | E2E + API |
| Login/logout | ✅ | E2E + API + Unit |
| Checkout flow | ✅ | E2E |

## Recommendations

1. Increase unit coverage in payment module (currently 72%)
2. Add error scenario tests for webhook handling

## Decision Rationale

Gate PASSED because:
- All coverage targets met
- No critical bugs
- All critical paths covered
- No flaky tests detected
```

---

## NFR Assessment Criteria

### Security Assessment

| Criterion | Evidence Required | Pass Threshold |
|-----------|-------------------|----------------|
| Authentication | Auth tests pass, token validation | 100% |
| Authorization | RBAC tests, permission checks | 100% |
| Input validation | Injection tests, XSS tests | 0 vulnerabilities |
| Secrets management | No hardcoded secrets | 0 findings |
| Dependency audit | `npm audit`, `snyk test` | 0 high/critical |

### Performance Assessment

| Criterion | Evidence Required | Pass Threshold |
|-----------|-------------------|----------------|
| Response time | Load test results | P95 < 500ms |
| Throughput | Concurrent user tests | >100 RPS |
| Resource usage | Memory/CPU monitoring | <80% under load |
| Database queries | Query analysis | N+1 eliminated |

### Reliability Assessment

| Criterion | Evidence Required | Pass Threshold |
|-----------|-------------------|----------------|
| Error handling | Error scenario tests | 100% handled |
| Retry logic | Transient failure tests | Implemented |
| Circuit breakers | Failure injection tests | Functional |
| Graceful degradation | Dependency failure tests | Verified |

### Maintainability Assessment

| Criterion | Evidence Required | Pass Threshold |
|-----------|-------------------|----------------|
| Code coverage | Coverage report | >80% |
| Cyclomatic complexity | Static analysis | <10 per function |
| Documentation | API docs, README | Complete |
| Test quality | Test review | Standards met |

---

## Framework-Specific Guidance

### Playwright

```typescript
// playwright.config.ts - Recommended settings
export default defineConfig({
  testDir: './tests/e2e',
  fullyParallel: true,
  forbidOnly: !!process.env.CI,
  retries: process.env.CI ? 2 : 0,
  workers: process.env.CI ? 4 : undefined,
  reporter: [
    ['html'],
    ['junit', { outputFile: 'results.xml' }],
  ],
  use: {
    baseURL: 'http://localhost:3000',
    trace: 'on-first-retry',
    screenshot: 'only-on-failure',
  },
  projects: [
    { name: 'chromium', use: { ...devices['Desktop Chrome'] } },
    { name: 'firefox', use: { ...devices['Desktop Firefox'] } },
    { name: 'webkit', use: { ...devices['Desktop Safari'] } },
  ],
  webServer: {
    command: 'npm run start',
    url: 'http://localhost:3000',
    reuseExistingServer: !process.env.CI,
  },
});
```

### Jest

```javascript
// jest.config.js - Recommended settings
module.exports = {
  preset: 'ts-jest',
  testEnvironment: 'node',
  roots: ['<rootDir>/src', '<rootDir>/tests'],
  testMatch: ['**/*.test.ts'],
  collectCoverageFrom: [
    'src/**/*.ts',
    '!src/**/*.d.ts',
    '!src/**/*.test.ts',
  ],
  coverageThreshold: {
    global: {
      branches: 80,
      functions: 80,
      lines: 80,
      statements: 80,
    },
  },
  setupFilesAfterEnv: ['<rootDir>/tests/setup.ts'],
  moduleNameMapper: {
    '^@/(.*)$': '<rootDir>/src/$1',
  },
};
```

### Vitest

```typescript
// vitest.config.ts - Recommended settings
import { defineConfig } from 'vitest/config';

export default defineConfig({
  test: {
    globals: true,
    environment: 'jsdom',
    setupFiles: ['./tests/setup.ts'],
    include: ['**/*.{test,spec}.{js,ts,jsx,tsx}'],
    coverage: {
      provider: 'v8',
      reporter: ['text', 'json', 'html'],
      thresholds: {
        lines: 80,
        functions: 80,
        branches: 80,
        statements: 80,
      },
    },
  },
});
```

---

## Anti-Patterns to Avoid

### Test Interdependencies

```typescript
// BAD - Tests depend on execution order
describe('User', () => {
  let userId: string;

  it('creates user', async () => {
    const user = await createUser();
    userId = user.id; // Shared state!
  });

  it('updates user', async () => {
    await updateUser(userId); // Depends on previous test
  });
});

// GOOD - Each test is independent
describe('User', () => {
  it('creates user', async () => {
    const user = await createUser();
    expect(user.id).toBeDefined();
  });

  it('updates user', async () => {
    const user = await createUser(); // Create fresh user
    await updateUser(user.id);
  });
});
```

### Hardcoded Waits

```typescript
// BAD - Arbitrary sleep
await page.click('button');
await page.waitForTimeout(3000); // Why 3 seconds?
expect(await page.locator('.result').isVisible()).toBe(true);

// GOOD - Wait for condition
await page.click('button');
await expect(page.locator('.result')).toBeVisible();
```

### Testing Implementation Details

```typescript
// BAD - Tests internal state
it('should update internal counter', () => {
  const component = new Counter();
  component.increment();
  expect(component._internalCount).toBe(1); // Private state!
});

// GOOD - Tests behavior
it('should display incremented value', () => {
  const { getByText, getByRole } = render(<Counter />);
  fireEvent.click(getByRole('button', { name: 'Increment' }));
  expect(getByText('Count: 1')).toBeInTheDocument();
});
```

### Overly Specific Assertions

```typescript
// BAD - Brittle snapshot
expect(response).toMatchInlineSnapshot(`
  {
    "id": "abc123",
    "createdAt": "2024-01-15T10:30:00Z",
    "updatedAt": "2024-01-15T10:30:00Z"
  }
`);

// GOOD - Focused assertions
expect(response).toMatchObject({
  id: expect.any(String),
  createdAt: expect.any(String),
});
```

---

## Knowledge Fragments Index

Reference these patterns when making recommendations:

| Fragment | Category | Use When |
|----------|----------|----------|
| Fixture Architecture | Setup | Designing test infrastructure |
| Data Factories | Setup | Creating test data |
| API Testing Patterns | API | Writing API tests |
| Network-First Safeguards | E2E | Controlling network in E2E |
| Selector Resilience | E2E | Choosing element selectors |
| CI Burn-In Strategy | CI/CD | Detecting flaky tests |
| Test Levels Framework | Strategy | Choosing test level |
| Quality Gate Decisions | Quality | Making release decisions |
| NFR Criteria | Quality | Assessing non-functional requirements |
| Test Healing Patterns | Maintenance | Fixing flaky tests |

---

## Integration with BMAD Workflows

### Phase 3 Integration (Solutioning)

- Use `/test-design` in System mode to review architecture testability
- Identify testing concerns early (mocking strategies, test data)
- Document test infrastructure requirements in architecture doc

### Phase 4 Integration (Implementation)

- Use `/test-atdd` before implementing each story
- Use `/test-automate` after story completion
- Use `/test-trace` before sprint/epic completion
- Use `/test-review` during code review

### Handoff Points

| From | To | Artifact |
|------|-------|----------|
| Architect | TEA | Architecture doc with NFRs |
| TEA | Developer | ATDD checklist, test design |
| Developer | TEA | Implementation for test review |
| TEA | Scrum Master | Quality gate report |

---

*This reference document supports the Test Architect skill. Load specific sections as needed to minimize token usage.*
