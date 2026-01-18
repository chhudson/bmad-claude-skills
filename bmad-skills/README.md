# BMAD Skills for Claude Code

A comprehensive skill suite implementing the **BMAD Method** (Breakthrough Method for Agile AI-Driven Development) for Claude Code. These skills leverage parallel subprocesses to maximize context utilization across ~150K token windows.

## Quick Start

1. **Install the skills** (see Installation below)
2. **Copy `CLAUDE.md`** to your project root (or use `examples/project-CLAUDE.md` as a template)
3. **Say:** "Initialize BMAD for this project"
4. **Check status:** "What's my BMAD status?"

## Architecture

```
bmad-skills/
├── CLAUDE.md                  # Skill activation guide for Claude
├── SUBPROCESS-PATTERNS.md     # Shared subprocess architecture patterns
├── examples/
│   └── project-CLAUDE.md      # Template for project CLAUDE.md
├── hooks/                     # Shared hooks for all skills
│   ├── bmad-session-start.sh  # Session initialization
│   ├── bmad-session-end.sh    # Landing choreography (session end)
│   ├── bmad-pre-tool.sh       # Pre-tool validation
│   ├── bmad-post-tool.sh      # Post-tool tracking
│   └── beads-prime.sh         # Beads context injection (optional)
├── shared/                    # Shared templates and utilities
├── bmad-orchestrator/         # Core workflow orchestrator
├── business-analyst/          # Phase 1: Analysis
├── product-manager/           # Phase 2: Planning
├── system-architect/          # Phase 3: Solutioning
├── scrum-master/              # Phase 4: Sprint Planning
├── developer/                 # Phase 4: Implementation
├── test-architect/            # Phase 4: Quality & Testing
├── ux-designer/               # Cross-phase UX design
├── creative-intelligence/     # Cross-phase research/brainstorming
└── builder/                   # Meta: Create custom skills
```

## Skills Overview

| Skill | Phase | Purpose | Subprocess Strategy |
|-------|-------|---------|---------------------|
| **bmad-orchestrator** | All | Project init, status, routing | Parallel status checks |
| **business-analyst** | 1 | Product discovery, research | 4-way parallel research |
| **product-manager** | 2 | PRD, requirements, prioritization | Parallel section generation |
| **system-architect** | 3 | Architecture design | Parallel component design |
| **scrum-master** | 4 | Sprint planning, stories | Parallel epic breakdown |
| **developer** | 4 | Story implementation, code review | Parallel story implementation |
| **test-architect** | 4 | Quality strategy, test framework, CI/CD | Parallel test suite generation |
| **ux-designer** | 2-3 | UX design, wireframes, accessibility | Parallel screen design |
| **creative-intelligence** | All | Brainstorming, research | Multi-technique parallel |
| **builder** | N/A | Create custom skills/workflows | Parallel component creation |

## BMAD Method Phases

```
Phase 1: Analysis      → Business Analyst, Creative Intelligence
Phase 2: Planning      → Product Manager, UX Designer
Phase 3: Solutioning   → System Architect, UX Designer
Phase 4: Implementation → Scrum Master, Developer, Test Architect
```

## Project Levels

| Level | Scope | Stories | Required Docs |
|-------|-------|---------|---------------|
| 0 | Single change | 1 | Tech Spec |
| 1 | Small feature | 1-10 | Tech Spec |
| 2 | Medium feature | 5-15 | PRD + Architecture |
| 3 | Complex integration | 12-40 | PRD + Architecture |
| 4 | Enterprise expansion | 40+ | PRD + Architecture |

## Installation

### Personal Installation (User-level)

```bash
# Clone or copy to your Claude skills directory
cp -r bmad-skills/* ~/.claude/skills/
```

### Project Installation (Team-level)

```bash
# Copy to project's .claude directory
cp -r bmad-skills/* .claude/skills/

# Copy the CLAUDE.md to your project root
cp bmad-skills/examples/project-CLAUDE.md ./CLAUDE.md
# Edit CLAUDE.md to customize for your project
```

### Hook Configuration

Add to your Claude Code settings (`~/.claude/settings.json` or `.claude/settings.json`):

```json
{
  "hooks": {
    "SessionStart": [
      {
        "command": "bash ~/.claude/skills/hooks/bmad-session-start.sh"
      },
      {
        "command": "bash ~/.claude/skills/hooks/beads-prime.sh"
      }
    ],
    "PreToolUse": [
      {
        "command": "bash ~/.claude/skills/hooks/bmad-pre-tool.sh"
      }
    ],
    "PostToolUse": [
      {
        "command": "bash ~/.claude/skills/hooks/bmad-post-tool.sh"
      }
    ],
    "PreCompact": [
      {
        "command": "bash ~/.claude/skills/hooks/beads-prime.sh"
      }
    ],
    "SessionEnd": [
      {
        "command": "bash ~/.claude/skills/hooks/bmad-session-end.sh"
      }
    ]
  }
}
```

### Beads Integration (Optional)

If you use [beads](https://github.com/steveyegge/beads) for issue tracking, BMAD integrates automatically:

**Context Injection (Hooks):**
- **SessionStart**: Runs `bd prime` to inject workflow context (~1-2k tokens)
- **PreCompact**: Refreshes beads context before context compaction

**Story-Beads Bridge:**
- `/create-story` creates both BMAD story documents AND beads issues
- Stories are linked with matching IDs (`STORY-001` → `bd-xxxx`)
- Priority mapping: Must Have=p1, Should Have=p2, Could Have=p3, Won't Have=p4
- Labels added: `bmad:story`, `sp:{points}`

**Ready Work Command:**
- `/ready-work` shows unblocked work by combining beads + BMAD data
- Cross-references `bd ready --json` with `docs/stories/` files
- Displays priority, story points, epic, and sync status
- Works without beads (shows local BMAD stories only)

**Sprint-Beads Integration:**
- `/sprint-planning` creates beads sprint molecules (epics) to group stories
- Sprint molecule ID stored in `.bmad/sprint-status.yaml`
- Stories linked to sprint molecule via `bd dep add`
- Query sprint progress directly from beads with `burndown.sh`
- Scripts:
  - `sprint-from-beads.sh <num> <goal> [start] [end]` - Create sprint molecule
  - `burndown.sh <sprint-id> [--format json|table]` - Get burndown data
- Labels added: `bmad:sprint`, `sprint:{N}`

**Landing Choreography (Session End):**
- **SessionEnd hook** ensures proper session completion
- Runs `bd sync` to flush beads data to JSONL and push to git
- Checks for uncommitted/unpushed changes
- Outputs landing status summary with warnings
- Uses `shared/scripts/landing-check.sh` for verification

**Graceful Degradation:**
All beads integration gracefully skips if:
- `bd` command is not installed
- `.beads/` directory doesn't exist in the project

No configuration needed - just install beads and initialize it in your project.

## Usage

### Initialize a BMAD Project

```
> Initialize this project with BMAD

Claude will use bmad-orchestrator to:
1. Create bmad/ directory structure
2. Set up docs/ for outputs
3. Create workflow status tracking
4. Determine project level
```

### Check Workflow Status

```
> What's my BMAD project status?

Shows completed phases, current phase, and recommended next steps.
```

### Execute Phase Workflows

```
Phase 1:
> Create a product brief for this project
> Research the market for [topic]
> Brainstorm features using SCAMPER

Phase 2:
> Create a PRD based on the product brief
> Create a tech spec for this feature
> Prioritize these requirements using RICE

Phase 3:
> Design the system architecture
> Run the solutioning gate check

Phase 4:
> Plan the sprint from the PRD
> Create user story STORY-001
> Implement STORY-001
> Review STORY-001 implementation
```

### Code Review Workflow

Every story must pass adversarial code review before being marked "done":

```
/dev-story STORY-001     → Implement story
/code-review docs/stories/STORY-001.md  → Review implementation
                         → [If issues found]
/dev-story STORY-001     → Fix review findings
/code-review ...         → Re-review until clean
```

**Code review validates:**
- Acceptance criteria implemented (not just claimed)
- Tasks marked `[x]` actually done (verified in git)
- Code quality (security, performance, error handling)
- Test quality (real assertions, coverage)

**Severity levels:**
- 🔴 CRITICAL: False claims, security vulnerabilities - must fix
- 🟡 HIGH: Missing AC, major quality issues - must fix
- 🟠 MEDIUM: Undocumented changes - should fix
- 🟢 LOW: Style, suggestions - nice to fix

## Subprocess Architecture

All BMAD skills leverage parallel subprocesses for maximum efficiency:

```
┌─────────────────────────────────┐
│     Main Skill Context          │
│     (Orchestration Layer)       │
└───────────────┬─────────────────┘
                │
    ┌───────────┼───────────┐
    ▼           ▼           ▼
┌───────┐   ┌───────┐   ┌───────┐
│Subproc│   │Subproc│   │Subproc│
│   1   │   │   2   │   │   3   │
│ ~150K │   │ ~150K │   │ ~150K │
└───────┘   └───────┘   └───────┘
```

See [SUBPROCESS-PATTERNS.md](SUBPROCESS-PATTERNS.md) for detailed patterns.

## Skill Structure

Each skill follows the Anthropic Claude Code specification:

```
skill-name/
├── SKILL.md              # Required: Main entry with YAML frontmatter
├── REFERENCE.md          # Optional: Detailed reference material
├── scripts/              # Optional: Executable utilities
│   └── *.sh, *.py
├── templates/            # Optional: Document templates
│   └── *.template.md
└── resources/            # Optional: Reference data
    └── *.md
```

### SKILL.md Format

```yaml
---
name: skill-name
description: Clear description AND when to use it (max 1024 chars)
allowed-tools: Read, Write, Edit, Bash, Glob, Grep, TodoWrite, Task
---

# Skill Name

[Markdown instructions under 5K tokens]
```

## Contributing

1. Follow Anthropic skill specification
2. Include subprocess strategy in SKILL.md
3. Use progressive disclosure (Level 1/2/3 loading)
4. Provide scripts for deterministic operations
5. Include templates with {{variable}} substitution

## License

MIT License - See LICENSE file
