# Common Test Patterns Reference

Quick reference for common testing patterns. Use these as templates when writing tests.

## Unit Test Patterns

### Basic Unit Test

```typescript
describe('functionName', () => {
  it('should [expected] when [condition]', () => {
    // Arrange
    const input = { /* test data */ };

    // Act
    const result = functionName(input);

    // Assert
    expect(result).toBe(expected);
  });
});
```

### Testing Async Functions

```typescript
describe('asyncFunction', () => {
  it('should resolve with data', async () => {
    const result = await asyncFunction();
    expect(result).toEqual(expectedData);
  });

  it('should reject on error', async () => {
    await expect(asyncFunction()).rejects.toThrow('Expected error');
  });
});
```

### Testing with Mocks

```typescript
import { vi } from 'vitest'; // or jest.fn()

describe('withDependency', () => {
  it('should call dependency', () => {
    const mockDep = vi.fn().mockReturnValue('mocked');

    const result = functionWithDep(mockDep);

    expect(mockDep).toHaveBeenCalledWith(expectedArgs);
    expect(result).toBe('mocked');
  });
});
```

### Parameterized Tests

```typescript
describe('validator', () => {
  const cases = [
    { input: 'valid@email.com', expected: true },
    { input: 'invalid', expected: false },
    { input: '', expected: false },
  ];

  test.each(cases)('validates "$input" as $expected', ({ input, expected }) => {
    expect(isValidEmail(input)).toBe(expected);
  });
});
```

## Component Test Patterns

### React Component Test

```typescript
import { render, screen, fireEvent } from '@testing-library/react';

describe('Button', () => {
  it('should call onClick when clicked', () => {
    const handleClick = vi.fn();
    render(<Button onClick={handleClick}>Click me</Button>);

    fireEvent.click(screen.getByRole('button', { name: 'Click me' }));

    expect(handleClick).toHaveBeenCalledTimes(1);
  });
});
```

### Testing Form Submission

```typescript
describe('LoginForm', () => {
  it('should submit credentials', async () => {
    const onSubmit = vi.fn();
    render(<LoginForm onSubmit={onSubmit} />);

    await userEvent.type(screen.getByLabelText('Email'), 'test@example.com');
    await userEvent.type(screen.getByLabelText('Password'), 'password123');
    await userEvent.click(screen.getByRole('button', { name: 'Login' }));

    expect(onSubmit).toHaveBeenCalledWith({
      email: 'test@example.com',
      password: 'password123',
    });
  });
});
```

## API Test Patterns

### REST Endpoint Test

```typescript
describe('POST /api/users', () => {
  it('should create user', async () => {
    const response = await request(app)
      .post('/api/users')
      .send({ email: 'new@example.com', password: 'Pass123!' })
      .expect(201);

    expect(response.body).toMatchObject({
      id: expect.any(String),
      email: 'new@example.com',
    });
  });

  it('should return 400 for invalid email', async () => {
    const response = await request(app)
      .post('/api/users')
      .send({ email: 'invalid', password: 'Pass123!' })
      .expect(400);

    expect(response.body.errors).toContainEqual(
      expect.objectContaining({ field: 'email' })
    );
  });
});
```

### GraphQL Query Test

```typescript
describe('users query', () => {
  it('should return user list', async () => {
    const query = `
      query {
        users {
          id
          email
        }
      }
    `;

    const response = await request(app)
      .post('/graphql')
      .send({ query })
      .expect(200);

    expect(response.body.data.users).toBeInstanceOf(Array);
  });
});
```

## E2E Test Patterns

### Page Navigation Test

```typescript
test('should navigate to dashboard after login', async ({ page }) => {
  await page.goto('/login');
  await page.fill('[data-testid=email]', 'user@example.com');
  await page.fill('[data-testid=password]', 'password');
  await page.click('[data-testid=submit]');

  await expect(page).toHaveURL('/dashboard');
  await expect(page.locator('h1')).toContainText('Welcome');
});
```

### Form Validation Test

```typescript
test('should show validation errors', async ({ page }) => {
  await page.goto('/register');
  await page.click('[data-testid=submit]');

  await expect(page.locator('[data-testid=email-error]'))
    .toContainText('Email is required');
  await expect(page.locator('[data-testid=password-error]'))
    .toContainText('Password is required');
});
```

### API Interception Test

```typescript
test('should handle API error gracefully', async ({ page }) => {
  await page.route('**/api/users', route =>
    route.fulfill({ status: 500, body: 'Server error' })
  );

  await page.goto('/users');

  await expect(page.locator('[data-testid=error-message]'))
    .toContainText('Unable to load users');
});
```

## Error Handling Patterns

### Testing Error Boundaries

```typescript
describe('ErrorBoundary', () => {
  it('should catch and display error', () => {
    const ThrowError = () => { throw new Error('Test error'); };

    render(
      <ErrorBoundary fallback={<div>Error occurred</div>}>
        <ThrowError />
      </ErrorBoundary>
    );

    expect(screen.getByText('Error occurred')).toBeInTheDocument();
  });
});
```

### Testing Retry Logic

```typescript
describe('fetchWithRetry', () => {
  it('should retry on failure', async () => {
    const mockFetch = vi.fn()
      .mockRejectedValueOnce(new Error('Network error'))
      .mockRejectedValueOnce(new Error('Network error'))
      .mockResolvedValueOnce({ data: 'success' });

    const result = await fetchWithRetry(mockFetch, { maxRetries: 3 });

    expect(mockFetch).toHaveBeenCalledTimes(3);
    expect(result).toEqual({ data: 'success' });
  });
});
```

## Database Test Patterns

### Transaction Rollback Pattern

```typescript
describe('UserRepository', () => {
  let transaction: Transaction;

  beforeEach(async () => {
    transaction = await db.beginTransaction();
  });

  afterEach(async () => {
    await transaction.rollback();
  });

  it('should create user', async () => {
    const repo = new UserRepository(transaction);
    const user = await repo.create({ email: 'test@example.com' });
    expect(user.id).toBeDefined();
  });
});
```

### Factory Pattern

```typescript
// factories/user.factory.ts
export const userFactory = {
  build: (overrides = {}) => ({
    email: `user-${Date.now()}@example.com`,
    name: 'Test User',
    role: 'user',
    ...overrides,
  }),

  create: async (overrides = {}) => {
    const data = userFactory.build(overrides);
    return await UserRepository.create(data);
  },
};
```

## Assertion Patterns

### Object Matching

```typescript
// Partial match
expect(result).toMatchObject({
  name: 'Test',
  email: expect.any(String),
});

// Array containing
expect(result).toContainEqual(
  expect.objectContaining({ id: '123' })
);

// Negation
expect(result).not.toContain('secret');
```

### Custom Matchers

```typescript
expect.extend({
  toBeValidEmail(received) {
    const pass = /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(received);
    return {
      pass,
      message: () => `expected ${received} to be a valid email`,
    };
  },
});

// Usage
expect('test@example.com').toBeValidEmail();
```

---

*Reference these patterns when implementing tests. Adapt to your specific framework and project conventions.*
