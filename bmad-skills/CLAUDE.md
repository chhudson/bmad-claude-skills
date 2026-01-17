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

### scrum-master
- Wants to do "sprint planning"
- Needs to create "user stories"
- Asks about "story points" or "estimation"
- Wants to track "velocity" or "burndown"
- Needs to break down "epics into stories"
- Mentions "sprint" or "backlog"

### developer
- Wants to "implement a story" or "dev story"
- Needs "code review"
- Asks to "build a feature" or "fix a bug"
- Wants to "write tests"
- Needs to "refactor" code
- Mentions "implementation" or "coding"

### ux-designer
- Wants to create "wireframes" or "mockups"
- Needs "user flow" diagrams
- Asks about "accessibility" or "WCAG"
- Wants "UX design" or "UI design"
- Mentions "responsive design" or "mobile-first"
- Needs "design tokens" or "design system"

### creative-intelligence
- Wants to "brainstorm" using specific techniques
- Asks for "SCAMPER", "SWOT", or "mind mapping"
- Needs "research" (market, competitive, technical)
- Wants "creative solutions" or "ideation"
- Mentions "Six Thinking Hats" or "Starbursting"

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
Phase 4: Implementation → scrum-master, developer
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

## Quick Commands

When in a BMAD-initialized project, these workflows are available:

**Phase 1 - Analysis:**
- `/product-brief` - Create product brief
- `/brainstorm` - Structured brainstorming session
- `/research` - Market/competitive research

**Phase 2 - Planning:**
- `/prd` - Create Product Requirements Document
- `/tech-spec` - Create Technical Specification
- `/create-ux-design` - Create UX design

**Phase 3 - Solutioning:**
- `/architecture` - Design system architecture
- `/solutioning-gate-check` - Validate architecture

**Phase 4 - Implementation:**
- `/sprint-planning` - Plan sprints from requirements
- `/create-story` - Create detailed user story
- `/ready-work` - Show unblocked work items (beads + BMAD)
- `/dev-story STORY-ID` - Implement a story

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
