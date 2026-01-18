# Test Framework Documentation

**Project:** {{project_name}}
**Date:** {{date}}
**Test Architect:** TEA (Murat)

---

## Overview

This document describes the test infrastructure for {{project_name}}.

## Test Stack

| Layer | Framework | Purpose |
|-------|-----------|---------|
| Unit | {{unit_framework}} | Isolated function/component testing |
| Integration | {{integration_framework}} | Component boundary testing |
| E2E | {{e2e_framework}} | User journey testing |
| API | {{api_framework}} | HTTP contract testing |

## Directory Structure

```
tests/
├── unit/                 # Unit tests ({{unit_framework}})
│   ├── components/       # Component unit tests
│   └── utils/            # Utility function tests
├── integration/          # Integration tests
│   ├── api/              # API integration tests
│   └── services/         # Service integration tests
├── e2e/                  # End-to-end tests ({{e2e_framework}})
│   ├── flows/            # User flow tests
│   └── pages/            # Page object models
├── fixtures/             # Shared test fixtures
│   ├── base.fixture.ts   # Base fixture with common setup
│   └── auth.fixture.ts   # Authentication fixture
├── factories/            # Test data factories
│   ├── user.factory.ts   # User data factory
│   └── index.ts          # Factory exports
├── helpers/              # Test utilities
│   ├── api-client.ts     # API client for tests
│   └── assertions.ts     # Custom assertions
└── README.md             # This file
```

## Running Tests

```bash
# Run all tests
npm test

# Run unit tests only
npm run test:unit

# Run integration tests
npm run test:integration

# Run E2E tests
npm run test:e2e

# Run with coverage
npm run test:coverage

# Run specific test file
npm test -- path/to/test.spec.ts

# Run tests matching pattern
npm test -- --grep "user login"
```

## Configuration Files

| File | Purpose |
|------|---------|
| `{{unit_config}}` | Unit test configuration |
| `{{integration_config}}` | Integration test configuration |
| `{{e2e_config}}` | E2E test configuration |

## Fixture Architecture

### Base Fixtures

All tests inherit from base fixtures that provide:
- Clean database state (transaction rollback)
- API client setup
- Authentication helpers
- Test data factories

```typescript
import { test } from '../fixtures/base.fixture';

test('example test', async ({ apiClient, userFactory }) => {
  const user = await userFactory.create();
  // Test with isolated data
});
```

### Authentication Fixture

For tests requiring authenticated state:

```typescript
import { test } from '../fixtures/auth.fixture';

test('authenticated test', async ({ authenticatedPage, currentUser }) => {
  // Page is logged in as currentUser
});
```

## Data Factories

Use factories for creating test data:

```typescript
import { UserFactory, ProductFactory } from '../factories';

// Create single entity
const user = await userFactory.create();

// Create with overrides
const admin = await userFactory.create({ role: 'admin' });

// Create multiple
const users = await userFactory.createMany(5);

// Cleanup handled automatically after test
```

## Coverage Requirements

| Level | Target | Current |
|-------|--------|---------|
| Unit | 80% | {{unit_coverage}}% |
| Integration | 60% | {{integration_coverage}}% |
| E2E | Critical paths | {{e2e_status}} |

## CI/CD Integration

Tests run automatically on:
- Pull request creation
- Push to main/develop branches
- Nightly full regression

Pipeline stages:
1. Lint & Type Check
2. Unit Tests (parallel)
3. Integration Tests
4. E2E Tests (sharded)
5. Coverage Report

## Best Practices

### Do
- Write descriptive test names: `should_[expected]_when_[condition]`
- Use fixtures for setup, factories for data
- Test one behavior per test
- Use explicit assertions over snapshots
- Clean up after tests (handled by fixtures)

### Don't
- Share mutable state between tests
- Use arbitrary `sleep()` or `waitForTimeout()`
- Test implementation details
- Skip tests without tracking issue
- Ignore flaky tests (treat as critical debt)

## Troubleshooting

### Common Issues

**Tests fail locally but pass in CI:**
- Check environment variables
- Verify test isolation (no shared state)
- Check for timing issues

**Flaky E2E tests:**
- Use explicit waits instead of timeouts
- Check for race conditions
- Verify test data isolation

**Coverage not increasing:**
- Check coverage includes correct directories
- Verify source maps are correct
- Check for excluded patterns

## Contact

For test infrastructure questions, use the `/test-review` command or consult the Test Architect skill.
