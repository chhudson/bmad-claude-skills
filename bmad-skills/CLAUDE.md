# BMAD Method Project Configuration

This project uses the **BMAD Method** (Breakthrough Method for Agile AI-Driven Development) - a structured, phase-based approach to software development with AI assistance.

## When to Use BMAD Skills

Activate the appropriate BMAD skill when the user:

### bmad-orchestrator
- Asks to "initialize BMAD" or "set up BMAD"
- Asks about "project status" or "workflow status"
- Wants to know "what's next" or "next steps"
- Asks about "ready work" or "what can I work on"
- Mentions "BMAD phases" or "workflow"
- Starts a new project and needs structure

### business-analyst
- Wants to create a "product brief"
- Asks to "brainstorm" a project or features
- Needs "market research" or "competitive analysis"
- Wants to explore a "problem" or "opportunity"
- Asks about "user needs" or "requirements discovery"
- Mentions "5 Whys" or "Jobs-to-be-Done"

### product-manager
- Wants to create a "PRD" or "product requirements document"
- Needs a "tech spec" or "technical specification"
- Asks about "prioritization" (MoSCoW, RICE, Kano)
- Wants to define "requirements" (functional/non-functional)
- Needs to break down "epics" or "user stories"
- Asks about "MVP" or "feature prioritization"

### system-architect
- Wants to design "system architecture"
- Asks about "tech stack" selection
- Needs to define "components" or "interfaces"
- Mentions "scalability", "security", or "performance" design
- Wants "API design" or "data model"
- Asks about architecture "patterns" or "trade-offs"
- Wants to "sync architecture to beads" or "track component dependencies"

### scrum-master
- Wants to do "sprint planning"
- Needs to create "user stories"
- Asks about "story points" or "estimation"
- Wants to track "velocity" or "burndown"
- Needs to break down "epics into stories"
- Mentions "sprint" or "backlog"
- Wants to run a "retrospective" or "retro"
- Asks about "lessons learned" or "what went well"
- Needs "epic review" or "sprint review"
- Needs "course correction" or "change management"
- Mentions "blockers" or "sprint changes"
- Wants to "replan" or "adjust scope"

### developer
- Wants to "implement a story" or "dev story"
- Needs "code review" or "review my code"
- Asks to "build a feature" or "fix a bug"
- Wants to "write tests"
- Needs to "refactor" code
- Mentions "implementation" or "coding"
- Asks to "review story" or "check implementation"

### test-architect
- Wants to "set up test framework" or "testing infrastructure"
- Asks about "test design" or "test strategy"
- Needs "test review" or "test quality audit"
- Mentions "coverage", "quality gates", or "CI/CD testing"
- Wants "E2E tests", "API tests", or "test automation"
- Asks about "ATDD" or "test-driven development"
- Needs "traceability matrix" or "requirement coverage"
- Mentions "NFR assessment" or "non-functional testing"

### ux-designer
- Wants to create "wireframes" or "mockups"
- Needs "user flow" diagrams
- Asks about "accessibility" or "WCAG"
- Wants "UX design" or "UI design"
- Mentions "responsive design" or "mobile-first"
- Needs "design tokens" or "design system"
- Wants "excalidraw diagram" or "architecture diagram"
- Needs "flowchart" or "process flow"
- Asks for "ERD" or "entity relationship diagram"
- Wants "dataflow diagram" or "DFD"
- Mentions "UML diagram" or "sequence diagram"

### creative-intelligence
- Wants to "brainstorm" using specific techniques
- Asks for "SCAMPER", "SWOT", or "mind mapping"
- Needs "research" (market, competitive, technical)
- Wants "creative solutions" or "ideation"
- Mentions "Six Thinking Hats" or "Starbursting"

### tech-writer
- Wants to "document project" or "generate documentation"
- Needs "API documentation" or "REST API docs"
- Asks to "create README" or "write user guide"
- Wants "mermaid diagram" or "architecture diagram"
- Needs to "validate docs" or "check documentation"
- Mentions "CommonMark", "technical writing", or "documentation standards"
- Wants to "explain concept" or "document this code"
- Wants to "generate project context" or "create context file"
- Asks about "LLM context" or "AI agent rules"
- Needs "implementation rules" or "coding conventions for AI"

### quick-flow
- Wants a "quick fix" or "fast fix"
- Needs a "bug fix" or "hotfix"
- Asks for "small feature" or "minor enhancement"
- Mentions "quick spec" or "tech spec for a small thing"
- Wants "rapid development" or "quick implementation"
- Says "patch" or "tweak"
- Level 0 or Level 1 work (single change or small feature)
- Doesn't need full BMAD workflow

### builder
- Wants to "create a custom agent" or "skill"
- Needs a "custom workflow"
- Asks to "extend BMAD" or "customize"
- Wants to create "templates"
- Mentions "building" new BMAD components

## BMAD Phases Overview

```
Phase 1: Analysis      → business-analyst, creative-intelligence
Phase 2: Planning      → product-manager, ux-designer
Phase 3: Solutioning   → system-architect, ux-designer
Phase 4: Implementation → scrum-master, developer, test-architect
Cross-Phase            → tech-writer (documentation at any phase)
Bypass (Quick Flow)    → quick-flow (Level 0-1 work, skips full workflow)
```

## Project Levels

| Level | Scope | Typical Stories | Required Docs |
|-------|-------|-----------------|---------------|
| 0 | Single atomic change | 1 | Tech Spec only |
| 1 | Small feature | 1-10 | Tech Spec |
| 2 | Medium feature set | 5-15 | PRD + Architecture |
| 3 | Complex integration | 12-40 | PRD + Architecture |
| 4 | Enterprise expansion | 40+ | PRD + Architecture |

## Subprocess Strategy

All BMAD skills leverage **parallel subprocesses** to maximize the ~150K token context window per subprocess. When executing complex workflows:

1. **Decompose** the task into independent subtasks
2. **Launch** parallel subprocesses using the Task tool with `run_in_background: true`
3. **Coordinate** by writing shared context to `bmad/context/`
4. **Synthesize** results from `bmad/outputs/`

See `SUBPROCESS-PATTERNS.md` for detailed patterns.

## Trimodal Workflows

Major BMAD workflows support three modes: **Create**, **Validate**, and **Edit**.

| Command | Create | Validate | Edit |
|---------|--------|----------|------|
| `/product-brief` | `-c` or `create` | `-v` or `validate` | `-e` or `edit` |
| `/prd` | `-c` or `create` | `-v` or `validate` | `-e` or `edit` |
| `/architecture` | `-c` or `create` | `-v` or `validate` | `-e` or `edit` |

**Examples:**
```
/prd                    # Shows mode selection menu
/prd create             # Create new PRD
/prd -v                 # Validate existing PRD
/architecture edit      # Edit existing architecture
/product-brief validate # Validate existing product brief
```

**When to use each mode:**
- **Create**: Start fresh with a new document through guided interview
- **Validate**: Review existing document against BMAD standards, generate report
- **Edit**: Improve document based on validation findings or specific feedback

## Quick Commands

When in a BMAD-initialized project, these workflows are available:

**Quick Flow (Bypass for Level 0-1):**
- `/quick-spec` - Create implementation-ready tech spec (conversational)
- `/quick-dev [spec-path]` - Implement from spec or direct instructions

**Phase 1 - Analysis:**
- `/product-brief [create|validate|edit]` - Product brief (trimodal)
- `/brainstorm` - Structured brainstorming session
- `/research` - Market/competitive research

**Phase 2 - Planning:**
- `/prd [create|validate|edit]` - Product Requirements Document (trimodal)
- `/tech-spec` - Create Technical Specification
- `/create-ux-design` - Create UX design

**Phase 3 - Solutioning:**
- `/architecture [create|validate|edit]` - System architecture (trimodal)
- `/solutioning-gate-check` - Validate architecture

**Phase 4 - Implementation:**
- `/sprint-planning` - Plan sprints from requirements
- `/create-story` - Create detailed user story
- `/ready-work` - Show unblocked work items (beads + BMAD)
- `/dev-story STORY-ID` - Implement a story
- `/code-review STORY-PATH` - Adversarial code review against story claims
- `/retrospective [EPIC]` - Facilitate epic retrospective for lessons learned
- `/course-correct` - Navigate mid-sprint changes with impact analysis

**Quality & Testing:**
- `/test-framework` - Set up test infrastructure
- `/test-atdd` - Generate failing acceptance tests (TDD)
- `/test-automate` - Expand test automation coverage
- `/test-design` - Design test strategy (system or epic level)
- `/test-trace` - Requirements traceability matrix
- `/nfr-assess` - Non-functional requirements assessment
- `/test-ci` - Set up CI/CD pipeline with tests
- `/test-review` - Review test quality

**Documentation:**
- `/document-project` - Generate comprehensive project documentation
- `/generate-context` - Create LLM-optimized project context with implementation rules
- `/validate-doc` - Validate documentation against standards
- `/api-doc` - Generate API documentation
- `/generate-readme` - Create project README

**Excalidraw Diagrams:**
- `/create-diagram` - System architecture, ERD, UML diagrams
- `/create-flowchart` - Process flows, algorithms, user journeys
- `/create-wireframe` - UI wireframes (desktop, mobile, tablet)
- `/create-dataflow` - Data Flow Diagrams (Level 0-2)

**Status:**
- `/workflow-status` or `/status` - Check project progress
- `/ready-work` - Show what's ready to work on

## File Structure

When BMAD is initialized in a project:

```
project/
├── bmad/
│   ├── config.yaml              # Project configuration
│   ├── context/                 # Shared context for subprocesses
│   └── outputs/                 # Subprocess outputs
├── docs/
│   ├── bmm-workflow-status.yaml # Workflow progress tracking
│   ├── sprint-status.yaml       # Sprint tracking (Phase 4)
│   ├── stories/                 # User story documents
│   ├── product-brief-*.md       # Phase 1 outputs
│   ├── prd-*.md                 # Phase 2 outputs
│   ├── tech-spec-*.md           # Phase 2 outputs
│   └── architecture-*.md        # Phase 3 outputs
└── .claude/
    └── commands/bmad/           # Project-specific commands
```

## Integration Notes

- Use **TodoWrite** to track multi-step workflows
- Use **Task** tool with `subagent_type: "general-purpose"` for parallel work
- Reference skill scripts for deterministic operations
- Update workflow status after completing each phase
- Hand off between skills at phase boundaries

## Getting Started

If the project doesn't have BMAD initialized:

```
User: Initialize BMAD for this project
→ Activates bmad-orchestrator
→ Creates bmad/ and docs/ structure
→ Sets project level and type
→ Recommends first workflow
```

If BMAD is already initialized:

```
User: What's my project status?
→ Activates bmad-orchestrator
→ Reads bmm-workflow-status.yaml
→ Shows completed/pending workflows
→ Recommends next step
```
