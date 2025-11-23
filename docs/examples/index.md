---
layout: default
title: "Examples"
description: "Real-world examples of using BMAD Method for Claude Code. Complete project walkthroughs from product brief to implementation."
keywords: "BMAD examples, Claude Code tutorials, agile workflow examples, development workflow tutorial"
---

# Examples

Learn BMAD through complete, real-world examples. Each example shows the full workflow from start to finish.

---

## Example Projects

| Example | Level | Type | Skills Used |
|---------|-------|------|-------------|
| [E-commerce API](#e-commerce-api) | 2 | API | Full workflow |
| [CLI Tool](#cli-tool) | 1 | Library | Tech spec only |
| [Bug Fix](#bug-fix) | 0 | Atomic | Minimal workflow |
| [Mobile App](#mobile-app) | 3 | Mobile | Full + UX design |
| [Feature Research](#feature-research) | N/A | Research | Creative Intelligence |

---

<h2 id="e-commerce-api">Example 1: E-commerce API (Level 2)</h2>

A complete walkthrough building a product catalog API for an e-commerce platform.

### Project Setup

```
User: I want to build a product catalog API for my e-commerce site.
It should handle products, categories, search, and inventory.

Claude: I'll help you build that! Let's start by initializing BMAD.
```

### Step 1: Initialize Project

~~~~
User: /workflow-init

Claude: Welcome to BMAD! Let's configure your project.

Project name?
> E-commerce Product Catalog API

Project type?
> api

For a catalog API with products, categories, search, and inventory,
I recommend Level 2 (5-15 stories).

Project level?
> 2

Created bmad/config.yaml
Next step: /product-brief
~~~~

### Step 2: Product Brief

~~~~
User: /product-brief

Claude: I'll create a product brief for the E-commerce Product Catalog API.

## Executive Summary
What problem does this solve?
> Our current product data is spread across multiple systems.
> We need a centralized API that all clients (web, mobile, admin)
> can use to access product information.

## Target Audience
Who uses this API?
> - Frontend web application
> - iOS and Android apps
> - Admin dashboard
> - Third-party integrations

## Problem Statement
1. **Data inconsistency:** Different clients show different product info
2. **Slow queries:** Current DB queries take 2-3 seconds
3. **No search:** Customers can only browse by category
4. **Manual inventory:** Stock updates require database changes

## Success Metrics
> - API response time <100ms
> - Search results in <200ms
> - Zero data inconsistency across clients
> - Real-time inventory updates

## Constraints
> - Must integrate with existing PostgreSQL database
> - Support 1000 requests/second at peak
> - GDPR compliant for EU customers

Saving to: docs/product-brief.md
~~~~

### Step 3: PRD

~~~~
User: /prd

Claude: Creating PRD based on product brief...

Loading: docs/product-brief.md

## Functional Requirements

### FR-001: Product Management
- Create, read, update, delete products
- Product attributes: name, description, price, images, SKU
- Product variants (size, color)
- Bulk import/export

### FR-002: Category Management
- Hierarchical categories (up to 3 levels)
- Products can belong to multiple categories
- Category images and descriptions

### FR-003: Search
- Full-text search on name and description
- Faceted search (category, price range, attributes)
- Autocomplete suggestions
- Search analytics

### FR-004: Inventory
- Real-time stock levels
- Reserve stock for carts
- Low stock alerts
- Multi-warehouse support

### FR-005: Pricing
- Base price and sale price
- Bulk pricing tiers
- Currency conversion (store in cents)

## Non-Functional Requirements

### NFR-001: Performance
- GET endpoints: <100ms P95
- Search: <200ms P95
- Write endpoints: <300ms P95
- 1000 RPS sustained

### NFR-002: Availability
- 99.9% uptime
- Graceful degradation (serve cached on DB failure)

### NFR-003: Security
- API key authentication
- Rate limiting per client
- Input validation
- SQL injection protection

## Epics and Stories

### Epic 1: Product CRUD (21 pts)
- STORY-001: Product model and migrations (3)
- STORY-002: Create product endpoint (3)
- STORY-003: Read product endpoints (3)
- STORY-004: Update product endpoint (3)
- STORY-005: Delete product (soft) (2)
- STORY-006: Product variants (5)
- STORY-007: Bulk import (2)

### Epic 2: Categories (13 pts)
- STORY-008: Category model with hierarchy (5)
- STORY-009: Category CRUD (3)
- STORY-010: Product-category relationships (3)
- STORY-011: Category tree endpoint (2)

### Epic 3: Search (18 pts)
- STORY-012: Elasticsearch setup (3)
- STORY-013: Product indexing (5)
- STORY-014: Basic search endpoint (3)
- STORY-015: Faceted search (5)
- STORY-016: Autocomplete (2)

### Epic 4: Inventory (13 pts)
- STORY-017: Inventory model (2)
- STORY-018: Stock endpoints (3)
- STORY-019: Stock reservation (5)
- STORY-020: Low stock alerts (3)

### Epic 5: API Infrastructure (8 pts)
- STORY-021: API authentication (3)
- STORY-022: Rate limiting (2)
- STORY-023: Caching layer (3)

## Summary
- Total stories: 23
- Total points: 73
- Estimated sprints: 3

Saving to: docs/prd.md
~~~~

### Step 4: Architecture

~~~~
User: /architecture

Claude: Designing system architecture...

Loading: docs/prd.md

## System Overview

```
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│   Clients   │────▶│  API GW /   │────▶│   Cache     │
│ Web/Mobile  │     │  Rate Limit │     │   (Redis)   │
└─────────────┘     └──────┬──────┘     └──────┬──────┘
                           │                   │
                    ┌──────▼──────┐            │
                    │  Product    │◀───────────┘
                    │   Service   │
                    └──────┬──────┘
                           │
         ┌─────────────────┼─────────────────┐
         ▼                 ▼                 ▼
┌─────────────┐   ┌─────────────┐   ┌─────────────┐
│ PostgreSQL  │   │Elasticsearch│   │   Redis     │
│  (Primary)  │   │  (Search)   │   │  (Cache)    │
└─────────────┘   └─────────────┘   └─────────────┘
```

## Component Details

### API Gateway
- Kong for routing and rate limiting
- JWT validation
- Request logging

### Product Service
- Node.js + Express
- Handles all business logic
- Connects to all data stores

### PostgreSQL
- Products, categories, inventory tables
- Product variants as JSONB
- Read replicas for scaling

### Elasticsearch
- Product search index
- Autocomplete index
- Updated on product write (async)

### Redis
- Response caching (5 min TTL)
- Session/cart data
- Rate limit counters

## Data Models

### Product Table
```sql
CREATE TABLE products (
  id UUID PRIMARY KEY,
  sku VARCHAR(100) UNIQUE NOT NULL,
  name VARCHAR(255) NOT NULL,
  description TEXT,
  base_price_cents INTEGER NOT NULL,
  sale_price_cents INTEGER,
  variants JSONB DEFAULT '[]',
  images JSONB DEFAULT '[]',
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);
```

### Category Table
```sql
CREATE TABLE categories (
  id UUID PRIMARY KEY,
  parent_id UUID REFERENCES categories(id),
  name VARCHAR(100) NOT NULL,
  slug VARCHAR(100) UNIQUE NOT NULL,
  description TEXT,
  image_url VARCHAR(500),
  sort_order INTEGER DEFAULT 0,
  is_active BOOLEAN DEFAULT true
);
```

### Inventory Table
```sql
CREATE TABLE inventory (
  id UUID PRIMARY KEY,
  product_id UUID REFERENCES products(id),
  warehouse_id UUID REFERENCES warehouses(id),
  quantity INTEGER NOT NULL DEFAULT 0,
  reserved INTEGER NOT NULL DEFAULT 0,
  low_stock_threshold INTEGER DEFAULT 10,
  updated_at TIMESTAMP DEFAULT NOW()
);
```

## API Endpoints

### Products
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | /v1/products | List products (paginated) |
| POST | /v1/products | Create product |
| GET | /v1/products/:id | Get product by ID |
| PUT | /v1/products/:id | Update product |
| DELETE | /v1/products/:id | Soft delete product |
| POST | /v1/products/bulk | Bulk import |

### Categories
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | /v1/categories | List all categories |
| GET | /v1/categories/tree | Get category hierarchy |
| GET | /v1/categories/:id/products | Products in category |

### Search
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | /v1/search | Search products |
| GET | /v1/search/suggest | Autocomplete |

### Inventory
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | /v1/inventory/:productId | Get stock levels |
| POST | /v1/inventory/:productId/reserve | Reserve stock |
| POST | /v1/inventory/:productId/release | Release reservation |

## Technology Stack

| Component | Technology | Justification |
|-----------|------------|---------------|
| Runtime | Node.js 20 | Team expertise, async I/O |
| Framework | Express | Simple, flexible |
| Database | PostgreSQL 15 | Existing system, JSONB |
| Search | Elasticsearch 8 | Full-text, facets |
| Cache | Redis 7 | Fast, versatile |
| Gateway | Kong | Open source, plugins |

Saving to: docs/architecture.md
~~~~

### Step 5: Sprint Planning

~~~~
User: /sprint-planning

Claude: Planning sprints for E-commerce Product Catalog API...

Loading: docs/prd.md, docs/architecture.md

## Sprint Breakdown

### Sprint 1: Foundation (24 pts)
**Goal:** Core product CRUD working

- STORY-001: Product model and migrations (3)
- STORY-002: Create product endpoint (3)
- STORY-003: Read product endpoints (3)
- STORY-004: Update product endpoint (3)
- STORY-005: Delete product (2)
- STORY-008: Category model with hierarchy (5)
- STORY-009: Category CRUD (3)
- STORY-021: API authentication (3)

**Deliverable:** Create and read products and categories

### Sprint 2: Relationships & Search (24 pts)
**Goal:** Full product management with search

- STORY-006: Product variants (5)
- STORY-010: Product-category relationships (3)
- STORY-011: Category tree endpoint (2)
- STORY-012: Elasticsearch setup (3)
- STORY-013: Product indexing (5)
- STORY-014: Basic search endpoint (3)
- STORY-022: Rate limiting (2)

**Deliverable:** Products with variants, categories, and search

### Sprint 3: Inventory & Polish (25 pts)
**Goal:** Complete MVP with inventory

- STORY-015: Faceted search (5)
- STORY-016: Autocomplete (2)
- STORY-017: Inventory model (2)
- STORY-018: Stock endpoints (3)
- STORY-019: Stock reservation (5)
- STORY-020: Low stock alerts (3)
- STORY-007: Bulk import (2)
- STORY-023: Caching layer (3)

**Deliverable:** Full MVP ready for client integration

Saving to: docs/sprint-status.yaml
Creating stories in: docs/stories/
~~~~

### Step 6: Implementation

~~~~
User: /dev-story STORY-001

Claude: Implementing STORY-001: Product model and migrations

## Acceptance Criteria
- [ ] Product table created with all fields
- [ ] Indexes on SKU and is_active
- [ ] Migration file versioned
- [ ] Sequelize model created
- [ ] Unit tests for model

## Implementation

Creating migration: migrations/001-create-products.js

```javascript
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.createTable('products', {
      id: {
        type: Sequelize.UUID,
        defaultValue: Sequelize.UUIDV4,
        primaryKey: true
      },
      sku: {
        type: Sequelize.STRING(100),
        allowNull: false,
        unique: true
      },
      name: {
        type: Sequelize.STRING(255),
        allowNull: false
      },
      description: {
        type: Sequelize.TEXT
      },
      base_price_cents: {
        type: Sequelize.INTEGER,
        allowNull: false
      },
      sale_price_cents: {
        type: Sequelize.INTEGER
      },
      variants: {
        type: Sequelize.JSONB,
        defaultValue: []
      },
      images: {
        type: Sequelize.JSONB,
        defaultValue: []
      },
      is_active: {
        type: Sequelize.BOOLEAN,
        defaultValue: true
      },
      created_at: {
        type: Sequelize.DATE,
        defaultValue: Sequelize.NOW
      },
      updated_at: {
        type: Sequelize.DATE,
        defaultValue: Sequelize.NOW
      }
    });

    await queryInterface.addIndex('products', ['sku']);
    await queryInterface.addIndex('products', ['is_active']);
  },

  async down(queryInterface) {
    await queryInterface.dropTable('products');
  }
};
```

Creating model: src/models/Product.js

[... model code ...]

Creating test: tests/models/Product.test.js

[... test code ...]

## Verification

Running migration: npx sequelize-cli db:migrate
✓ Migration complete

Running tests: npm test -- --grep "Product"
✓ All tests pass

Story complete! Updating docs/stories/STORY-001.md
~~~~

### Final Result

After completing all sprints, you have:

```
ecommerce-catalog-api/
├── bmad/
│   └── config.yaml
├── docs/
│   ├── product-brief.md
│   ├── prd.md
│   ├── architecture.md
│   ├── sprint-status.yaml
│   └── stories/
│       ├── STORY-001.md through STORY-023.md
├── src/
│   ├── index.js
│   ├── models/
│   ├── routes/
│   ├── services/
│   └── middleware/
├── tests/
├── migrations/
└── package.json
```

---

<h2 id="cli-tool">Example 2: CLI Tool (Level 1)</h2>

Building a simple command-line tool for converting file formats.

### Quick Workflow

For Level 1 projects, skip the product brief and go straight to tech spec:

~~~~
User: I want to build a CLI tool that converts markdown to HTML.

User: /workflow-init
> Project: md2html CLI
> Type: library
> Level: 1

User: /tech-spec

Claude: Creating tech spec for md2html CLI...

## Overview
A command-line tool to convert Markdown files to HTML.

## Features
- Single file conversion: md2html input.md
- Batch conversion: md2html *.md
- Custom template: md2html -t template.html input.md
- Watch mode: md2html -w input.md
- Output to file: md2html -o output.html input.md

## Technical Implementation

### Dependencies
- commander: CLI argument parsing
- marked: Markdown parsing
- chokidar: File watching

### Files
- bin/md2html.js - CLI entry point
- src/converter.js - Conversion logic
- src/template.js - HTML template handling
- tests/*.test.js - Unit tests

### Usage Examples

```bash
# Basic conversion (outputs to stdout)
md2html README.md

# Save to file
md2html -o docs/readme.html README.md

# Batch convert
md2html -o build/ docs/*.md

# Watch mode
md2html -w -o build/readme.html README.md
```

## Acceptance Criteria
- [ ] Convert single .md file to HTML
- [ ] Support output file option
- [ ] Support batch conversion with glob
- [ ] Support custom HTML template
- [ ] Support watch mode
- [ ] Handle errors gracefully
- [ ] Show help with --help
- [ ] Show version with --version

## Stories (7 points total)

1. **CLI setup with commander** (2 pts)
2. **Basic markdown to HTML conversion** (2 pts)
3. **Output file and batch conversion** (2 pts)
4. **Watch mode** (1 pt)

Saving to: docs/tech-spec.md

User: /sprint-planning
[Single sprint with 4 stories]

User: /dev-story STORY-001
[Implementation]
~~~~

---

<h2 id="bug-fix">Example 3: Bug Fix (Level 0)</h2>

The minimal BMAD workflow for a single atomic change.

~~~~
User: There's a bug where user sessions expire after 5 minutes
instead of 1 hour. I need to fix it.

User: /workflow-init
> Project: Fix session timeout bug
> Type: other
> Level: 0

User: /tech-spec

Claude: Creating minimal tech spec for bug fix...

## Issue
User sessions expire after 5 minutes instead of configured 1 hour.

## Root Cause
In config/auth.js, SESSION_TIMEOUT is set to 300000 (5 min)
instead of 3600000 (1 hour).

## Fix
Change line 12 of config/auth.js:
```javascript
// Before
SESSION_TIMEOUT: 300000,

// After
SESSION_TIMEOUT: 3600000,
```

## Testing
1. Log in as test user
2. Wait 10 minutes
3. Verify session still active
4. Wait 65 minutes
5. Verify session expired

## Acceptance Criteria
- [ ] Session lasts 1 hour
- [ ] Existing sessions not affected
- [ ] No breaking changes

Saving to: docs/tech-spec.md

User: /dev-story STORY-001

Claude: Implementing session timeout fix...

[Edits config/auth.js line 12]
[Runs tests]

Bug fix complete!
~~~~

---

<h2 id="mobile-app">Example 4: Mobile App (Level 3)</h2>

A complex project with UX design included.

### Project Scope

Building a fitness tracking app with:
- Workout logging
- Progress tracking
- Social features
- Wearable integration

### Workflow with UX Design

~~~~
User: /workflow-init
> Project: FitTrack Mobile App
> Type: mobile-app
> Level: 3

User: /product-brief
[Comprehensive product brief for fitness app]

User: /prd
[Detailed PRD with 35 stories]

User: /create-ux-design

Claude: Creating UX designs for FitTrack...

## User Personas

### Primary: Active Alex
- 28, goes to gym 4x/week
- Wants to track progress
- Motivated by data and streaks

### Secondary: Beginner Beth
- 35, starting fitness journey
- Needs guidance and encouragement
- Intimidated by complex apps

## User Flows

### Onboarding Flow
1. Download → 2. Sign up → 3. Set goals → 4. Connect wearable →
5. First workout prompt → 6. Dashboard

### Log Workout Flow
1. Tap + → 2. Select workout type → 3. Start timer →
4. Log exercises → 5. Complete → 6. See summary

### View Progress Flow
1. Tap Progress → 2. Select metric → 3. View chart →
4. Filter date range → 5. Share achievement

## Wireframes

### Dashboard
```
┌─────────────────────────┐
│ FitTrack    [🔔] [👤]   │
├─────────────────────────┤
│  Good morning, Alex!    │
│                         │
│  ┌─────────┐ ┌────────┐ │
│  │ 🔥 12   │ │ 💪 4   │ │
│  │ Streak  │ │ This   │ │
│  │         │ │ Week   │ │
│  └─────────┘ └────────┘ │
│                         │
│  Today's Goal           │
│  [████████░░] 80%       │
│                         │
│  Quick Start            │
│  [Run] [Lift] [Yoga]    │
│                         │
│  Recent Activity        │
│  • Chest Day - 45m      │
│  • Morning Run - 5k     │
│                         │
│  [────] [📊] [+] [🏆]   │
└─────────────────────────┘
```

## Design System

### Colors
Primary: #FF6B35 (Orange - energy)
Secondary: #004E89 (Blue - trust)
Success: #2EC4B6 (Teal - achievement)
Background: #F7F7F7

### Typography
- Headings: Montserrat Bold
- Body: Open Sans Regular
- Numbers: Montserrat Bold (for stats)

## Accessibility

- [ ] Large touch targets (48px)
- [ ] High contrast mode
- [ ] VoiceOver/TalkBack labels
- [ ] Reduced motion option

Saving to: docs/ux-design.md

User: /architecture

Claude: Designing mobile app architecture...

## System Overview

### Mobile App (React Native)
- iOS and Android from single codebase
- Offline-first with sync
- Push notifications

### Backend Services
- Auth service (Firebase Auth)
- Workout service (Node.js)
- Social service (Node.js)
- Analytics service (Mixpanel)

### Integrations
- Apple HealthKit
- Google Fit
- Fitbit API
- Strava API

[... complete architecture ...]

User: /sprint-planning

Claude: Planning sprints...

## Sprint Overview

### Sprint 1: Foundation (26 pts)
Auth, onboarding, basic UI

### Sprint 2: Core Workout (28 pts)
Workout logging, timer, exercises

### Sprint 3: Progress (24 pts)
Charts, history, stats

### Sprint 4: Social (25 pts)
Friends, feed, achievements

### Sprint 5: Integrations (22 pts)
HealthKit, wearables, sync

### Sprint 6: Polish (15 pts)
Performance, offline, testing

Total: 140 pts over 6 sprints
~~~~

---

<h2 id="feature-research">Example 5: Feature Research (Creative Intelligence)</h2>

Using BMAD for research before committing to a project.

### Brainstorming Session

~~~~
User: We're thinking about adding AI features to our product.
I want to explore possibilities before committing.

User: /brainstorm

Claude: What topic would you like to brainstorm?
> AI-powered features for our project management tool

Which techniques?
> SCAMPER, Six Thinking Hats, SWOT

## SCAMPER Analysis

**Substitute**
- Replace manual task estimation with AI predictions
- Substitute status updates with auto-detection

**Combine**
- Combine chat + task creation (NLP to create tasks from messages)
- Merge reporting + insights (AI-generated reports)

**Adapt**
- Adapt GitHub Copilot's approach for task suggestions
- Adapt Notion's AI summarization for meeting notes

**Modify**
- Smart notifications (AI determines importance)
- Predictive resource allocation

**Put to other uses**
- Use project data to train company-specific models
- Cross-project pattern recognition

**Eliminate**
- Remove manual time tracking (auto-detect from activity)
- Eliminate status meetings (AI-generated summaries)

**Reverse**
- Instead of users finding tasks, tasks find users
- Proactive blocker detection vs. reactive reporting

## Six Thinking Hats

**White Hat (Facts)**
- Competitors: Asana, Monday, ClickUp all adding AI
- 67% of PM tools will have AI by 2025
- User survey: 45% want "smart suggestions"

**Red Hat (Emotions)**
- Excitement about productivity gains
- Fear of AI replacing jobs
- Frustration with "AI-washing" features

**Black Hat (Risks)**
- Privacy concerns with project data
- Inaccurate predictions erode trust
- Expensive API costs
- Vendor lock-in (OpenAI, etc.)

**Yellow Hat (Benefits)**
- Save 5+ hours/week per user
- Better estimations (reduce overruns by 30%)
- Competitive differentiation

**Green Hat (Creativity)**
- "AI Project Manager" assistant persona
- Voice interface for hands-free updates
- Predictive burnout detection
- Auto-generate project retrospectives

**Blue Hat (Process)**
- Start with estimation (highest ROI)
- Beta with 10 power users
- Measure time saved quantitatively

## SWOT Analysis

**Strengths**
- Large dataset of completed projects
- Strong user trust
- Technical team capable

**Weaknesses**
- No ML expertise in-house
- Limited budget for APIs
- Privacy-first brand may conflict

**Opportunities**
- First mover in our niche
- Partner with AI startups
- Premium AI tier

**Threats**
- Big players (Microsoft, Atlassian) have more data
- AI commoditization
- Regulation (EU AI Act)

## Recommendations

### Quick Wins (1-2 months)
1. **Smart task estimation** - Train on historical data
2. **Meeting summary** - Use GPT to summarize notes

### Medium Term (3-6 months)
3. **Predictive blockers** - Flag at-risk tasks
4. **Auto-categorization** - Tag and route tasks

### Long Term (6-12 months)
5. **AI assistant** - Natural language project management
6. **Cross-project insights** - Pattern recognition

Saving to: docs/brainstorm-ai-features.md

User: /research

Claude: What type of research?
> Competitive analysis

Focus?
> AI features in project management tools

## Competitive Analysis: AI in Project Management

### Market Overview
$6.7B market, 13% CAGR, AI adoption accelerating

### Competitor AI Features

#### Asana
- **Smart Fields:** Auto-populate custom fields
- **Workflow recommendations:** Suggest automations
- **Goals AI:** Generate goal suggestions
- Status: Generally available
- Pricing: Included in Business+

#### Monday.com
- **AI Assistant:** Natural language queries
- **Smart suggestions:** Task recommendations
- **Summarization:** Meeting and doc summaries
- Status: Beta
- Pricing: Enterprise only

#### ClickUp
- **ClickUp AI:** Writing assistant, summarization
- **Task creation:** From natural language
- **Brainstorming:** AI-powered ideation
- Status: Add-on ($5/user)
- Pricing: Separate purchase

#### Notion
- **Notion AI:** Writing, summarization, translation
- **Q&A:** Ask questions about workspace
- Status: GA
- Pricing: $8/user add-on

### Feature Comparison

| Feature | Asana | Monday | ClickUp | Notion | Us |
|---------|-------|--------|---------|--------|-----|
| Estimation | - | - | - | - | ★ Opportunity |
| Summarization | - | ✓ | ✓ | ✓ | Plan |
| Writing assist | - | - | ✓ | ✓ | - |
| Smart fields | ✓ | - | - | - | Plan |
| NL queries | - | ✓ | - | ✓ | Long-term |

### Pricing Models

1. **Included in tier:** Asana (high tier lock-in)
2. **Add-on:** ClickUp, Notion ($5-8/user)
3. **Usage-based:** Rare, emerging

### Differentiation Opportunity

Gap: **Predictive project health**

No competitor offers:
- Risk prediction based on patterns
- Resource optimization suggestions
- Burnout early warning
- Delivery date confidence scores

This is data-intensive, requires historical projects,
and aligns with our strength.

### Recommendations

1. **Launch with estimation** - Clear differentiation
2. **Pricing:** Add-on ($3-5/user) - accessible
3. **Privacy-first approach** - Optional, on-premise option
4. **Partner strategy** - Integrate multiple LLM providers

Saving to: docs/research-ai-competition.md

User: Based on this research, I want to build the AI estimation feature.

User: /workflow-init
> Project: AI Task Estimation Feature
> Level: 2

[Continue with regular BMAD workflow]
~~~~

---

## Common Patterns

### Pattern 1: Research → Build

```
/brainstorm        # Explore ideas
/research          # Validate market
/workflow-init     # Start project
/product-brief     # Define scope
...
```

### Pattern 2: Quick Prototype

```
/workflow-init     # Level 1
/tech-spec         # Minimal requirements
/dev-story STORY-001
```

### Pattern 3: Enterprise Project

```
/workflow-init     # Level 3-4
/product-brief     # Comprehensive
/prd               # Detailed requirements
/create-ux-design  # Full UX
/architecture      # Complete design
/solutioning-gate-check  # Validate
/sprint-planning   # Multiple sprints
```

### Pattern 4: Custom Workflow

```
/create-agent      # Security Engineer
/create-workflow   # /security-audit
[Use new agent in workflow]
```

---

## Tips for Success

### 1. Right-Size Your Project

Don't over-engineer a bug fix with full PRD. Don't under-plan an enterprise system with just a tech spec.

| If your project... | Use level... |
|--------------------|--------------|
| Takes <1 day | 0 |
| Takes <1 week | 1 |
| Takes 1-4 weeks | 2 |
| Takes 1-3 months | 3 |
| Takes 3+ months | 4 |

### 2. Let Phases Build on Each Other

Each phase uses outputs from previous phases. Don't skip ahead:

- PRD reads product brief
- Architecture reads PRD
- Sprint planning reads both
- Stories read architecture

### 3. Use /workflow-status Often

When in doubt, check status. BMAD will tell you exactly what to do next.

### 4. Iterate Within Phases

It's okay to revise. Run `/prd` again to update requirements. Run `/architecture` to refine design.

### 5. Customize for Your Process

Use `/create-agent` and `/create-workflow` to add domain-specific capabilities.

---

## Next Steps

- Review [Configuration](../configuration) options
- Check [Troubleshooting](../troubleshooting) if you hit issues
- Return to [Commands Reference](../commands/) for details
