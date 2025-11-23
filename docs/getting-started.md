---
layout: default
title: "Getting Started with BMAD Method for Claude Code"
description: "Complete installation guide and first steps for BMAD Method in Claude Code. Learn how to install, configure, and run your first BMAD workflow."
keywords: "BMAD installation, Claude Code setup, agile development setup, BMAD getting started"
---

# Getting Started

This guide will walk you through installing BMAD Method for Claude Code and running your first workflow.

---

## Prerequisites

Before installing BMAD, ensure you have:

- **Claude Code** installed and working ([Installation Guide](https://docs.anthropic.com/en/docs/claude-code))
- **Git** for cloning the repository
- A terminal (Bash for Linux/macOS/WSL, PowerShell for Windows)

---

## Installation

### Step 1: Clone the Repository

```bash
git clone https://github.com/aj-geddes/claude-code-bmad-skills.git
cd claude-code-bmad-skills
```

### Step 2: Run the Installer

<div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px; margin: 20px 0;" markdown="1">

<div style="background: #f5f5f5; padding: 20px; border-radius: 8px;" markdown="1">

#### Linux / macOS / WSL

```bash
chmod +x install-v6.sh
./install-v6.sh
```

**What it does:**
- Creates `~/.claude/skills/bmad/`
- Creates `~/.claude/commands/bmad/`
- Creates `~/.claude/config/bmad/`
- Installs all skills, commands, and templates
- Substitutes your username in config

</div>

<div style="background: #f5f5f5; padding: 20px; border-radius: 8px;" markdown="1">

#### Windows PowerShell

```powershell
.\install-v6.ps1
```

**Additional options:**
```powershell
# Preview what will be installed
.\install-v6.ps1 -WhatIf

# Force reinstall
.\install-v6.ps1 -Force

# Uninstall BMAD
.\install-v6.ps1 -Uninstall

# Verbose output
.\install-v6.ps1 -Verbose
```

</div>

</div>

### Step 3: Restart Claude Code

**Important:** Claude Code loads skills on startup. You must restart it after installation.

```bash
# Close and reopen your terminal, or:
claude  # Start a new Claude Code session
```

### Step 4: Verify Installation

In Claude Code, you should now see BMAD skills available. Test with:

```
/workflow-init
```

If you see the workflow initialization prompt, BMAD is installed correctly!

---

## Your First BMAD Project

Let's walk through creating a simple project to understand the BMAD workflow.

### Example: Building a Todo API

We'll create a simple REST API for managing todos. This is a Level 1 project (small, 1-10 stories).

#### Step 1: Initialize BMAD

Navigate to your project directory and start Claude Code:

```bash
mkdir todo-api && cd todo-api
git init
claude
```

Now initialize BMAD:

```
User: /workflow-init

Claude: I'll initialize BMAD for your project. Let me gather some information.

What is your project name?
> Todo REST API

What type of project is this?
1. web-app
2. mobile-app
3. api
4. game
5. library
6. other
> 3

Based on the scope, what project level fits best?
- Level 0: Single atomic change (1 story)
- Level 1: Small feature (1-10 stories)
- Level 2: Medium feature set (5-15 stories)
- Level 3: Complex integration (12-40 stories)
- Level 4: Enterprise expansion (40+ stories)
> 1

Created bmad/config.yaml:
  project_name: "Todo REST API"
  project_type: "api"
  project_level: 1
  output_folder: "docs"

Project initialized! Run /workflow-status to see recommended next steps.
```

#### Step 2: Check Workflow Status

```
User: /workflow-status

Claude: ## Todo REST API - Workflow Status

### Project Info
- Type: api
- Level: 1 (Small feature)
- Output: docs/

### Phase Status

| Phase | Status | Next Action |
|-------|--------|-------------|
| Phase 1 - Analysis | Not started | Optional: /product-brief |
| Phase 2 - Planning | Not started | **Recommended: /tech-spec** |
| Phase 3 - Solutioning | Not started | Waiting for Phase 2 |
| Phase 4 - Implementation | Not started | Waiting for Phase 3 |

### Recommendation
For a Level 1 project, start with `/tech-spec` to define your API endpoints and data models. Product brief is optional for small projects.
```

#### Step 3: Create Technical Specification

For Level 0-1 projects, we use `/tech-spec` instead of a full PRD:

```
User: /tech-spec

Claude: I'll help you create a technical specification for the Todo REST API.

## Core Functionality

What are the main features of this API?
> - Create, read, update, delete todos
> - Mark todos as complete/incomplete
> - Filter todos by status
> - Basic authentication

## Data Model

Let me define the Todo model:

```json
{
  "id": "uuid",
  "title": "string",
  "description": "string?",
  "completed": "boolean",
  "created_at": "datetime",
  "updated_at": "datetime",
  "user_id": "uuid"
}
```

Does this look correct?
> Yes, add a due_date field too

Updated model includes due_date: datetime?

## API Endpoints

Based on CRUD operations:

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | /todos | List all todos (filterable) |
| POST | /todos | Create a new todo |
| GET | /todos/:id | Get a specific todo |
| PUT | /todos/:id | Update a todo |
| DELETE | /todos/:id | Delete a todo |
| PATCH | /todos/:id/complete | Toggle completion |

## Technology Stack

For a simple REST API, I recommend:
- Runtime: Node.js with Express
- Database: SQLite (simple) or PostgreSQL (scalable)
- Auth: JWT tokens
- Validation: Joi or Zod

Which stack do you prefer?
> Node.js, SQLite, JWT, Zod

## Output

Saving technical specification to: docs/tech-spec.md
Updating workflow status...

Technical specification complete!
Run /workflow-status to see next steps.
```

#### Step 4: Sprint Planning

Now let's plan the implementation:

```
User: /sprint-planning

Claude: I'll help plan your sprint for the Todo REST API.

Based on your tech spec, I've identified these stories:

## Epic: Todo API Core

### Stories

1. **Setup project structure and dependencies**
   - Complexity: 2 (Fibonacci)
   - Create Express app, configure SQLite, setup Zod

2. **Implement Todo data model and migrations**
   - Complexity: 3
   - Define schema, create migration scripts

3. **Create CRUD endpoints for todos**
   - Complexity: 5
   - All REST endpoints with validation

4. **Add JWT authentication**
   - Complexity: 5
   - User model, login/register, middleware

5. **Add filtering and pagination**
   - Complexity: 3
   - Query params for status, date, pagination

6. **Write tests and documentation**
   - Complexity: 3
   - Unit tests, API docs

## Sprint Recommendation

Total points: 21
For a single developer, split into 2 sprints:

**Sprint 1 (13 points):** Stories 1, 2, 3
**Sprint 2 (8 points):** Stories 4, 5, 6

Accept this sprint plan?
> Yes

Saving to: docs/sprint-status.yaml
Creating story files...

Sprint plan complete! Use /dev-story STORY-001 to start implementing.
```

#### Step 5: Implement a Story

Now let's implement the first story:

```
User: /dev-story STORY-001

Claude: ## Story: Setup project structure and dependencies

**Complexity:** 2 points
**Status:** In Progress

### Acceptance Criteria
- [ ] Initialize npm project with package.json
- [ ] Install Express, SQLite3, Zod, JWT dependencies
- [ ] Create folder structure (src/routes, src/models, src/middleware)
- [ ] Setup basic Express server with health check
- [ ] Configure environment variables

### Implementation

Let me set up the project structure...

[Claude creates files: package.json, src/index.js, src/routes/health.js, .env.example, etc.]

### Verification

Running the server:
```bash
npm install
npm run dev
```

Testing health check:
```bash
curl http://localhost:3000/health
# {"status":"ok","timestamp":"2025-01-15T10:30:00Z"}
```

All acceptance criteria met.

### Story Complete

Updated: docs/stories/STORY-001.md (status: complete)
Updated: docs/sprint-status.yaml

Next story: /dev-story STORY-002
```

---

## Understanding Project Levels

BMAD adapts its workflow based on your project's complexity:

### Level 0: Atomic Changes

**Example:** Bug fix, config change, single file update

```
User: /workflow-init
> Project: Fix login timeout bug
> Type: other
> Level: 0

User: /tech-spec
> - Issue: Session expires after 5 minutes
> - Fix: Update SESSION_TIMEOUT to 3600
> - Files: config/auth.js

User: /dev-story STORY-001
[Claude implements the fix directly]
```

**Required workflow:** Tech Spec → Implementation

### Level 1: Small Features

**Example:** New API endpoint, UI component, utility function

**Required workflow:** Tech Spec → Sprint Planning → Implementation

### Level 2: Medium Features

**Example:** User authentication system, dashboard module, API integration

```
User: /workflow-init
> Level: 2

User: /product-brief    # Optional but recommended
User: /prd              # Required - full requirements
User: /architecture     # Required - system design
User: /sprint-planning  # Required - break into sprints
```

**Required workflow:** PRD → Architecture → Sprint Planning → Implementation

### Level 3-4: Complex/Enterprise

**Example:** Microservice ecosystem, platform rewrite, multi-team project

**Required workflow:** Full BMAD with all phases, possibly including UX design

---

## Common Workflows

### Research-First Approach

Use Creative Intelligence before requirements:

```
User: /brainstorm

Claude: What topic would you like to brainstorm?
> How to handle offline sync in a mobile app

Using 5 Whys technique...
Using SCAMPER technique...
Using Six Thinking Hats...

[Comprehensive brainstorming session]

Output saved to: docs/brainstorm-offline-sync.md

User: /research
> Competitive analysis of offline-first mobile apps

[Research session with findings]

Output saved to: docs/research-offline-sync.md

User: /product-brief
[Now informed by research and brainstorming]
```

### Design-First Approach

Include UX design early:

```
User: /product-brief
User: /prd
User: /create-ux-design  # Before architecture

Claude: I'll create UX designs for your product.

Based on your PRD, I'll design:
1. User flows
2. Wireframes
3. Component library
4. Accessibility checklist

[Interactive design session]

Output saved to: docs/ux-design.md

User: /architecture
[Architecture informed by UX decisions]
```

### Custom Agent Workflow

Create domain-specific agents:

```
User: /create-agent

Claude: What type of agent do you want to create?
> QA Engineer

What are the agent's responsibilities?
> - Test plan creation
> - Test case design
> - Bug report writing
> - Coverage analysis

What commands should it support?
> /create-test-plan, /generate-test-cases, /coverage-report

Creating custom agent...

Output saved to: ~/.claude/skills/bmad/custom/qa-engineer/SKILL.md

Restart Claude Code to load the new agent.
```

---

## Next Steps

Now that you have BMAD installed and understand the basics:

1. **Explore Skills** - Learn what each [BMAD skill](./skills/) can do
2. **Learn Commands** - Master all [workflow commands](./commands/)
3. **See Examples** - Follow [complete project walkthroughs](./examples/)
4. **Customize** - Configure BMAD for your [specific needs](./configuration)

---

## Quick Reference

### Essential Commands

| Command | Purpose | When to Use |
|---------|---------|-------------|
| `/workflow-init` | Initialize BMAD | Start of new project |
| `/workflow-status` | Check progress | Anytime |
| `/tech-spec` | Technical specification | Level 0-1 projects |
| `/prd` | Product requirements | Level 2+ projects |
| `/architecture` | System design | Level 2+ projects |
| `/sprint-planning` | Plan iterations | Before implementation |
| `/dev-story {id}` | Implement story | During implementation |

### Project Files

After initialization, your project will have:

```
your-project/
├── bmad/
│   └── config.yaml          # Project configuration
└── docs/
    ├── tech-spec.md         # or prd.md for Level 2+
    ├── architecture.md       # Level 2+
    ├── sprint-status.yaml
    └── stories/
        ├── STORY-001.md
        ├── STORY-002.md
        └── ...
```

---

<div style="text-align: center; margin-top: 40px; padding: 20px; background: #e8f4f8; border-radius: 8px;" markdown="1">

**Need help?**

Check the [Troubleshooting Guide](./troubleshooting) or [open an issue](https://github.com/aj-geddes/claude-code-bmad-skills/issues)

</div>
