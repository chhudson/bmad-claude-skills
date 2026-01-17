# BMAD Skills Development Repository

This repository contains the **BMAD Skills** package for Claude Code - a suite of skills implementing the BMAD Method (Breakthrough Method for Agile AI-Driven Development).

## Repository Structure

```
claude-code-bmad-skills/
├── bmad-skills/              # The distributable skills package
│   ├── CLAUDE.md             # User-facing skill activation guide
│   ├── SUBPROCESS-PATTERNS.md  # Subprocess architecture patterns
│   ├── bmad-orchestrator/    # Core orchestrator skill
│   ├── business-analyst/     # Phase 1: Analysis
│   ├── product-manager/      # Phase 2: Planning
│   ├── system-architect/     # Phase 3: Solutioning
│   ├── scrum-master/         # Phase 4: Sprint Planning
│   ├── developer/            # Phase 4: Implementation
│   ├── ux-designer/          # Cross-phase UX
│   ├── creative-intelligence/# Cross-phase research/brainstorming
│   ├── builder/              # Meta: Create custom skills
│   ├── shared/               # Shared templates and utilities
│   ├── hooks/                # Session/tool hooks
│   └── examples/             # Example project templates
├── bmad-v6/                  # Legacy/source BMAD implementation
├── docs/                     # GitHub Pages documentation site
└── install-v6.sh/ps1         # Installation scripts
```

## Development Tasks

When working on this repo, I may ask you to:

### Skill Development
- "Add a new skill for [domain]" → Use the builder skill patterns
- "Update [skill-name] skill" → Edit files in bmad-skills/[skill-name]/
- "Add a script to [skill-name]" → Create executable in scripts/
- "Add a template for [workflow]" → Create in templates/

### Skill Structure (Anthropic Specification)
Each skill must have:
```
skill-name/
├── SKILL.md           # Required: YAML frontmatter + instructions (<5K tokens)
├── REFERENCE.md       # Optional: Detailed reference material
├── scripts/           # Optional: Executable utilities (.sh, .py)
├── templates/         # Optional: Document templates (.template.md)
└── resources/         # Optional: Reference data (.md)
```

### SKILL.md Format
```yaml
---
name: skill-name           # lowercase, hyphens, max 64 chars
description: |             # max 1024 chars, include trigger words
  What it does AND when to use it.
allowed-tools: Read, Write, Edit, Bash, Glob, Grep, TodoWrite
---

# Skill Name

[Markdown content under 5K tokens]
```

### Testing Skills
- Test trigger phrases match the skill description
- Verify scripts are executable and functional
- Check templates have proper {{variable}} placeholders
- Ensure SKILL.md stays under 5K tokens

### Subprocess Patterns
All skills should include a "Subprocess Strategy" section defining:
- Which workflows use parallel subprocesses
- Subprocess count and task allocation
- Coordination approach
- Example subprocess prompts

## Key Files to Know

| File | Purpose |
|------|---------|
| `bmad-skills/CLAUDE.md` | User-facing skill activation guide |
| `bmad-skills/SUBPROCESS-PATTERNS.md` | Subprocess architecture reference |
| `bmad-skills/shared/helpers.md` | Shared utility patterns |
| `bmad-skills/builder/` | Meta-skill for creating new skills |
| `docs/` | GitHub Pages documentation |

## Common Development Commands

```bash
# Validate a skill's YAML frontmatter
./bmad-skills/builder/scripts/validate-skill.sh bmad-skills/[skill]/SKILL.md

# Scaffold a new skill
./bmad-skills/builder/scripts/scaffold-skill.sh new-skill-name

# Check all scripts are executable
find bmad-skills -name "*.sh" -o -name "*.py" | xargs ls -la
```

## When Making Changes

1. **Edit skills in `bmad-skills/`** - this is the distributable package
2. **Keep SKILL.md concise** - under 5K tokens, reference REFERENCE.md for details
3. **Make scripts executable** - `chmod +x` on all .sh and .py files
4. **Include subprocess strategies** - define parallel execution patterns
5. **Update documentation** - keep docs/ in sync for GitHub Pages

## Legacy Reference

The `bmad-v6/` directory contains the original BMAD implementation. Use it as reference but don't modify - all active development is in `bmad-skills/`.
