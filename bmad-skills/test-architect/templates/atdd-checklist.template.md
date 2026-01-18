# ATDD Checklist

**Story:** {{story_id}}
**Title:** {{story_title}}
**Date:** {{date}}
**Status:** {{status}}

---

## Acceptance Criteria

{{#acceptance_criteria}}
- [ ] {{criterion}}
{{/acceptance_criteria}}

## Test Scenarios

### Scenario 1: {{scenario_1_name}}

**Given:** {{scenario_1_given}}
**When:** {{scenario_1_when}}
**Then:** {{scenario_1_then}}

**Test Status:** ⬜ Not Started | 🔴 Red | 🟢 Green

**Test Location:** `{{scenario_1_test_path}}`

---

### Scenario 2: {{scenario_2_name}}

**Given:** {{scenario_2_given}}
**When:** {{scenario_2_when}}
**Then:** {{scenario_2_then}}

**Test Status:** ⬜ Not Started | 🔴 Red | 🟢 Green

**Test Location:** `{{scenario_2_test_path}}`

---

### Error Scenarios

| Scenario | Expected Error | Test Status |
|----------|----------------|-------------|
| {{error_scenario_1}} | {{error_1}} | ⬜ |
| {{error_scenario_2}} | {{error_2}} | ⬜ |

## Test Data Requirements

| Data | Type | Setup Method |
|------|------|--------------|
| {{data_1}} | {{type_1}} | Factory / Fixture |
| {{data_2}} | {{type_2}} | Factory / Fixture |

## API Endpoints to Test

| Method | Endpoint | Scenarios |
|--------|----------|-----------|
| {{method_1}} | {{endpoint_1}} | Happy path, validation errors |
| {{method_2}} | {{endpoint_2}} | Auth required, not found |

## Test Levels

| Level | Required | Test Files |
|-------|----------|------------|
| Unit | {{unit_required}} | |
| Integration | {{integration_required}} | |
| API | {{api_required}} | |
| E2E | {{e2e_required}} | |

## Implementation Progress

### Red Phase (Write Failing Tests)

- [ ] Write acceptance test for scenario 1
- [ ] Write acceptance test for scenario 2
- [ ] Write error scenario tests
- [ ] Verify all tests fail as expected

### Green Phase (Make Tests Pass)

- [ ] Implement minimal code for scenario 1
- [ ] Implement minimal code for scenario 2
- [ ] Implement error handling
- [ ] All acceptance tests pass

### Refactor Phase

- [ ] Clean up implementation
- [ ] Add edge case tests
- [ ] Verify coverage meets target
- [ ] Update documentation

## Coverage Summary

| Metric | Target | Actual | Status |
|--------|--------|--------|--------|
| Acceptance Criteria | 100% | {{ac_coverage}}% | |
| Line Coverage | 80% | {{line_coverage}}% | |
| Branch Coverage | 80% | {{branch_coverage}}% | |

## Notes

{{notes}}

---

## Sign-off

- [ ] All acceptance criteria have tests
- [ ] All tests are passing
- [ ] Coverage meets requirements
- [ ] No known flaky tests
- [ ] Ready for code review

**Completed Date:** {{completed_date}}
