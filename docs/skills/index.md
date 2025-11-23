---
layout: default
title: "Skills"
description: "Complete reference for all 9 BMAD skills (AI agents). Learn how each skill works and when to use them in your development workflow."
keywords: "BMAD skills, Claude Code agents, AI development agents, business analyst AI, product manager AI, architect AI"
---

# Skills Reference

BMAD provides 9 specialized skills (AI agents) that handle different aspects of the agile development workflow. Each skill has specific responsibilities, commands, and outputs.

---

## How Skills Work in Claude Code

Skills are markdown files that define agent behavior. When you use a BMAD command, Claude Code loads the appropriate skill to handle your request.

**Location:** `~/.claude/skills/bmad/`

**Structure:**
```
bmad/
├── core/
│   └── bmad-master/SKILL.md
├── bmm/
│   ├── analyst/SKILL.md
│   ├── pm/SKILL.md
│   ├── architect/SKILL.md
│   ├── scrum-master/SKILL.md
│   ├── developer/SKILL.md
│   └── ux-designer/SKILL.md
├── bmb/
│   └── builder/SKILL.md
└── cis/
    └── creative-intelligence/SKILL.md
```

---

## Skill Modules

### Core Module
Essential orchestration skill that routes workflows.

| Skill | Purpose |
|-------|---------|
| [BMad Master](#bmad-master) | Workflow orchestration and routing |

### BMM Module (Business Method Module)
Main development workflow skills.

| Skill | Phase | Purpose |
|-------|-------|---------|
| [Business Analyst](#business-analyst) | Phase 1 | Requirements discovery |
| [Product Manager](#product-manager) | Phase 2 | PRD and planning |
| [UX Designer](#ux-designer) | Phase 2-3 | Interface design |
| [System Architect](#system-architect) | Phase 3 | Technical architecture |
| [Scrum Master](#scrum-master) | Phase 4 | Sprint planning |
| [Developer](#developer) | Phase 4 | Implementation |

### BMB Module (Builder Module)
Customization and extension skill.

| Skill | Purpose |
|-------|---------|
| [Builder](#builder) | Create custom agents and workflows |

### CIS Module (Creative Intelligence System)
Research and ideation skill.

| Skill | Purpose |
|-------|---------|
| [Creative Intelligence](#creative-intelligence) | Brainstorming and research |

---

## Core Module

<h3 id="bmad-master">BMad Master</h3>

**Skill ID:** `bmad-core-master`
**Module:** Core
**Phase:** All phases

The BMad Master is the entry point and orchestrator for all BMAD workflows. It initializes projects and routes users to appropriate phase-specific skills.

#### Responsibilities
- Initialize BMAD in new projects
- Determine project scope and level
- Route to appropriate workflow commands
- Track overall project status
- Provide workflow recommendations

#### Commands
- `/workflow-init` - Initialize BMAD in your project
- `/workflow-status` - Check project progress and get recommendations

#### Example Usage

```
User: /workflow-init

BMad Master: Welcome to BMAD! I'll help initialize your project.

Let me gather some information about your project...

Project name?
> E-commerce Platform

Project type?
> web-app

Estimated complexity?
Based on your description (user auth, product catalog, cart, checkout),
I recommend Level 3 (Complex integration, 12-40 stories).

Accept Level 3?
> Yes

Created bmad/config.yaml
Recommended first step: /product-brief

Your project is initialized! I'll route you to the appropriate
skills as you progress through each phase.
```

#### When to Use
- Starting any new BMAD project
- Checking what to do next
- Understanding project status

---

## BMM Module

<h3 id="business-analyst">Business Analyst</h3>

**Skill ID:** `bmad-bmm-analyst`
**Module:** BMM
**Phase:** Phase 1 - Analysis

The Business Analyst handles product discovery and initial requirements analysis. This skill helps you understand the problem space before designing solutions.

#### Responsibilities
- Create comprehensive product briefs
- Conduct market and competitive research
- Discover user needs and pain points
- Facilitate stakeholder interviews
- Set foundation for planning phase

#### Commands
- `/product-brief` - Create comprehensive product brief
- `/brainstorm-project` - Ideation for new projects
- `/research` - Market/competitive/technical research
- `/game-brief` - Specialized brief for game projects

#### Example Usage

```
User: /product-brief

Business Analyst: I'll help you create a comprehensive product brief.

## Executive Summary
What problem does this product solve? (2-3 sentences)
> Small businesses struggle to manage inventory across multiple
> sales channels. They need a unified system that syncs stock
> levels in real-time.

## Target Audience
Who are your primary users?
> Small retail business owners with 1-5 locations, selling both
> in-store and online (Shopify, Amazon, eBay)

## Problem Statement
Let me structure the core problems:

1. **Overselling:** Stock sells on one channel but isn't updated on others
2. **Manual updates:** Hours spent updating inventory across platforms
3. **No visibility:** Can't see total inventory at a glance
4. **Lost sales:** Items show out-of-stock when available elsewhere

Is this accurate?
> Yes, also add difficulty with purchase orders

## Solution Overview
Based on these problems, your solution should:
- Real-time sync across all connected channels
- Unified dashboard for all inventory
- Automated low-stock alerts
- Purchase order management

## Success Metrics
How will you measure success?
> - Reduce overselling incidents by 90%
> - Save 10+ hours/week on manual updates
> - 95% inventory accuracy

## Business Objectives
What are your business goals?
> - MRR of $50k in 12 months
> - 500 paying customers
> - Integrations with top 5 sales platforms

Saving product brief to: docs/product-brief.md
```

#### Output
A comprehensive product brief document including:
- Executive summary
- Problem statement
- Target audience
- Solution overview
- Business objectives
- Success metrics
- Competitive analysis
- Constraints and risks

#### When to Use
- Starting a new product or major feature
- Need to align stakeholders on goals
- Before creating detailed requirements
- Level 2+ projects (optional for Level 0-1)

---

<h3 id="product-manager">Product Manager</h3>

**Skill ID:** `bmad-bmm-pm`
**Module:** BMM
**Phase:** Phase 2 - Planning

The Product Manager transforms the product brief into detailed, actionable requirements. This skill creates PRDs with user stories, acceptance criteria, and prioritization.

#### Responsibilities
- Create Product Requirements Documents (PRDs)
- Define Functional Requirements (FRs)
- Define Non-Functional Requirements (NFRs)
- Break down epics into stories
- Prioritize features (MoSCoW, RICE, Kano)
- Right-size planning to project level

#### Commands
- `/prd` - Create Product Requirements Document
- `/tech-spec` - Lightweight spec for Level 0-1 projects
- `/validate-prd` - Validate PRD completeness
- `/validate-tech-spec` - Validate tech spec completeness

#### Example Usage

```
User: /prd

Product Manager: I'll create a PRD based on your product brief.

Loading: docs/product-brief.md

## Functional Requirements

Based on your inventory management solution, here are the core FRs:

### FR-001: Multi-channel Connection
Users can connect multiple sales channels (Shopify, Amazon, eBay, WooCommerce)
and authenticate via OAuth.

### FR-002: Real-time Sync
Inventory changes on any channel are reflected on all others within 60 seconds.

### FR-003: Unified Dashboard
Central view showing:
- Total inventory across all channels
- Per-channel breakdown
- Low stock alerts
- Recent sync activity

### FR-004: Product Mapping
Map products across channels (same product may have different SKUs)

...

## Non-Functional Requirements

### NFR-001: Performance
- Sync latency < 60 seconds
- Dashboard load time < 2 seconds
- Support 10,000 SKUs per account

### NFR-002: Reliability
- 99.9% uptime SLA
- Automatic retry on channel API failures
- Conflict resolution for simultaneous updates

### NFR-003: Security
- SOC 2 compliance
- Encrypted API credentials
- Audit logging

## Epics and Stories

### Epic 1: Channel Integration
- STORY-001: Shopify OAuth integration (5 pts)
- STORY-002: Amazon SP-API integration (8 pts)
- STORY-003: eBay integration (5 pts)
- STORY-004: WooCommerce integration (5 pts)

### Epic 2: Sync Engine
- STORY-005: Inventory sync service (8 pts)
- STORY-006: Conflict resolution (5 pts)
- STORY-007: Retry and error handling (3 pts)

...

## Prioritization (MoSCoW)

**Must Have (MVP):**
- FR-001, FR-002, FR-003

**Should Have:**
- FR-004, FR-005

**Could Have:**
- FR-006, FR-007

**Won't Have (this release):**
- FR-008

Saving PRD to: docs/prd.md
```

#### Output
A complete PRD including:
- Functional requirements with acceptance criteria
- Non-functional requirements
- Epics and user stories with points
- Prioritization
- Success metrics
- Out of scope items

#### When to Use
- Level 2+ projects
- After product brief is complete
- Before architecture design
- Need detailed requirements for development

---

<h3 id="ux-designer">UX Designer</h3>

**Skill ID:** `bmad-bmm-ux-designer`
**Module:** BMM
**Phase:** Phase 2-3 - Planning and Solutioning

The UX Designer creates user interface designs, wireframes, and user flows based on requirements. This skill ensures WCAG accessibility compliance and mobile-first design.

#### Responsibilities
- Create user interface designs
- Design wireframes and mockups
- Map user flows and journeys
- Ensure WCAG accessibility compliance
- Document design systems
- Collaborate with PM and Developer

#### Commands
- `/create-ux-design` - Complete UX design workflow

#### Example Usage

```
User: /create-ux-design

UX Designer: I'll create UX designs for your inventory management system.

Loading: docs/prd.md

## User Flows

### Flow 1: Onboarding
1. Sign up → 2. Connect first channel → 3. Import products →
4. Review mappings → 5. Dashboard

### Flow 2: Daily Usage
1. Login → 2. Dashboard overview → 3. Low stock alerts →
4. Create purchase order → 5. Receive inventory

### Flow 3: Sync Issue Resolution
1. Alert notification → 2. View conflict → 3. Choose resolution →
4. Confirm → 5. Verify sync

## Wireframes

### Dashboard (Main View)
```
┌─────────────────────────────────────────┐
│  [Logo]  Search...   [Alerts] [Profile] │
├─────────────────────────────────────────┤
│ ┌─────────┐ ┌─────────┐ ┌─────────────┐ │
│ │ Total   │ │ Low     │ │ Sync Status │ │
│ │ 12,450  │ │ Stock   │ │ ✓ All Good  │ │
│ │ items   │ │ 23      │ │             │ │
│ └─────────┘ └─────────┘ └─────────────┘ │
│                                         │
│ Recent Activity                         │
│ ├─ Shopify: +50 Widget A                │
│ ├─ Amazon: -3 Gadget B                  │
│ └─ eBay: -1 Thing C                     │
│                                         │
│ Quick Actions                           │
│ [+ Add Product] [Create PO] [Sync Now]  │
└─────────────────────────────────────────┘
```

## Design System

### Colors
- Primary: #2563EB (Blue 600)
- Success: #16A34A (Green 600)
- Warning: #D97706 (Amber 600)
- Error: #DC2626 (Red 600)
- Neutral: #6B7280 (Gray 500)

### Typography
- Headings: Inter, 600 weight
- Body: Inter, 400 weight
- Monospace: JetBrains Mono (for SKUs)

### Spacing Scale
4px, 8px, 12px, 16px, 24px, 32px, 48px, 64px

## Accessibility (WCAG 2.1 AA)

- [ ] Color contrast ratio ≥ 4.5:1
- [ ] All images have alt text
- [ ] Forms have visible labels
- [ ] Keyboard navigable
- [ ] Focus indicators visible
- [ ] Error messages descriptive
- [ ] Touch targets ≥ 44px

## Component Library

1. **Button** - Primary, Secondary, Danger, Ghost
2. **Input** - Text, Number, Select, Multiselect
3. **Card** - Metric, Product, Alert
4. **Table** - Sortable, Filterable, Paginated
5. **Modal** - Confirmation, Form, Alert
6. **Toast** - Success, Error, Warning, Info

Saving UX design to: docs/ux-design.md
```

#### Output
A comprehensive UX design document including:
- User flows
- Wireframes (ASCII or description)
- Design system (colors, typography, spacing)
- Component library specifications
- Accessibility checklist
- Responsive breakpoints

#### When to Use
- Level 2+ projects with user interfaces
- After PRD but before or during architecture
- Need to visualize user experience
- Ensure accessibility compliance

---

<h3 id="system-architect">System Architect</h3>

**Skill ID:** `bmad-bmm-architect`
**Module:** BMM
**Phase:** Phase 3 - Solutioning

The System Architect designs the technical architecture based on requirements. This skill defines system components, data models, APIs, and technology choices.

#### Responsibilities
- Design system architecture
- Select and justify technology stack
- Define data models and schemas
- Specify API contracts
- Address non-functional requirements
- Document architectural decisions

#### Commands
- `/architecture` - Create system architecture
- `/solutioning-gate-check` - Validate architecture against requirements
- `/validate-architecture` - Check architecture completeness

#### Example Usage

~~~~
User: /architecture

System Architect: I'll design the system architecture for your inventory management platform.

Loading: docs/prd.md

## System Overview

The system follows a microservices architecture with event-driven sync:

```
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│   Web App   │────▶│   API GW    │────▶│   Auth      │
└─────────────┘     └──────┬──────┘     └─────────────┘
                           │
         ┌─────────────────┼─────────────────┐
         ▼                 ▼                 ▼
┌─────────────┐   ┌─────────────┐   ┌─────────────┐
│  Inventory  │   │   Sync      │   │  Channels   │
│   Service   │   │   Engine    │   │   Service   │
└──────┬──────┘   └──────┬──────┘   └──────┬──────┘
       │                 │                 │
       └────────┬────────┴────────┬────────┘
                ▼                 ▼
         ┌───────────┐     ┌───────────┐
         │ PostgreSQL│     │   Redis   │
         └───────────┘     │   + MQ    │
                          └───────────┘
```

## Component Architecture

### 1. API Gateway
- **Technology:** Kong or AWS API Gateway
- **Responsibilities:**
  - Request routing
  - Rate limiting
  - Authentication passthrough
  - Request/response logging

### 2. Auth Service
- **Technology:** Node.js + Passport
- **Responsibilities:**
  - User registration/login
  - JWT token issuance
  - OAuth credential storage
  - Role-based access

### 3. Inventory Service
- **Technology:** Node.js + Express
- **Responsibilities:**
  - Product CRUD
  - Stock level management
  - Multi-location support
  - Inventory history

### 4. Sync Engine
- **Technology:** Node.js + Bull Queue
- **Responsibilities:**
  - Event processing
  - Channel API calls
  - Conflict resolution
  - Retry logic

### 5. Channels Service
- **Technology:** Node.js + per-channel adapters
- **Responsibilities:**
  - Channel connection management
  - API translation layer
  - Webhook handling
  - Rate limit management

## Data Models

### Product
```sql
CREATE TABLE products (
  id UUID PRIMARY KEY,
  tenant_id UUID NOT NULL,
  sku VARCHAR(100) NOT NULL,
  name VARCHAR(255) NOT NULL,
  description TEXT,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW(),
  UNIQUE(tenant_id, sku)
);
```

### Inventory
```sql
CREATE TABLE inventory (
  id UUID PRIMARY KEY,
  product_id UUID REFERENCES products(id),
  location_id UUID REFERENCES locations(id),
  quantity INTEGER NOT NULL DEFAULT 0,
  reserved INTEGER NOT NULL DEFAULT 0,
  updated_at TIMESTAMP DEFAULT NOW()
);
```

### Channel Mapping
```sql
CREATE TABLE channel_mappings (
  id UUID PRIMARY KEY,
  product_id UUID REFERENCES products(id),
  channel_id UUID REFERENCES channels(id),
  external_id VARCHAR(255) NOT NULL,
  external_sku VARCHAR(100),
  UNIQUE(channel_id, external_id)
);
```

## API Specifications

### Inventory Endpoints

#### GET /api/v1/inventory
List all inventory with filtering.

**Query Parameters:**
- `sku` - Filter by SKU
- `low_stock` - Boolean, show only low stock
- `channel_id` - Filter by channel
- `page`, `limit` - Pagination

**Response:**
```json
{
  "data": [
    {
      "product_id": "uuid",
      "sku": "WIDGET-001",
      "name": "Blue Widget",
      "total_quantity": 150,
      "locations": [...],
      "channels": [...]
    }
  ],
  "pagination": {...}
}
```

## Technology Stack Justification

| Component | Choice | Justification |
|-----------|--------|---------------|
| Runtime | Node.js | Team expertise, async I/O for API calls |
| Database | PostgreSQL | ACID compliance, JSON support, scalability |
| Queue | Redis + Bull | Fast, reliable, good Node.js support |
| Cache | Redis | Same instance as queue, fast reads |
| API Gateway | Kong | Open source, plugin ecosystem |

## NFR Mapping

| NFR | Solution |
|-----|----------|
| Sync < 60s | Event-driven architecture, parallel processing |
| 99.9% uptime | Multi-AZ deployment, health checks, auto-scaling |
| 10k SKUs | Database indexing, query optimization, caching |
| Security | JWT + OAuth, encrypted secrets, audit logs |

Saving architecture to: docs/architecture.md
~~~~

#### Output
A comprehensive architecture document including:
- System overview diagram
- Component architecture
- Data models and schemas
- API specifications
- Technology stack with justifications
- NFR mapping
- Deployment strategy
- Scalability considerations

#### When to Use
- Level 2+ projects
- After PRD (and optionally UX design)
- Before sprint planning
- Need technical blueprint for implementation

---

<h3 id="scrum-master">Scrum Master</h3>

**Skill ID:** `bmad-bmm-scrum-master`
**Module:** BMM
**Phase:** Phase 4 - Implementation Planning

The Scrum Master handles sprint planning and story management. This skill breaks down epics into stories, estimates complexity, and plans iterations.

#### Responsibilities
- Break epics into stories
- Estimate story complexity (Fibonacci)
- Plan sprint iterations
- Track sprint progress
- Refine and size stories
- Calculate velocity

#### Commands
- `/sprint-planning` - Plan sprint iterations
- `/create-story` - Create individual story
- `/sprint-status` - Check sprint progress
- `/velocity-report` - View velocity metrics

#### Example Usage

```
User: /sprint-planning

Scrum Master: I'll help plan sprints for your inventory management system.

Loading: docs/prd.md, docs/architecture.md

## Story Breakdown

### Epic 1: Authentication & Authorization

| ID | Story | Points | Priority |
|----|-------|--------|----------|
| STORY-001 | User registration and login | 3 | Must |
| STORY-002 | JWT token management | 2 | Must |
| STORY-003 | OAuth credential storage | 3 | Must |
| STORY-004 | Role-based permissions | 5 | Should |

### Epic 2: Channel Integration

| ID | Story | Points | Priority |
|----|-------|--------|----------|
| STORY-005 | Channel connection framework | 5 | Must |
| STORY-006 | Shopify adapter | 5 | Must |
| STORY-007 | Amazon adapter | 8 | Must |
| STORY-008 | eBay adapter | 5 | Should |
| STORY-009 | WooCommerce adapter | 5 | Should |

### Epic 3: Sync Engine

| ID | Story | Points | Priority |
|----|-------|--------|----------|
| STORY-010 | Event queue setup | 3 | Must |
| STORY-011 | Inventory sync processor | 8 | Must |
| STORY-012 | Conflict resolution | 5 | Must |
| STORY-013 | Retry and error handling | 3 | Must |

### Epic 4: Inventory Management

| ID | Story | Points | Priority |
|----|-------|--------|----------|
| STORY-014 | Product CRUD | 5 | Must |
| STORY-015 | Stock level management | 5 | Must |
| STORY-016 | Multi-location support | 8 | Should |
| STORY-017 | Inventory history | 5 | Should |

### Epic 5: Dashboard & UI

| ID | Story | Points | Priority |
|----|-------|--------|----------|
| STORY-018 | Dashboard layout | 5 | Must |
| STORY-019 | Inventory list view | 5 | Must |
| STORY-020 | Low stock alerts | 3 | Must |
| STORY-021 | Sync status display | 3 | Must |

## Sprint Planning

**Team velocity assumption:** 25 points/sprint (adjust based on actual)

### Sprint 1: Foundation (25 pts)
Focus: Auth + Core inventory

- STORY-001: User registration/login (3)
- STORY-002: JWT management (2)
- STORY-003: OAuth storage (3)
- STORY-010: Event queue setup (3)
- STORY-014: Product CRUD (5)
- STORY-015: Stock management (5)
- STORY-018: Dashboard layout (5)

**Goal:** Users can sign up, add products, and see dashboard

### Sprint 2: First Channel (24 pts)
Focus: Shopify integration

- STORY-005: Channel framework (5)
- STORY-006: Shopify adapter (5)
- STORY-011: Sync processor (8)
- STORY-019: Inventory list (5)
- Buffer for Sprint 1 carryover (1)

**Goal:** Full Shopify sync working

### Sprint 3: Reliability (24 pts)
Focus: Error handling + more channels

- STORY-012: Conflict resolution (5)
- STORY-013: Retry handling (3)
- STORY-007: Amazon adapter (8)
- STORY-020: Low stock alerts (3)
- STORY-021: Sync status (3)
- Buffer (2)

**Goal:** Reliable sync with Shopify and Amazon

### Sprint 4: Expansion (23 pts)
Focus: Additional features

- STORY-004: Role-based permissions (5)
- STORY-008: eBay adapter (5)
- STORY-009: WooCommerce adapter (5)
- STORY-016: Multi-location (8)

**Goal:** All major channels supported

### Sprint 5: Polish (13 pts)
Focus: Nice-to-haves and refinement

- STORY-017: Inventory history (5)
- Bug fixes and polish (8)

**Goal:** Production-ready MVP

## Summary

- **Total stories:** 21
- **Total points:** 109
- **Estimated sprints:** 5
- **MVP ready:** After Sprint 3 (Must-haves complete)

Accept this sprint plan?
> Yes

Saving to: docs/sprint-status.yaml
Creating story files in: docs/stories/

Sprint plan complete!
```

#### When to Use
- After architecture is complete
- Before implementation begins
- Need to break down work into iterations
- Planning team capacity

---

<h3 id="developer">Developer</h3>

**Skill ID:** `bmad-bmm-developer`
**Module:** BMM
**Phase:** Phase 4 - Implementation

The Developer implements stories from the sprint plan. This skill writes clean, tested code that meets acceptance criteria.

#### Responsibilities
- Implement stories from requirements
- Write clean, maintainable code
- Create comprehensive tests (≥80% coverage)
- Complete acceptance criteria
- Document implementation
- Follow best practices

#### Commands
- `/dev-story {STORY-ID}` - Implement a story
- `/code-review {file}` - Review code
- `/fix-tests` - Fix failing tests
- `/refactor {component}` - Refactor code

#### Example Usage

~~~~
User: /dev-story STORY-014

Developer: I'll implement STORY-014: Product CRUD.

Loading: docs/stories/STORY-014.md

## Story Details

**Title:** Product CRUD Operations
**Points:** 5
**Epic:** Inventory Management

### Acceptance Criteria
- [ ] Create product with name, SKU, description
- [ ] Read product by ID or SKU
- [ ] Update product fields
- [ ] Delete product (soft delete)
- [ ] Validate unique SKU per tenant
- [ ] API endpoints follow REST conventions
- [ ] Unit tests with >80% coverage

### Implementation Plan

1. Create Product model and migration
2. Create Product service with business logic
3. Create Product controller with endpoints
4. Add validation middleware
5. Write unit tests
6. Write integration tests

### Implementation

#### 1. Product Model

Creating: src/models/product.js
```javascript
const { DataTypes } = require('sequelize');

module.exports = (sequelize) => {
  const Product = sequelize.define('Product', {
    id: {
      type: DataTypes.UUID,
      defaultValue: DataTypes.UUIDV4,
      primaryKey: true
    },
    tenantId: {
      type: DataTypes.UUID,
      allowNull: false,
      field: 'tenant_id'
    },
    sku: {
      type: DataTypes.STRING(100),
      allowNull: false
    },
    name: {
      type: DataTypes.STRING(255),
      allowNull: false
    },
    description: {
      type: DataTypes.TEXT
    },
    deletedAt: {
      type: DataTypes.DATE,
      field: 'deleted_at'
    }
  }, {
    tableName: 'products',
    paranoid: true, // soft delete
    indexes: [
      {
        unique: true,
        fields: ['tenant_id', 'sku']
      }
    ]
  });

  return Product;
};
```

#### 2. Product Service

Creating: src/services/productService.js
```javascript
class ProductService {
  constructor(productModel) {
    this.Product = productModel;
  }

  async create(tenantId, data) {
    return this.Product.create({
      tenantId,
      ...data
    });
  }

  async findById(tenantId, id) {
    return this.Product.findOne({
      where: { id, tenantId }
    });
  }

  async findBySku(tenantId, sku) {
    return this.Product.findOne({
      where: { sku, tenantId }
    });
  }

  async update(tenantId, id, data) {
    const product = await this.findById(tenantId, id);
    if (!product) return null;
    return product.update(data);
  }

  async delete(tenantId, id) {
    const product = await this.findById(tenantId, id);
    if (!product) return false;
    await product.destroy();
    return true;
  }

  async list(tenantId, { page = 1, limit = 20, search } = {}) {
    const where = { tenantId };
    if (search) {
      where[Op.or] = [
        { name: { [Op.iLike]: `%${search}%` } },
        { sku: { [Op.iLike]: `%${search}%` } }
      ];
    }

    return this.Product.findAndCountAll({
      where,
      limit,
      offset: (page - 1) * limit,
      order: [['createdAt', 'DESC']]
    });
  }
}
```

#### 3. Product Controller

Creating: src/controllers/productController.js
```javascript
const express = require('express');
const router = express.Router();
const { validateProduct } = require('../middleware/validation');

router.post('/', validateProduct, async (req, res, next) => {
  try {
    const product = await req.productService.create(
      req.tenantId,
      req.body
    );
    res.status(201).json(product);
  } catch (error) {
    if (error.name === 'SequelizeUniqueConstraintError') {
      return res.status(409).json({
        error: 'SKU already exists'
      });
    }
    next(error);
  }
});

// ... GET, PUT, DELETE endpoints

module.exports = router;
```

#### 4. Tests

Creating: tests/unit/productService.test.js
```javascript
describe('ProductService', () => {
  describe('create', () => {
    it('should create a product with valid data', async () => {
      const data = {
        sku: 'TEST-001',
        name: 'Test Product',
        description: 'A test product'
      };

      const product = await productService.create(tenantId, data);

      expect(product.sku).toBe(data.sku);
      expect(product.name).toBe(data.name);
      expect(product.tenantId).toBe(tenantId);
    });

    it('should reject duplicate SKU for same tenant', async () => {
      // ... test implementation
    });
  });

  // ... more tests
});
```

### Verification

Running tests:
```bash
npm test -- --coverage
```

Coverage report:
- productService.js: 95%
- productController.js: 88%
- Overall: 91%

All acceptance criteria met ✓

### Story Complete

Updated: docs/stories/STORY-014.md
Status: Complete

Next: /dev-story STORY-015
~~~~

#### When to Use
- During implementation phase
- Have a story ready to implement
- Need to write actual code
- Want test coverage verification

---

## BMB Module

<h3 id="builder">Builder</h3>

**Skill ID:** `bmad-bmb-builder`
**Module:** BMB
**Phase:** N/A (Meta-skill)

The Builder creates custom agents, workflows, and templates. Use this when you need specialized capabilities not covered by default BMAD skills.

#### Responsibilities
- Create custom agents for specific domains
- Generate custom workflow commands
- Build new templates
- Customize BMAD for your needs

#### Commands
- `/create-agent` - Create custom BMAD agent
- `/create-workflow` - Create custom workflow command
- `/create-template` - Create output template
- `/customize-bmad` - Modify BMAD configuration

#### Example: Creating a QA Engineer Agent

```
User: /create-agent

Builder: I'll help you create a custom BMAD agent.

What type of agent?
> QA Engineer

What are its main responsibilities?
> - Test plan creation
> - Test case design
> - Bug report writing
> - Coverage analysis
> - Regression testing

What commands should it support?
> /create-test-plan
> /generate-test-cases
> /bug-report
> /coverage-analysis

Creating agent...

Saved to: ~/.claude/skills/bmad/custom/qa-engineer/SKILL.md

## Generated Agent

```markdown
# QA Engineer

## Skill ID
bmad-custom-qa-engineer

## Module
custom

## Purpose
Quality assurance and testing for BMAD projects

## Responsibilities
- Create comprehensive test plans from requirements
- Design test cases with clear steps and expected results
- Write detailed bug reports
- Analyze test coverage and identify gaps
- Plan regression testing strategies

## Commands
- `/create-test-plan` - Generate test plan from PRD
- `/generate-test-cases` - Create test cases for features
- `/bug-report` - Write standardized bug report
- `/coverage-analysis` - Analyze test coverage

## Workflow Integration
- Operates in Phase 4 alongside Developer
- Takes PRD and Architecture as inputs
- Outputs test documentation to docs/tests/
```

Restart Claude Code to load the new agent.
```

#### When to Use
- Need domain-specific agents (Security, DevOps, Data Science)
- Want custom workflows for your process
- Building reusable templates
- Extending BMAD for your team

---

## CIS Module

<h3 id="creative-intelligence">Creative Intelligence</h3>

**Skill ID:** `bmad-cis-creative-intelligence`
**Module:** CIS
**Phase:** Any phase

The Creative Intelligence skill facilitates brainstorming and research. Use this when you need creative problem-solving or comprehensive research.

#### Responsibilities
- Facilitate structured brainstorming
- Conduct market/competitive/technical research
- Generate creative solutions
- Refine ideas through multiple techniques
- Document findings

#### Commands
- `/brainstorm` - Structured brainstorming session
- `/research` - Comprehensive research

#### Brainstorming Techniques

1. **5 Whys** - Root cause analysis
2. **SCAMPER** - Creative variations
3. **Mind Mapping** - Visual organization
4. **Reverse Brainstorming** - Failure analysis
5. **Six Thinking Hats** - Multiple perspectives
6. **Starbursting** - Question-based exploration
7. **Brainwriting** - Silent idea generation
8. **SWOT Analysis** - Strategic assessment

#### Example: Brainstorming Session

```
User: /brainstorm

Creative Intelligence: What topic would you like to brainstorm?
> How to improve user onboarding for our inventory app

Which techniques would you like to use? (or 'all')
> 5 Whys, SCAMPER, Six Thinking Hats

## 5 Whys Analysis

**Problem:** Users abandon onboarding before connecting their first channel

1. **Why?** The process takes too long (15+ minutes)
2. **Why?** Users must configure too many settings upfront
3. **Why?** We require all fields before proceeding
4. **Why?** The system needs complete data to function
5. **Why?** We haven't implemented progressive disclosure

**Root Cause:** Requiring complete configuration prevents users from experiencing value quickly

**Solution Direction:** Implement progressive onboarding with minimal required fields

## SCAMPER Analysis

**Substitute**
- Replace manual setup with templates (Shopify store, Amazon seller)
- Substitute text instructions with video walkthroughs

**Combine**
- Combine channel connection + product import into one step
- Merge similar configuration screens

**Adapt**
- Adapt successful onboarding from Slack (guided bot)
- Adapt e-commerce setup wizards

**Modify**
- Simplify to 3 steps: Sign up → Connect → Dashboard
- Reduce required fields to just email and channel

**Put to other uses**
- Use onboarding flow for re-engagement
- Turn into shareable team invitation flow

**Eliminate**
- Remove location setup (default to single location)
- Eliminate manual product entry (auto-import only)

**Reverse**
- Start with dashboard, then prompt to connect
- Show sample data first, then replace with real

## Six Thinking Hats

**White Hat (Facts)**
- Current completion rate: 35%
- Average time: 18 minutes
- Drop-off point: Channel authentication

**Red Hat (Emotions)**
- Users feel overwhelmed
- Frustration at OAuth complexity
- Excitement when they see dashboard

**Black Hat (Risks)**
- Simplified onboarding may miss critical settings
- Users may get stuck later
- Support burden could increase

**Yellow Hat (Benefits)**
- Higher completion rate
- Faster time-to-value
- Better first impression

**Green Hat (Creativity)**
- "Connect in 60 seconds" challenge
- Gamified progress
- Skip to dashboard with sample data

**Blue Hat (Process)**
- A/B test new flow
- Monitor completion and day-7 retention
- Iterate based on support tickets

## Recommendations

1. **Quick Win:** Reduce required fields to email + password only
2. **Medium Term:** Implement "Connect in 3 clicks" with smart defaults
3. **Future:** Progressive onboarding that reveals features over first week

Saving to: docs/brainstorm-onboarding.md
```

#### Example: Research Session

```
User: /research

Creative Intelligence: What type of research?
1. Market research
2. Competitive analysis
3. Technical research
4. User research
> 2

What's the focus of your competitive analysis?
> Inventory management software for small businesses

## Competitive Analysis: Inventory Management Software

### Market Overview
The small business inventory management market is valued at $3.2B (2024) with 12% YoY growth. Key trends include multi-channel integration, AI-powered forecasting, and mobile-first design.

### Competitor Profiles

#### 1. Cin7
- **Target:** Mid-market ($500-5000/mo)
- **Strengths:** Comprehensive features, 500+ integrations
- **Weaknesses:** Complex, expensive, steep learning curve
- **Pricing:** $349-999/mo

#### 2. Ordoro
- **Target:** E-commerce sellers ($50-200/mo)
- **Strengths:** Shipping integration, dropshipping support
- **Weaknesses:** Limited POS integration, basic reporting
- **Pricing:** $59-199/mo

#### 3. Sortly
- **Target:** Small teams ($29-150/mo)
- **Strengths:** Visual inventory, mobile app, QR codes
- **Weaknesses:** Limited channel integration
- **Pricing:** $29-149/mo

#### 4. inFlow
- **Target:** Product businesses ($79-219/mo)
- **Strengths:** Manufacturing support, B2B portal
- **Weaknesses:** Dated UI, limited real-time sync
- **Pricing:** $79-219/mo

### Feature Comparison

| Feature | Cin7 | Ordoro | Sortly | inFlow | Us |
|---------|------|--------|--------|--------|-----|
| Shopify | ✓ | ✓ | - | ✓ | ✓ |
| Amazon | ✓ | ✓ | - | ✓ | ✓ |
| Real-time sync | ✓ | - | - | - | ✓ |
| Mobile app | ✓ | - | ✓ | ✓ | Planned |
| AI forecasting | ✓ | - | - | - | Planned |

### Opportunity Analysis

**Gaps we can fill:**
1. Real-time sync at lower price point
2. Better UX than Cin7
3. More integrations than Sortly
4. Modern UI vs. inFlow

**Positioning:**
"Cin7 features at Ordoro prices"

### Recommendations

1. **Differentiate on speed:** Lead with "60-second sync" messaging
2. **Target switchers:** Focus on Ordoro users needing real-time
3. **Pricing:** $49-149/mo range to compete with Ordoro/Sortly
4. **Launch integrations:** Prioritize Shopify, Amazon, eBay, WooCommerce

Saving to: docs/research-competitive-analysis.md
```

#### When to Use
- Starting a new project (use before product brief)
- Stuck on a problem
- Need market intelligence
- Exploring technical options
- Any phase where creativity helps

---

## Using Skills Together

Skills work together across the workflow. Here's how they connect:

```
Business Analyst → Product Manager → System Architect → Scrum Master → Developer
     │                    │                 │                │            │
product-brief.md → prd.md → architecture.md → sprint-status.yaml → code
```

### Handoff Example

```
User: /product-brief
# Business Analyst creates docs/product-brief.md

User: /prd
# Product Manager reads product-brief.md
# Creates docs/prd.md

User: /architecture
# System Architect reads prd.md
# Creates docs/architecture.md

User: /sprint-planning
# Scrum Master reads prd.md and architecture.md
# Creates docs/sprint-status.yaml and docs/stories/

User: /dev-story STORY-001
# Developer reads the story file and architecture
# Implements the code
```

Each skill automatically loads outputs from previous phases, maintaining context throughout the workflow.

---

## Next Steps

- Learn the [Commands](../commands/) each skill supports
- See [Examples](../examples/) of complete workflows
- Customize skills through [Configuration](../configuration)
