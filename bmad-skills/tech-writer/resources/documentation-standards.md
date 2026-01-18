# Technical Documentation Standards

**Purpose:** Concise reference for documentation creation and review

---

## Critical Rules

### Rule 1: CommonMark Strict Compliance

ALL documentation MUST follow CommonMark specification exactly. No exceptions.

### Rule 2: NO Time Estimates

NEVER document time estimates, durations, or completion times for any workflow, task, or activity. This includes:

- Workflow execution time (e.g., "30-60 min", "2-8 hours")
- Task duration estimates
- Reading time estimates
- Implementation time ranges
- Any temporal measurements

**Instead:** Focus on workflow steps, dependencies, and outputs. Let users determine their own timelines.

---

## CommonMark Essentials

### Headers

- Use ATX-style ONLY: `#` `##` `###` (NOT Setext underlines)
- Single space after `#`: `# Title` (NOT `#Title`)
- No trailing `#`: `# Title` (NOT `# Title #`)
- Hierarchical order: Don't skip levels (h1 → h2 → h3, not h1 → h3)

### Code Blocks

Use fenced blocks with language identifier:

````markdown
```javascript
const example = 'code';
```
````

NOT indented code blocks (ambiguous).

### Lists

- Consistent markers within list: all `-` or all `*` or all `+` (don't mix)
- Proper indentation for nested items (2 or 4 spaces, stay consistent)
- Blank line before/after list for clarity

### Links

- Inline: `[text](url)`
- Reference: `[text][ref]` then `[ref]: url` at bottom
- NO bare URLs without `<>` brackets
- Descriptive link text: "See the API reference" NOT "Click here"

### Emphasis

- Italic: `*text*` or `_text_`
- Bold: `**text**` or `__text__`
- Consistent style within document

### Line Breaks

- Two spaces at end of line + newline, OR
- Blank line between paragraphs
- NO single line breaks (they're ignored)

---

## Mermaid Diagrams

### Critical Rules

1. Always specify diagram type first line
2. Use valid Mermaid v10+ syntax
3. Keep focused: 5-10 nodes ideal, max 15
4. Test syntax mentally before outputting

### Diagram Type Selection

| Type | Use For |
|------|---------|
| `flowchart` | Process flows, decision trees, workflows |
| `sequenceDiagram` | API interactions, message flows |
| `classDiagram` | Object models, class relationships |
| `erDiagram` | Database schemas, entity relationships |
| `stateDiagram-v2` | State machines, lifecycle stages |
| `gitGraph` | Branch strategies, version control flows |

### Formatting Example

````markdown
```mermaid
flowchart TD
    Start[Clear Label] --> Decision{Question?}
    Decision -->|Yes| Action1[Do This]
    Decision -->|No| Action2[Do That]
```
````

---

## Style Guide Principles

Apply in this hierarchy:

1. **Project-specific guide** (if exists) - always check first
2. **BMAD conventions** (this document)
3. **Google Developer Docs style** (defaults below)
4. **CommonMark spec** (when in doubt)

### Core Writing Rules

**Task-Oriented Focus:**
- Write for user GOALS, not feature lists
- Start with WHY, then HOW
- Every doc answers: "What can I accomplish?"

**Clarity Principles:**
- Active voice: "Click the button" NOT "The button should be clicked"
- Present tense: "The function returns" NOT "The function will return"
- Direct language: "Use X for Y" NOT "X can be used for Y"
- Second person: "You configure" NOT "Users configure" or "One configures"

**Structure:**
- One idea per sentence
- One topic per paragraph
- Headings describe content accurately
- Examples follow explanations

**Accessibility:**
- Descriptive link text
- Alt text for diagrams
- Semantic heading hierarchy (don't skip levels)
- Tables have headers

---

## Documentation Types Quick Reference

### README

- What (overview), Why (purpose), How (quick start)
- Installation, Usage, Contributing, License
- Under 500 lines (link to detailed docs)

### API Reference

- Complete endpoint coverage
- Request/response examples
- Authentication details
- Error handling
- Rate limits if applicable

### User Guide

- Task-based sections (How to...)
- Step-by-step instructions
- Screenshots/diagrams where helpful
- Troubleshooting section

### Architecture Docs

- System overview diagram (Mermaid)
- Component descriptions
- Data flow
- Technology decisions (ADRs)
- Deployment architecture

### Developer Guide

- Setup/environment requirements
- Code organization
- Development workflow
- Testing approach
- Contribution guidelines

---

## Quality Checklist

Before finalizing ANY documentation:

- [ ] CommonMark compliant (no violations)
- [ ] NO time estimates anywhere (Critical Rule 2)
- [ ] Headers in proper hierarchy
- [ ] All code blocks have language tags
- [ ] Links work and have descriptive text
- [ ] Mermaid diagrams render correctly
- [ ] Active voice, present tense
- [ ] Task-oriented (answers "how do I...")
- [ ] Examples are concrete and working
- [ ] Accessibility standards met
- [ ] Spelling/grammar checked
- [ ] Reads clearly at target skill level

---

## BMAD-Specific Conventions

### File Organization

- `README.md` at root of each major component
- `docs/` folder for extensive documentation
- Workflow-specific docs in workflow folder
- Cross-references use relative paths

### Frontmatter

Use YAML frontmatter when appropriate:

```yaml
---
title: Document Title
description: Brief description
author: Author name
date: YYYY-MM-DD
---
```

### Metadata

- Always include last-updated date
- Version info for versioned docs
- Author attribution for accountability

---

**Remember:** This is your foundation. Follow these rules consistently, and all documentation will be clear, accessible, and maintainable.
