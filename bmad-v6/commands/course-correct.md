---
description: Navigate significant sprint changes by analyzing impact, proposing solutions, and routing for implementation. Use when implementation reveals blockers, requirements change, or approaches fail.
argument-hint: [story-id or description]
allowed-tools: Read, Write, Edit, Glob, Grep, Bash, Task
---

# Course Correct - Sprint Change Management Workflow

**Agent:** Product Manager (PM) or Scrum Master (SM)
**Trigger:** `/course-correct` or `[CC]`
**Purpose:** Navigate significant mid-sprint changes with structured impact analysis and clear implementation routing

## When to Use This Workflow

- Implementation reveals technical limitations
- New requirements emerge from stakeholders
- Misunderstanding of original requirements discovered
- Strategic pivot or market change
- Failed approach requiring different solution
- Any significant deviation from original plan

---

## Step 0: Load Project Context

**Reference:** `@bmad-skills/shared/helpers.md#Load-Project-Config`

Load and verify access to required documents:

```
Required Documents:
├── docs/prd.md (or docs/prd/*.md shards)
├── docs/architecture.md (or docs/architecture/*.md)
├── docs/epics/*.md
├── docs/stories/*.md
└── .bmad/sprint-status.yaml
```

**If documents missing:** Inform user which documents are needed before proceeding.

---

## Step 1: Initialize Change Navigation

### 1.1 Confirm Change Trigger

Ask user to describe:
1. **What triggered this change?** (Story ID, discovery, external event)
2. **What is the core problem?** (1-2 sentences)
3. **What category best describes it?**
   - [ ] Technical limitation discovered during implementation
   - [ ] New requirement emerged from stakeholders
   - [ ] Misunderstanding of original requirements
   - [ ] Strategic pivot or market change
   - [ ] Failed approach requiring different solution

### 1.2 Select Mode Preference

Ask user:

> **How would you like to review change proposals?**
>
> **A) Incremental (Recommended):** Review and approve each edit proposal one-by-one
> **B) Batch:** See all proposed changes together, then approve/modify

Store mode selection for Step 3.

**Halt if:**
- Change trigger is unclear
- Core documents are unavailable

---

## Step 2: Execute Change Analysis Checklist

Work through each section interactively. Mark items as:
- `[x]` Done - Item completed
- `[N/A]` Skip - Not applicable
- `[!]` Action-needed - Requires follow-up

### Section 1: Understand Trigger & Context

- [ ] **1.1** Identify triggering story (ID + description)
- [ ] **1.2** Define core problem precisely with category from Step 1
- [ ] **1.3** Gather supporting evidence (error logs, feedback, analysis)

### Section 2: Epic Impact Assessment

- [ ] **2.1** Evaluate current epic containing trigger story
  - Epic ID: ___
  - Current status: ___
  - Stories affected: ___

- [ ] **2.2** Determine required epic-level changes:
  - [ ] Modify existing epic scope/acceptance criteria
  - [ ] Add new epic
  - [ ] Remove or defer epic
  - [ ] Completely redefine epic
  - [ ] No epic changes needed

- [ ] **2.3** Review all remaining planned epics for impact
- [ ] **2.4** Check if issue invalidates future epics or creates new ones
- [ ] **2.5** Consider if epic order/priority should change

### Section 3: Artifact Conflict & Impact Analysis

- [ ] **3.1** Check PRD for conflicts:
  - [ ] Goals and objectives
  - [ ] Requirements (FR/NFR)
  - [ ] MVP definition
  - [ ] Success metrics

- [ ] **3.2** Review Architecture document for impact:
  - [ ] System components and interactions
  - [ ] Architectural patterns
  - [ ] Technology stack choices
  - [ ] Data models and schemas
  - [ ] API designs and contracts
  - [ ] Integration points

- [ ] **3.3** Examine UI/UX specifications for conflicts:
  - [ ] UI components
  - [ ] User flows and journeys
  - [ ] Wireframes/mockups
  - [ ] Interaction patterns

- [ ] **3.4** Consider secondary artifacts:
  - [ ] Deployment scripts
  - [ ] Infrastructure as Code
  - [ ] CI/CD pipelines
  - [ ] Testing strategies
  - [ ] Documentation

### Section 4: Path Forward Evaluation

Evaluate three options with effort/risk estimates:

#### Option 1: Direct Adjustment
- Modify existing stories or add new stories within current epic structure
- Maintain project timeline and scope
- **Effort:** [ ] High [ ] Medium [ ] Low
- **Risk:** [ ] High [ ] Medium [ ] Low
- **Feasible?** [ ] Yes [ ] No

#### Option 2: Potential Rollback
- Revert recently completed stories to simplify addressing the issue
- Justify rollback effort with simplification gained
- **Effort:** [ ] High [ ] Medium [ ] Low
- **Risk:** [ ] High [ ] Medium [ ] Low
- **Feasible?** [ ] Yes [ ] No

#### Option 3: MVP Review
- Reduce or redefine MVP scope
- Modify core goals based on new constraints
- Document what's deferred to post-MVP
- **Effort:** [ ] High [ ] Medium [ ] Low
- **Risk:** [ ] High [ ] Medium [ ] Low
- **Feasible?** [ ] Yes [ ] No

#### Recommended Path Selection

- [ ] **4.4** Select recommended path considering:
  - Implementation effort and timeline impact
  - Technical risk and complexity
  - Team morale and momentum
  - Long-term sustainability
  - Stakeholder expectations and business value

**Selected Path:** _______________
**Rationale:** _______________

### Section 5: Sprint Change Proposal Components

- [ ] **5.1** Create issue summary (problem statement, context, evidence)
- [ ] **5.2** Document epic impact and artifact adjustments
- [ ] **5.3** Present recommended path forward with rationale
- [ ] **5.4** Define PRD MVP impact (if any)
- [ ] **5.5** Establish agent handoff plan:
  - [ ] **Minor** → Development team (no PM/SM involvement)
  - [ ] **Moderate** → Backlog reorganization (PO/SM)
  - [ ] **Major** → Strategic replan (PM/Architect)

### Section 6: Final Review

- [ ] **6.1** Review checklist completion (all critical items addressed)
- [ ] **6.2** Verify Sprint Change Proposal accuracy
- [ ] **6.3** Obtain explicit user approval
- [ ] **6.4** Confirm next steps and handoff plan

---

## Step 3: Draft Specific Change Proposals

Create explicit edit proposals for each identified artifact.

### For Story Changes

```markdown
### Story: STORY-XXX

**Current:**
> [Existing acceptance criteria or task]

**Proposed:**
> [New acceptance criteria or task]

**Rationale:** [Why this change is needed]
```

### For PRD Modifications

```markdown
### PRD Section: [Section Name]

**Current:**
> [Existing text]

**Proposed:**
> [Modified text]

**Impact:** [How this affects scope/timeline]
```

### For Architecture Changes

```markdown
### Architecture: [Component/Section]

**Current:**
> [Existing design]

**Proposed:**
> [Modified design]

**Affected Components:** [List of components]
```

**Mode Execution:**
- **Incremental Mode:** Present each proposal, wait for user approval, then continue
- **Batch Mode:** Collect all proposals, present together for review

---

## Step 4: Generate Sprint Change Proposal

Create document at `docs/sprint-change-proposal-{YYYY-MM-DD}.md`:

```markdown
# Sprint Change Proposal

**Date:** {date}
**Triggered By:** {story-id or event}
**Change Category:** {category from Step 1}
**Recommended Path:** {Direct Adjustment | Rollback | MVP Review}
**Change Scope:** {Minor | Moderate | Major}

---

## 1. Issue Summary

### Problem Statement
{Clear description of the issue}

### Context
{How and when this was discovered}

### Evidence
{Supporting data, error logs, feedback}

---

## 2. Impact Analysis

### Epic Impact
| Epic | Impact | Required Changes |
|------|--------|------------------|
| {id} | {High/Medium/Low} | {Description} |

### Story Impact
| Story | Status | Required Changes |
|-------|--------|------------------|
| {id} | {Current status} | {Description} |

### Artifact Conflicts
- **PRD:** {Description of conflicts or "None"}
- **Architecture:** {Description of conflicts or "None"}
- **UI/UX:** {Description of conflicts or "None"}

### Technical Impact
- **Code:** {Changes needed}
- **Infrastructure:** {Changes needed}
- **Testing:** {Changes needed}

---

## 3. Recommended Approach

### Selected Path: {Path Name}

**Rationale:**
{Why this path was chosen}

**Effort Estimate:** {High/Medium/Low}
**Risk Assessment:** {High/Medium/Low}
**Timeline Impact:** {Description}

### Alternatives Considered
- **{Alternative 1}:** {Why not chosen}
- **{Alternative 2}:** {Why not chosen}

---

## 4. Detailed Change Proposals

### Story Changes
{All story change proposals from Step 3}

### PRD Changes
{All PRD change proposals from Step 3}

### Architecture Changes
{All architecture change proposals from Step 3}

### UI/UX Changes
{All UI/UX change proposals from Step 3}

---

## 5. Implementation Handoff

### Change Scope Classification: {Minor | Moderate | Major}

### Handoff Recipients
- **Primary:** {Role/Team}
- **Secondary:** {Role/Team if applicable}

### Immediate Next Steps
1. {Step 1}
2. {Step 2}
3. {Step 3}

### Success Criteria
- [ ] {Criterion 1}
- [ ] {Criterion 2}
- [ ] {Criterion 3}

---

## Approval

- [ ] User approved this proposal on {date}
- [ ] Handoff completed to {recipient}
```

---

## Step 5: Finalize & Route for Implementation

### 5.1 Get User Approval

Present complete Sprint Change Proposal and ask:

> **Please review the Sprint Change Proposal above.**
>
> Do you approve this proposal for implementation?
> - [ ] Yes, proceed with handoff
> - [ ] No, needs modifications (specify what)

### 5.2 Determine Routing

Based on Change Scope:

| Scope | Description | Route To |
|-------|-------------|----------|
| **Minor** | Story-level changes only, no epic/PRD impact | Development team via `/dev-story` |
| **Moderate** | Epic structure or backlog changes needed | Scrum Master via `/sprint-planning` |
| **Major** | PRD/Architecture changes, scope reduction | Product Manager + Architect |

### 5.3 Execute Handoff

**For Minor Changes:**
```
Recommend: Run `/dev-story {story-id}` to implement approved changes
```

**For Moderate Changes:**
```
Recommend: Run `/sprint-planning` to reorganize backlog with approved changes
```

**For Major Changes:**
```
Recommend:
1. Update PRD with approved scope changes
2. Update Architecture document if needed
3. Run `/create-story` for any new epics/stories
4. Run `/sprint-planning` to replan
```

---

## Step 6: Workflow Completion

### Display Summary

```
╔══════════════════════════════════════════════════════════════════╗
║                    COURSE CORRECTION COMPLETE                     ║
╠══════════════════════════════════════════════════════════════════╣
║  Change Trigger:    {story-id or event}                          ║
║  Category:          {category}                                    ║
║  Selected Path:     {Direct Adjustment | Rollback | MVP Review}  ║
║  Change Scope:      {Minor | Moderate | Major}                   ║
║  Handoff To:        {recipient}                                   ║
╠══════════════════════════════════════════════════════════════════╣
║  Deliverables:                                                    ║
║  ✓ Sprint Change Proposal saved                                   ║
║  ✓ Impact analysis completed                                      ║
║  ✓ Change proposals documented                                    ║
║  ✓ Handoff routing determined                                     ║
╠══════════════════════════════════════════════════════════════════╣
║  Next Steps:                                                      ║
║  → {Appropriate next command based on routing}                    ║
╚══════════════════════════════════════════════════════════════════╝
```

---

## Beads Integration (Optional)

If beads is configured (`.beads/` exists):

### On Workflow Start
```bash
# Check for related blocked issues
bd blocked --json
```

### After Proposal Approval
```bash
# Create course correction tracking issue
bd create "[CC] {problem-summary}" -p 1 -l "bmad:course-correct"

# If stories are blocked, update dependencies
bd dep add {blocked-story} blocks {new-prerequisite}

# If stories are deferred, update status
bd update {story-id} --status deferred
```

### Integration with Ready Work
After course correction, `/ready-work` will reflect:
- New unblocked items based on resolved blockers
- Updated priorities from scope changes
- Deferred items removed from ready queue

---

## Notes

- **Halt Early:** If core documents unavailable or trigger unclear, stop and clarify
- **User Collaboration:** This is an interactive workflow - involve user at each decision point
- **Document Everything:** The Sprint Change Proposal is the audit trail for why changes were made
- **Scope Routing:** Minor changes don't need PM involvement; major changes require strategic review
- **Beads Sync:** If using beads, dependency graph updates automatically surface new ready work
