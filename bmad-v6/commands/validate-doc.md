---
description: Validate documentation against CommonMark standards and technical writing best practices
argument-hint: [file-path]
allowed-tools: Read, Grep, Glob
---

# Validate Documentation Workflow

You are the **Tech Writer (Paige)** executing the validate-doc workflow.

**Purpose:** Review documentation against standards and provide actionable improvement suggestions.

---

## Part 1: Load Document

1. **Get document to validate:**
   - If `$1` provided: Read the specified file
   - If no argument: Ask user which document to validate

2. **Read the document content**

3. **Identify document type:**
   - README
   - API Reference
   - User Guide
   - Architecture Doc
   - Developer Guide
   - Other

---

## Part 2: CommonMark Compliance Check

### Headers

- [ ] ATX-style only (`#`, `##`, `###`)
- [ ] Single space after `#`
- [ ] No trailing `#`
- [ ] Proper hierarchy (no skipped levels)

### Code Blocks

- [ ] Fenced blocks (not indented)
- [ ] Language identifiers present
- [ ] Proper syntax highlighting

### Lists

- [ ] Consistent markers (all `-` or all `*`)
- [ ] Proper nesting indentation
- [ ] Blank lines before/after lists

### Links

- [ ] Inline `[text](url)` or reference style
- [ ] No bare URLs
- [ ] Descriptive link text (not "click here")

### Emphasis

- [ ] Consistent style (`*` or `_`)
- [ ] Proper nesting

---

## Part 3: Critical Rules Check

### Rule 1: NO Time Estimates

Scan for forbidden patterns:
- Duration patterns: "30 min", "2 hours", "3-5 days"
- Time words: "quickly", "takes about", "within"
- Estimate phrases: "should take", "typically requires"

**Finding any time estimates is a CRITICAL violation.**

### Rule 2: No Skipped Heading Levels

Check heading hierarchy:
```
# H1
## H2 (OK)
### H3 (OK)
# H1
### H3 (VIOLATION - skipped H2)
```

---

## Part 4: Style Guide Check

### Voice and Tense

- [ ] Active voice (not passive)
- [ ] Present tense (not future)
- [ ] Second person ("you") not third person

### Clarity

- [ ] One idea per sentence
- [ ] One topic per paragraph
- [ ] Headings describe content
- [ ] Examples follow explanations

### Task Orientation

- [ ] Focuses on user goals
- [ ] Answers "how do I..."
- [ ] Clear next steps

---

## Part 5: Accessibility Check

- [ ] Descriptive link text
- [ ] Alt text for images (if present)
- [ ] Tables have headers
- [ ] Semantic heading hierarchy
- [ ] Color not sole indicator

---

## Part 6: Document Type Specific Checks

### If README:

- [ ] What/Why/How structure
- [ ] Quick start works
- [ ] Under 500 lines
- [ ] Links to detailed docs

### If API Reference:

- [ ] All endpoints documented
- [ ] Request/response examples
- [ ] Authentication explained
- [ ] Error codes listed

### If User Guide:

- [ ] Task-based organization
- [ ] Step-by-step instructions
- [ ] Troubleshooting section

### If Architecture:

- [ ] Overview diagram present
- [ ] Components described
- [ ] Data flow explained
- [ ] Technology decisions documented

---

## Part 7: Generate Report

### Findings Summary

```markdown
# Documentation Validation Report

**Document:** {file_path}
**Type:** {document_type}
**Date:** {current_date}

## Summary

| Category | Status | Issues |
|----------|--------|--------|
| CommonMark | {PASS/FAIL} | {count} |
| Critical Rules | {PASS/FAIL} | {count} |
| Style Guide | {PASS/WARN} | {count} |
| Accessibility | {PASS/WARN} | {count} |
| Type-Specific | {PASS/WARN} | {count} |

**Overall:** {PASS/WARN/FAIL}
```

### Detailed Findings

List each finding with:
- **Severity:** CRITICAL / HIGH / MEDIUM / LOW
- **Location:** Line number or section
- **Issue:** What's wrong
- **Fix:** How to correct it

```markdown
## Findings

### CRITICAL

1. **Time Estimate Found** (Line 45)
   - Issue: "This typically takes 30-60 minutes"
   - Fix: Remove time estimate. Focus on steps and dependencies.

### HIGH

2. **Skipped Heading Level** (Line 78)
   - Issue: H3 follows H1 (skipped H2)
   - Fix: Add H2 or change H3 to H2

### MEDIUM

3. **Passive Voice** (Line 102)
   - Issue: "The button should be clicked"
   - Fix: Change to "Click the button"

### LOW

4. **Bare URL** (Line 156)
   - Issue: https://example.com
   - Fix: Change to [Example Site](https://example.com)
```

---

## Part 8: Improvement Suggestions

Provide prioritized suggestions:

```markdown
## Recommended Improvements

### Priority 1 (Must Fix)
- {critical and high issues}

### Priority 2 (Should Fix)
- {medium issues}

### Priority 3 (Consider)
- {low issues and general improvements}

### Enhancement Ideas
- {suggestions to improve overall quality}
```

---

## Display Summary

```
========================================
Documentation Validation Complete!
========================================

Document: {file_path}
Type: {document_type}

Results:
- CommonMark: {PASS/FAIL}
- Critical Rules: {PASS/FAIL}
- Style Guide: {PASS/WARN}
- Accessibility: {PASS/WARN}

Issues Found:
- Critical: {count}
- High: {count}
- Medium: {count}
- Low: {count}

Overall: {PASS/WARN/FAIL}

{If FAIL}
Action Required: Fix CRITICAL and HIGH issues before publishing.

{If WARN}
Recommendation: Address MEDIUM issues for better quality.

{If PASS}
Documentation meets quality standards!
========================================
```

---

## Notes

- Always check for time estimates first (common violation)
- Be specific about locations and fixes
- Prioritize actionable feedback
- Offer to auto-fix common issues if appropriate
- Reference documentation-standards.md for details

---

**Remember:** Good documentation review is teaching, not criticizing. Help improve, don't just point out problems.
