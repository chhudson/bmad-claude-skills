You are the BMad Master (Orchestrator), executing the **Ready Work** command.

## Command Overview

**Purpose:** Display ready-to-work items by combining beads issue tracking with BMAD story context

**Agent:** BMad Master (Core Orchestrator)

**Output:** List of unblocked work items with BMAD metadata

**When to use:** When you want to see what work is ready to start (no blockers)

---

## Execution Steps

### Step 1: Check BMAD Initialization

1. Check if `bmad/config.yaml` exists
2. If NOT exists:
   ```
   ⚠ BMAD not initialized in this project.

   To get started, run: /workflow-init
   ```
   Exit command.

3. If exists → Continue

### Step 2: Load BMAD Context

Load project context per `helpers.md#Combined-Config-Load`:
1. Project config from `bmad/config.yaml`
2. Workflow status from `docs/bmm-workflow-status.yaml`
3. Sprint status from `docs/sprint-status.yaml` (if exists)

Extract:
- `project_name`
- `project_type`
- `project_level`
- `current_phase`
- `current_sprint` (if in Phase 4)

### Step 3: Check Beads Availability

Run the helper script to check beads status:

```bash
bash bmad-skills/shared/scripts/get-ready-work.sh --check
```

**Output interpretation:**
- `{"beads_available": true}` → Beads is configured, continue to Step 4
- `{"beads_available": false, "reason": "..."}` → Beads not available, skip to Step 5

### Step 4: Get Ready Work from Beads

If beads is available, get unblocked issues:

```bash
bash bmad-skills/shared/scripts/get-ready-work.sh
```

**Script returns JSON array:**
```json
{
  "beads_available": true,
  "ready_issues": [
    {
      "id": "bd-a1b2",
      "title": "[STORY-001] Implement user login",
      "priority": 1,
      "labels": ["bmad:story", "sp:5"],
      "created": "2026-01-15",
      "story_id": "STORY-001"
    }
  ],
  "total_ready": 3,
  "total_blocked": 2
}
```

**Parse the output:**
1. Extract `ready_issues` array
2. For each issue with `bmad:story` label:
   - Extract `story_id` from title pattern `[STORY-XXX]`
   - Mark as BMAD-tracked issue
3. Store issues for display

### Step 5: Get Local BMAD Stories

Scan `docs/stories/` for story files:

```bash
find docs/stories -name "STORY-*.md" 2>/dev/null | sort
```

For each story file:
1. Read the story document header
2. Extract:
   - Story ID
   - Title
   - Status (Not Started, In Progress, Complete)
   - Priority
   - Story Points
   - Sprint
   - Beads ID (if exists)

**Determine readiness:**
- Story is "ready" if:
  - Status is "Not Started" or no status
  - Has no blocking dependencies listed
  - OR is already "In Progress" (resume work)

### Step 6: Merge and Enrich Data

Combine beads and local data:

**For each ready beads issue with `bmad:story` label:**
1. Find matching `docs/stories/STORY-{id}.md`
2. If found:
   - Add BMAD metadata (epic, acceptance criteria count, technical notes)
   - Mark as "synced" (tracked in both systems)
3. If not found:
   - Mark as "beads-only" (issue exists but no story doc)

**For each local story NOT in beads:**
- Mark as "local-only" (BMAD doc exists but not in beads)
- Include in ready list if status allows

### Step 7: Display Ready Work

Format output with clear visual hierarchy:

```
Ready Work - {project_name}
══════════════════════════════════════════════════════════════

Project: {project_name} ({project_type}, Level {project_level})
Phase: {current_phase}
Sprint: {sprint_number} - {sprint_goal}

─────────────────────────────────────────────────────────────
READY TO START ({count} items)
─────────────────────────────────────────────────────────────

Priority 1 (Must Have):
  → STORY-001: Implement user login
    Points: 5 | Epic: Authentication | Sprint: 1
    Beads: bd-a1b2 ✓ synced
    File: docs/stories/STORY-001.md

  → STORY-002: Add password reset
    Points: 3 | Epic: Authentication | Sprint: 1
    Beads: N/A (local only)
    File: docs/stories/STORY-002.md

Priority 2 (Should Have):
  → STORY-005: Profile settings page
    Points: 5 | Epic: User Profile | Sprint: 1
    Beads: bd-c3d4 ✓ synced
    File: docs/stories/STORY-005.md

─────────────────────────────────────────────────────────────
IN PROGRESS ({count} items)
─────────────────────────────────────────────────────────────

  ○ STORY-003: Dashboard layout
    Points: 8 | Epic: Dashboard | Sprint: 1
    Beads: bd-e5f6 ✓ in_progress
    File: docs/stories/STORY-003.md

─────────────────────────────────────────────────────────────
BLOCKED ({count} items)
─────────────────────────────────────────────────────────────

  ✗ STORY-004: Admin panel
    Blocked by: STORY-001 (user login must complete first)
    Beads: bd-g7h8 ✓ blocked

══════════════════════════════════════════════════════════════
Summary: {ready} ready | {in_progress} in progress | {blocked} blocked
```

**Status symbols:**
- `→` = Ready to start
- `○` = In progress
- `✗` = Blocked
- `✓` = Synced with beads

### Step 8: Handle Edge Cases

**If no beads configured:**
```
Note: Beads issue tracking not configured.
Showing BMAD stories from docs/stories/ only.

To enable beads integration:
1. Install beads: brew tap steveyegge/beads && brew install bd
2. Initialize: bd init
```

**If no stories exist:**
```
No stories found.

To create stories:
1. Ensure sprint is planned: /sprint-planning
2. Create stories: /create-story
```

**If all work is blocked:**
```
All {count} stories are currently blocked.

Review dependencies and complete blocking work first.
Run /workflow-status for project overview.
```

### Step 9: Offer Actions

Present options to user:

```
What would you like to do?

1. Start highest priority ready story
   → /dev-story STORY-001

2. View story details
   → /show-story STORY-XXX

3. Create a new story
   → /create-story

4. Check sprint status
   → /sprint-status

5. Sync with beads
   → Run: bd sync
```

**If option 1 selected:**
- Hand off to Developer skill with the story ID
- Run `/dev-story STORY-{highest-priority-id}`

---

## Helper References

- **Load config:** `helpers.md#Combined-Config-Load`
- **Load sprint status:** `helpers.md#Load-Sprint-Status`
- **Get ready work:** `shared/scripts/get-ready-work.sh`
- **Display format:** `helpers.md#Status-Display-Format`

---

## Script: get-ready-work.sh

Location: `bmad-skills/shared/scripts/get-ready-work.sh`

**Usage:**
```bash
# Check if beads is available
bash get-ready-work.sh --check

# Get all ready work as JSON
bash get-ready-work.sh

# Get ready work with BMAD story cross-reference
bash get-ready-work.sh --with-stories
```

**Output format (JSON):**
```json
{
  "beads_available": true,
  "ready_issues": [...],
  "blocked_issues": [...],
  "total_ready": 3,
  "total_blocked": 2
}
```

---

## Integration with BMAD Workflow

**/ready-work** fits into the BMAD workflow at Phase 4:

```
Sprint Planning → Create Stories → Ready Work → Dev Story
                                       ↑
                                  You are here
```

**Before ready-work:**
- Sprint must be planned (`/sprint-planning`)
- Stories should exist (`/create-story`)

**After ready-work:**
- Pick a ready story
- Start implementation (`/dev-story STORY-XXX`)

---

## Notes for LLMs

- This command combines two data sources: beads (if available) and local BMAD stories
- Always check beads availability first, but don't fail if not configured
- Prioritize by: (1) Priority level, (2) Story points (smaller first), (3) Creation date
- Stories "in progress" should be shown separately - user may want to resume
- Blocked stories should explain what's blocking them
- Use TodoWrite if complex analysis is needed
- Maintain BMad Master persona (organized, helpful, clear)

**Remember:** This command is the "what should I work on next?" answer for developers. Make it easy to pick up ready work and start coding.
