# Quick Flow Reference Guide

Extended reference for the Quick Flow Solo Dev skill. Use this for detailed patterns, templates, and decision trees.

## Table of Contents

1. [Quick-Spec Detailed Workflow](#quick-spec-detailed-workflow)
2. [Quick-Dev Detailed Workflow](#quick-dev-detailed-workflow)
3. [Escalation Decision Tree](#escalation-decision-tree)
4. [Tech-Spec Template Variations](#tech-spec-template-variations)
5. [Pattern Library](#pattern-library)
6. [Integration with Beads](#integration-with-beads)

---

## Quick-Spec Detailed Workflow

### Step 1: Analyze Requirement Delta (Discovery)

**Entry Actions:**
1. Check for work-in-progress file (`docs/tech-spec-*.wip.md`)
   - If exists, offer to resume
2. Greet user with Barry's direct style
3. Ask for initial description of what they need

**Orient Scan (Quick Analysis):**
```bash
# Check for existing documentation
ls -la docs/ 2>/dev/null | head -20

# Scan for project context
find . -name "project-context.md" -o -name "CLAUDE.md" 2>/dev/null | head -5

# Identify key directories
ls -la src/ lib/ app/ components/ 2>/dev/null | head -30
```

**Informed Questions:**
Based on code findings, ask questions like:
- "I see you're using [framework]. Should this follow your existing [pattern] pattern?"
- "I found [related file]. Is this feature related to that functionality?"
- "Your tests are in [location]. Should I add tests there?"

**Capture (Required Fields):**
- **Title:** Clear, descriptive name
- **Slug:** URL-safe identifier (lowercase, hyphens)
- **Problem Statement:** What problem are we solving?
- **Solution:** High-level approach
- **In Scope:** What's included
- **Out of Scope:** What's explicitly excluded

**Checkpoint Menu:**
```
Progress saved. What next?
[a] Advanced elicitation - ask more questions
[c] Continue to technical mapping
[s] Skip to spec generation (if requirements are clear)
```

### Step 2: Map Technical Constraints

**Deep Investigation:**
1. Read files identified in Step 1
2. Extract patterns from existing code:
   - Naming conventions
   - File organization
   - Error handling patterns
   - Test patterns
   - Import/export style

**Document:**
| Category | Finding |
|----------|---------|
| Tech Stack | [Languages, frameworks, libraries] |
| Code Patterns | [Detected patterns with examples] |
| Files to Modify | [List with reasons] |
| Files to Create | [New files needed] |
| Test Patterns | [How tests are structured] |
| Dependencies | [External requirements] |

**Checkpoint Menu:**
```
Technical mapping complete.
[c] Continue to spec generation
[m] More investigation needed
[r] Re-examine specific area
```

### Step 3: Generate Spec

**Spec Structure:**
1. Header with metadata
2. Overview (Problem, Solution, Scope)
3. Context for Development
4. Implementation Plan (Tasks, ACs, Tests)

**Task Ordering Rules:**
1. Data/schema changes first
2. Backend/API changes second
3. Business logic third
4. Frontend/UI fourth
5. Integration tests last

**Acceptance Criteria Format:**
```markdown
- [ ] **AC-1:** Given [precondition], When [action], Then [expected result]
```

### Step 4: Review and Finalize

**Validation Checklist:**
- [ ] Problem clearly stated
- [ ] Solution addresses the problem
- [ ] Scope boundaries are clear
- [ ] All tasks have file paths
- [ ] Tasks are dependency-ordered
- [ ] ACs are testable (Given/When/Then)
- [ ] No "TBD" or placeholders remain
- [ ] A fresh agent could implement this

**Save Location:** `docs/tech-spec-{slug}.md`

---

## Quick-Dev Detailed Workflow

### Step 1: Mode Detection & Setup

**Baseline Capture:**
```bash
# Capture current commit
git rev-parse HEAD 2>/dev/null || echo "NO_GIT"
```

**Mode Detection Logic:**
```
IF user provides file path ending in .md or mentions "tech spec"
  → Mode A (Tech-Spec Driven)
ELSE
  → Mode B (Direct Instructions)
```

**Escalation Evaluation (Mode B Only):**

| Signal | Weight |
|--------|--------|
| Multiple components mentioned | +1 |
| System-level language (architecture, infrastructure) | +1 |
| Uncertainty expressed | +1 |
| Multi-layer scope (frontend + backend + db) | +1 |
| Extended timeframe mentioned | +1 |
| Simplicity markers ("fix", "bug", "small") | -1 |
| Single file focus | -1 |
| Confident, specific request | -1 |

**Total score determines escalation level:**
- Score < 2: No escalation, offer direct execution
- Score 2-3: Mild escalation, recommend tech-spec
- Score 4+: Strong escalation, recommend full BMAD

### Step 2: Context Gathering (Mode B)

**If Direct Execution Chosen:**
1. Parse task description into components
2. Identify affected files
3. Load relevant existing code
4. Understand patterns to follow

**Questions to Consider:**
- What files need to change?
- What patterns should I follow?
- Are there related tests?
- What could break?

### Step 3: Execute

**Mode A (Tech-Spec):**
1. Load tech-spec file
2. Parse tasks section
3. Execute tasks in order
4. Mark tasks complete as you go
5. Run tests after each significant change

**Mode B (Direct):**
1. Break task into subtasks with TodoWrite
2. Execute subtasks in logical order
3. Follow detected patterns
4. Write tests alongside implementation
5. Verify each subtask before proceeding

**Continuous Execution Rules:**
- Don't stop between tasks unless blocked
- If error occurs, fix and continue
- If unclear, ask user briefly
- Commit after logical chunks

### Step 4: Self-Check

**Verification Checklist:**
```
[ ] All tasks from spec/todo completed
[ ] Tests passing
[ ] No linting errors
[ ] Acceptance criteria satisfied
[ ] No uncommitted changes (or changes staged)
[ ] Build succeeds (if applicable)
```

### Step 5: Adversarial Self-Review

**Review Focus Areas:**
1. **Correctness:** Does it actually work?
2. **Edge Cases:** What happens with bad input?
3. **Error Handling:** Are errors caught and handled?
4. **Security:** Any obvious vulnerabilities?
5. **Performance:** Any obvious bottlenecks?
6. **Maintainability:** Is the code clear?

**Minimum Findings Target:** 3+ items
- Finding something means you're being thorough
- "Looks good" is not acceptable

### Step 6: Resolve Findings

For each finding:
1. Assess severity (CRITICAL/HIGH/MEDIUM/LOW)
2. Fix CRITICAL and HIGH immediately
3. Document MEDIUM as tech debt if appropriate
4. Note LOW for future improvement

---

## Escalation Decision Tree

```
User Request
    │
    ├─ Explicit tech-spec path provided?
    │       │
    │       YES → Mode A: Execute from spec
    │
    ├─ NO → Evaluate escalation signals
            │
            ├─ Score < 2 (Simple)
            │       │
            │       └─ Offer: [e] Execute directly, [t] Tech-spec first
            │
            ├─ Score 2-3 (Moderate)
            │       │
            │       └─ Offer: [t] Tech-spec (recommended), [e] Execute, [w] Full BMAD
            │
            └─ Score 4+ (Complex)
                    │
                    └─ Offer: [w] Full BMAD (recommended), [t] Tech-spec, [e] Execute
```

**Escalation Examples:**

| Request | Signals | Score | Recommendation |
|---------|---------|-------|----------------|
| "Fix the typo in header.js" | Single file, simplicity | -2 | Execute directly |
| "Add validation to the login form" | Single component | 0 | Offer both |
| "Refactor auth to use JWT" | Multi-layer, architecture | 3 | Tech-spec first |
| "Build user dashboard with real-time updates" | Multiple components, multi-layer | 4 | Full BMAD |

---

## Tech-Spec Template Variations

### Bug Fix Template

```markdown
# Tech-Spec: Fix {bug description}

**Created:** {date}
**Status:** Ready for Development
**Slug:** fix-{slug}
**Type:** Bug Fix

## Bug Report

### Observed Behavior
[What's happening]

### Expected Behavior
[What should happen]

### Reproduction Steps
1. [Step 1]
2. [Step 2]

### Root Cause Analysis
[What's causing the bug - from code investigation]

## Fix Implementation

### Files to Modify
| File | Change |
|------|--------|
| path/to/file | What to change |

### Tasks
1. [ ] [Primary fix]
2. [ ] [Add regression test]
3. [ ] [Verify fix]

### Acceptance Criteria
- [ ] **AC-1:** Given [bug scenario], When [action], Then [correct behavior]
- [ ] **AC-2:** Regression test passes
```

### Small Feature Template

```markdown
# Tech-Spec: {feature name}

**Created:** {date}
**Status:** Ready for Development
**Slug:** {slug}
**Type:** Feature

## Overview

### Problem Statement
[What user need are we addressing?]

### Solution
[How will we address it?]

### Scope
**In Scope:**
- [Feature aspects included]

**Out of Scope:**
- [What we're NOT doing]

## Context for Development

### Codebase Patterns
[Detected patterns to follow]

### Files to Reference
| File | Purpose |
|------|---------|
| path | relevance |

## Implementation Plan

### Tasks
1. [ ] [Task 1 with file paths]
2. [ ] [Task 2 with file paths]
...

### Acceptance Criteria
- [ ] **AC-1:** Given [context], When [action], Then [result]

### Testing Strategy
- Unit: [approach]
- Integration: [approach]
```

### Enhancement Template

```markdown
# Tech-Spec: Enhance {existing feature}

**Created:** {date}
**Status:** Ready for Development
**Slug:** enhance-{slug}
**Type:** Enhancement

## Current State
[How it works now]

## Target State
[How it should work after enhancement]

## Change Summary
[What's changing]

## Implementation Plan

### Tasks
1. [ ] [Modify existing code]
2. [ ] [Add new functionality]
3. [ ] [Update tests]
4. [ ] [Update documentation if needed]

### Acceptance Criteria
- [ ] **AC-1:** Existing functionality preserved
- [ ] **AC-2:** New functionality works as specified
```

---

## Pattern Library

### Common Quick-Flow Patterns

**Adding a New API Endpoint:**
1. Define route in routes file
2. Create controller/handler
3. Add validation middleware
4. Implement business logic
5. Add error handling
6. Write tests
7. Update API documentation (if exists)

**Adding Form Validation:**
1. Identify validation rules
2. Create validation schema/function
3. Integrate with form component
4. Add error display UI
5. Write tests for each rule
6. Test edge cases

**Adding Database Field:**
1. Update schema/migration
2. Update model
3. Update API endpoints that touch this model
4. Update frontend to handle new field
5. Write migration (if applicable)
6. Test CRUD operations

**Fixing a Bug:**
1. Write failing test that reproduces bug
2. Find root cause in code
3. Implement fix
4. Verify test passes
5. Check for related issues
6. Add regression test

---

## Integration with Beads

When beads is configured, Quick Flow integrates automatically:

### Creating Issues from Quick-Spec

After generating a tech-spec, optionally create beads issues:

```bash
# Create issue for the feature
bd create "[QF] {title}" -p 2 -l "bmad:quick-flow,type:feature"
```

### Linking Tasks to Issues

For multi-task specs, create linked issues:

```bash
# Create parent issue
PARENT=$(bd create "[QF] {feature}" -p 2 -l "bmad:quick-flow")

# Create task issues
bd create "Task 1 description" -p 2 --parent $PARENT
bd create "Task 2 description" -p 2 --parent $PARENT
```

### Closing on Completion

After successful implementation:

```bash
# Close the quick-flow issue
bd close {issue-id}
```

### Quick-Dev with Beads

When starting quick-dev:
1. Check `bd ready` for assigned quick-flow issues
2. Update status when starting: `bd update {id} --status in_progress`
3. Close on completion: `bd close {id}`

---

## Troubleshooting

### "Tech-spec feels incomplete"

Check the Ready for Development Standard:
- [ ] Every task has file paths?
- [ ] Tasks are in dependency order?
- [ ] ACs use Given/When/Then?
- [ ] No "TBD" or placeholders?
- [ ] A fresh agent could implement?

### "Escalation seems wrong"

Re-evaluate signals:
- Are there really multiple components?
- Is "architecture" language being used loosely?
- Is the request actually simple but poorly phrased?

### "Implementation keeps going off track"

Return to the spec:
1. Re-read the spec
2. Identify where divergence started
3. Decide: Update spec or revert code?
4. Continue from corrected state

### "Tests are failing after changes"

Quick-dev debugging:
1. Run tests in isolation
2. Check if test expectations are outdated
3. Verify your changes match the spec
4. Consider if the test itself needs updating
