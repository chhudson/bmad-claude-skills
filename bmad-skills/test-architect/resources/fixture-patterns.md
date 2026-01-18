# Fixture Architecture Guide

Comprehensive guide to building maintainable test fixtures.

## Core Concepts

### Fixtures vs Factories

| Fixtures | Factories |
|----------|-----------|
| Setup/teardown logic | Data creation |
| Browser context, DB connection | User objects, test records |
| Shared across tests | Fresh per test |
| Lifecycle management | Data generation |

**Rule:** Use fixtures for **infrastructure**, factories for **data**.

## Playwright Fixture Architecture

### Base Fixture

```typescript
// fixtures/base.fixture.ts
import { test as base, Page } from '@playwright/test';
import { ApiClient } from './api-client';

type BaseFixtures = {
  apiClient: ApiClient;
  testId: string;
};

export const test = base.extend<BaseFixtures>({
  // API client fixture
  apiClient: async ({ request }, use) => {
    const client = new ApiClient(request);
    await use(client);
  },

  // Unique test ID for data isolation
  testId: async ({}, use) => {
    const id = `test-${Date.now()}-${Math.random().toString(36).slice(2)}`;
    await use(id);
  },
});

export { expect } from '@playwright/test';
```

### Authentication Fixture

```typescript
// fixtures/auth.fixture.ts
import { test as base } from './base.fixture';
import { UserFactory } from './factories/user';

type AuthFixtures = {
  userFactory: UserFactory;
  authenticatedPage: Page;
  currentUser: User;
};

export const test = base.extend<AuthFixtures>({
  userFactory: async ({ apiClient }, use) => {
    const factory = new UserFactory(apiClient);
    await use(factory);
    await factory.cleanup();
  },

  currentUser: async ({ userFactory }, use) => {
    const user = await userFactory.create();
    await use(user);
  },

  authenticatedPage: async ({ page, currentUser }, use) => {
    // Perform login
    await page.goto('/login');
    await page.fill('[data-testid=email]', currentUser.email);
    await page.fill('[data-testid=password]', currentUser.password);
    await page.click('[data-testid=submit]');
    await page.waitForURL('/dashboard');

    await use(page);
  },
});
```

### Database Fixture

```typescript
// fixtures/db.fixture.ts
import { test as base } from './base.fixture';
import { db, Transaction } from '../utils/db';

type DbFixtures = {
  dbTransaction: Transaction;
  dbCleanup: () => Promise<void>;
};

export const test = base.extend<DbFixtures>({
  dbTransaction: async ({}, use) => {
    const transaction = await db.beginTransaction();
    await use(transaction);
    await transaction.rollback();
  },

  dbCleanup: async ({ testId }, use) => {
    const cleanup = async () => {
      // Clean up test data by testId prefix
      await db.query('DELETE FROM users WHERE email LIKE $1', [`${testId}%`]);
    };
    await use(cleanup);
    await cleanup();
  },
});
```

### Composed Fixtures

```typescript
// fixtures/full.fixture.ts
import { mergeTests } from '@playwright/test';
import { test as baseTest } from './base.fixture';
import { test as authTest } from './auth.fixture';
import { test as dbTest } from './db.fixture';

// Combine all fixtures
export const test = mergeTests(baseTest, authTest, dbTest);
export { expect } from '@playwright/test';
```

## Factory Patterns

### Basic Factory

```typescript
// factories/user.factory.ts
export class UserFactory {
  private created: User[] = [];

  constructor(private apiClient: ApiClient) {}

  build(overrides: Partial<User> = {}): UserInput {
    return {
      email: `test-${Date.now()}@example.com`,
      password: 'TestPass123!',
      name: 'Test User',
      ...overrides,
    };
  }

  async create(overrides: Partial<User> = {}): Promise<User> {
    const data = this.build(overrides);
    const user = await this.apiClient.post<User>('/users', data);
    this.created.push(user);
    return user;
  }

  async createMany(count: number, overrides: Partial<User> = {}): Promise<User[]> {
    const users: User[] = [];
    for (let i = 0; i < count; i++) {
      users.push(await this.create({
        ...overrides,
        email: `test-${Date.now()}-${i}@example.com`,
      }));
    }
    return users;
  }

  async cleanup(): Promise<void> {
    for (const user of this.created) {
      try {
        await this.apiClient.delete(`/users/${user.id}`);
      } catch (e) {
        // Ignore cleanup errors
      }
    }
    this.created = [];
  }
}
```

### Factory with Traits

```typescript
// factories/user.factory.ts
type UserTrait = 'admin' | 'verified' | 'withPosts';

export class UserFactory {
  private traits: Record<UserTrait, Partial<User>> = {
    admin: { role: 'admin' },
    verified: { emailVerified: true },
    withPosts: {}, // Handled specially
  };

  build(...traits: UserTrait[]): UserInput {
    let data: Partial<User> = {
      email: `test-${Date.now()}@example.com`,
      password: 'TestPass123!',
    };

    for (const trait of traits) {
      data = { ...data, ...this.traits[trait] };
    }

    return data as UserInput;
  }

  async create(...traits: UserTrait[]): Promise<User> {
    const data = this.build(...traits.filter(t => t !== 'withPosts'));
    const user = await this.apiClient.post<User>('/users', data);

    if (traits.includes('withPosts')) {
      await this.createPostsForUser(user);
    }

    return user;
  }
}

// Usage
const adminUser = await userFactory.create('admin', 'verified');
```

### Dependent Factory

```typescript
// factories/order.factory.ts
export class OrderFactory {
  constructor(
    private apiClient: ApiClient,
    private userFactory: UserFactory,
    private productFactory: ProductFactory
  ) {}

  async create(overrides: Partial<OrderInput> = {}): Promise<Order> {
    // Create dependencies if not provided
    const user = overrides.userId
      ? { id: overrides.userId }
      : await this.userFactory.create();

    const products = overrides.productIds?.length
      ? overrides.productIds.map(id => ({ id }))
      : [await this.productFactory.create()];

    return this.apiClient.post<Order>('/orders', {
      userId: user.id,
      productIds: products.map(p => p.id),
      ...overrides,
    });
  }
}
```

## Jest/Vitest Fixture Patterns

### Setup/Teardown Fixtures

```typescript
// setup.ts
import { beforeAll, afterAll, beforeEach, afterEach } from 'vitest';

let dbConnection: Database;

beforeAll(async () => {
  dbConnection = await Database.connect(process.env.TEST_DB_URL);
});

afterAll(async () => {
  await dbConnection.close();
});

beforeEach(async () => {
  await dbConnection.beginTransaction();
});

afterEach(async () => {
  await dbConnection.rollback();
});

export { dbConnection };
```

### Context Pattern

```typescript
// test-context.ts
export interface TestContext {
  db: Database;
  userFactory: UserFactory;
  apiClient: ApiClient;
}

export async function createTestContext(): Promise<TestContext> {
  const db = await Database.connect();
  const apiClient = new ApiClient();
  const userFactory = new UserFactory(apiClient);

  return { db, userFactory, apiClient };
}

export async function cleanupTestContext(ctx: TestContext): Promise<void> {
  await ctx.userFactory.cleanup();
  await ctx.db.close();
}

// Usage in tests
describe('Feature', () => {
  let ctx: TestContext;

  beforeAll(async () => {
    ctx = await createTestContext();
  });

  afterAll(async () => {
    await cleanupTestContext(ctx);
  });

  it('should work', async () => {
    const user = await ctx.userFactory.create();
    // ...
  });
});
```

## Best Practices

### 1. Isolation

```typescript
// BAD - Shared state
let globalUser: User;

beforeAll(async () => {
  globalUser = await createUser(); // Shared across tests!
});

// GOOD - Fresh per test
test('example', async ({ userFactory }) => {
  const user = await userFactory.create(); // Fresh for this test
});
```

### 2. Cleanup

```typescript
// Always cleanup in reverse order of creation
afterEach(async () => {
  await orderFactory.cleanup();  // First (depends on users/products)
  await productFactory.cleanup();
  await userFactory.cleanup();   // Last
});
```

### 3. Deterministic Data

```typescript
// BAD - Non-deterministic
const user = {
  createdAt: new Date(), // Different each run
  id: uuid(),            // Different each run
};

// GOOD - Deterministic for tests
const user = {
  createdAt: new Date('2024-01-01T00:00:00Z'),
  id: 'test-user-001',
};
```

### 4. Minimal Setup

```typescript
// BAD - Excessive setup
const user = await userFactory.create({
  name: 'Test',
  email: 'test@example.com',
  role: 'user',
  settings: { theme: 'dark', notifications: true },
  profile: { bio: 'Test bio', avatar: 'url' },
  // ... 20 more fields
});

// GOOD - Only what's needed
const user = await userFactory.create({
  role: 'admin', // Only specify what matters for this test
});
```

### 5. Fixture Composition

```typescript
// Compose fixtures for specific scenarios
export const test = base.extend({
  // Scenario: User with completed order
  orderScenario: async ({ userFactory, productFactory, orderFactory }, use) => {
    const user = await userFactory.create();
    const product = await productFactory.create({ price: 99.99 });
    const order = await orderFactory.create({
      userId: user.id,
      productIds: [product.id],
      status: 'completed',
    });

    await use({ user, product, order });
  },
});

// Usage
test('should show order history', async ({ page, orderScenario }) => {
  // orderScenario.user, orderScenario.order available
});
```

---

*Use these patterns to build maintainable, isolated test fixtures.*
