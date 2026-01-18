# Epic {{epic_number}} Retrospective

**Epic:** {{epic_name}}
**Date:** {{retrospective_date}}
**Sprint(s):** {{sprint_numbers}}
**Facilitator:** Scrum Master (AI-Assisted)

---

## Epic Summary

| Metric | Value |
|--------|-------|
| Stories Completed | {{stories_completed}} / {{stories_total}} |
| Story Points Delivered | {{points_delivered}} / {{points_planned}} |
| Duration | {{start_date}} - {{end_date}} |
| Velocity | {{velocity}} points/sprint |

### Stories in This Epic

| Story | Title | Points | Status |
|-------|-------|--------|--------|
| {{story_id}} | {{story_title}} | {{story_points}} | {{story_status}} |

---

## What Went Well

### Successes

{{#each successes}}
- **{{title}}**: {{description}}
{{/each}}

### Practices to Continue

{{#each good_practices}}
- {{practice}}
{{/each}}

### Team Wins

{{#each team_wins}}
- {{win}}
{{/each}}

---

## What Didn't Go Well

### Challenges Encountered

{{#each challenges}}
- **{{title}}**: {{description}}
  - Impact: {{impact}}
  - Root cause: {{root_cause}}
{{/each}}

### Blockers and Delays

{{#each blockers}}
- {{blocker}}
  - Duration: {{duration}}
  - Resolution: {{resolution}}
{{/each}}

### Patterns from Code Reviews

{{#each review_patterns}}
- {{pattern}} (occurred in {{count}} stories)
{{/each}}

---

## Previous Retrospective Follow-Through

**Previous Retrospective:** Epic {{previous_epic}} ({{previous_retro_date}})

### Action Item Status

| Action Item | Status | Notes |
|-------------|--------|-------|
| {{action_item}} | {{status_emoji}} {{status}} | {{notes}} |

**Legend:** ✅ Completed | ⏳ In Progress | ❌ Not Addressed

### Continuity Analysis

**Lessons Applied:**
{{#each lessons_applied}}
- {{lesson}}
{{/each}}

**Missed Opportunities:**
{{#each missed_opportunities}}
- {{opportunity}}
{{/each}}

---

## Discoveries and Learnings

### Technical Learnings

{{#each technical_learnings}}
- **{{topic}}**: {{learning}}
{{/each}}

### Process Learnings

{{#each process_learnings}}
- **{{area}}**: {{learning}}
{{/each}}

### Estimation Accuracy

| Category | Estimated | Actual | Variance |
|----------|-----------|--------|----------|
| {{category}} | {{estimated}} | {{actual}} | {{variance}}% |

**Estimation Insights:**
{{estimation_insights}}

---

## Significant Changes Detected

{{#if significant_changes}}
**⚠️ Review Required Before Starting Next Epic**

{{#each significant_changes}}
### {{change_type}}

**Description:** {{description}}

**Impact:** {{impact}}

**Recommended Action:** {{action}}

**Documents to Update:** {{documents}}
{{/each}}
{{else}}
No significant changes requiring epic updates.
{{/if}}

---

## Action Items

### Process Improvements

{{#each process_improvements}}
- [ ] {{description}}
  - Owner: {{owner}}
  - Target: {{target}}
  - Success criteria: {{criteria}}
{{/each}}

### Technical Debt

{{#each technical_debt}}
- [ ] {{description}}
  - Priority: {{priority}}
  - Estimated effort: {{effort}}
  - Impact if not addressed: {{impact}}
{{/each}}

### Documentation Updates

{{#each documentation_updates}}
- [ ] {{description}}
  - Document: {{document}}
  - Owner: {{owner}}
{{/each}}

### Team Development

{{#each team_development}}
- [ ] {{description}}
  - Type: {{type}}
  - Participants: {{participants}}
{{/each}}

---

## Next Epic Preparation

**Next Epic:** {{next_epic_number}} - {{next_epic_name}}

### Dependencies on Current Epic

{{#each dependencies}}
- {{dependency}}
{{/each}}

### Preparation Required

{{#each preparation}}
- [ ] {{item}}
  - Why: {{reason}}
  - Owner: {{owner}}
{{/each}}

### Knowledge Gaps to Address

{{#each knowledge_gaps}}
- {{gap}}
{{/each}}

### Technical Setup Needed

{{#each technical_setup}}
- {{setup}}
{{/each}}

---

## Team Recognition

### Individual Contributions

{{#each recognitions}}
- **{{contributor}}**: {{contribution}}
{{/each}}

### Collaboration Highlights

{{#each collaboration_highlights}}
- {{highlight}}
{{/each}}

---

## Retrospective Metrics

| Metric | This Epic | Previous Epic | Trend |
|--------|-----------|---------------|-------|
| Stories Completed | {{stories_this}} | {{stories_prev}} | {{stories_trend}} |
| Points Delivered | {{points_this}} | {{points_prev}} | {{points_trend}} |
| Review Issues/Story | {{review_this}} | {{review_prev}} | {{review_trend}} |
| Technical Debt Items | {{debt_this}} | {{debt_prev}} | {{debt_trend}} |

---

## Closing Notes

{{closing_notes}}

---

**Next Steps:**
{{#each next_steps}}
1. {{step}}
{{/each}}

---

*Retrospective generated on {{retrospective_date}} by BMAD Scrum Master*
