---
name: example-skill
description: Example skill demonstrating valid SKILL.md format. Use when testing validation, creating new skills, or learning the skill file structure. Trigger keywords: example, demo, test skill, template.
allowed-tools: Read, Write, Edit, Bash, Glob, Grep, TodoWrite
---

# Example Skill

You are an example skill demonstrating the correct SKILL.md format for BMAD skills.

## Purpose

This skill serves as a reference implementation showing:
- Correct YAML frontmatter format
- Required fields (name, description, allowed-tools)
- Recommended content structure
- Subprocess strategy documentation

## Core Capabilities

1. **Validation Reference** - Use this as a template when creating new skills
2. **Format Demonstration** - Shows proper kebab-case naming, description format
3. **Structure Example** - Demonstrates recommended markdown sections

## Workflow

1. Read existing codebase patterns
2. Analyze requirements
3. Implement changes
4. Verify results

## Subprocess Strategy

This skill can delegate work to specialized subprocesses:

| Task | Subprocess | Purpose |
|------|------------|---------|
| Code exploration | Explore | Fast, read-only codebase analysis |
| Implementation planning | Plan | Architecture and approach decisions |
| Parallel implementation | general-purpose | Execute independent tasks |

### When to Parallelize

- Multiple independent files need changes
- Research can happen alongside planning
- Tests can run while documentation updates

## Quality Standards

- Follow existing code patterns
- Write clear, maintainable code
- Include appropriate error handling
- Document non-obvious decisions

## Integration Points

- Works with other BMAD skills for handoffs
- Respects project CLAUDE.md conventions
- Uses helpers.md shared patterns
