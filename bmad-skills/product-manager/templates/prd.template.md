---
stepsCompleted: []
inputDocuments: []
workflowType: 'prd'
---

# Product Requirements Document - {{PROJECT_NAME}}

**Author:** {{AUTHOR}}
**Date:** {{DATE}}
**Version:** {{VERSION}}
**Status:** {{STATUS}}

---

## Executive Summary

### Vision
{{PRODUCT_VISION}}

### Product Differentiator
{{DIFFERENTIATOR}}

### Target Users
{{TARGET_USERS}}

### Core Problem
{{CORE_PROBLEM}}

### Proposed Solution
{{SOLUTION_OVERVIEW}}

---

## Success Criteria

### Primary Success Metrics
| Metric | Baseline | Target | Measurement Method |
|--------|----------|--------|-------------------|
| {{METRIC_1}} | {{BASELINE_1}} | {{TARGET_1}} | {{METHOD_1}} |
| {{METRIC_2}} | {{BASELINE_2}} | {{TARGET_2}} | {{METHOD_2}} |
| {{METRIC_3}} | {{BASELINE_3}} | {{TARGET_3}} | {{METHOD_3}} |

### Business Outcomes
- {{BUSINESS_OUTCOME_1}}
- {{BUSINESS_OUTCOME_2}}
- {{BUSINESS_OUTCOME_3}}

### User Outcomes
- {{USER_OUTCOME_1}}
- {{USER_OUTCOME_2}}
- {{USER_OUTCOME_3}}

---

## Product Scope

### MVP (Minimum Viable Product)
{{MVP_DESCRIPTION}}

**Included Capabilities:**
- {{MVP_CAPABILITY_1}}
- {{MVP_CAPABILITY_2}}
- {{MVP_CAPABILITY_3}}

**Success Criteria:** {{MVP_SUCCESS}}

### Growth Phase
{{GROWTH_DESCRIPTION}}

**Additional Capabilities:**
- {{GROWTH_CAPABILITY_1}}
- {{GROWTH_CAPABILITY_2}}

### Vision Phase
{{VISION_DESCRIPTION}}

**Future Capabilities:**
- {{VISION_CAPABILITY_1}}
- {{VISION_CAPABILITY_2}}

### Out of Scope
- {{OUT_OF_SCOPE_1}} - {{REASON_1}}
- {{OUT_OF_SCOPE_2}} - {{REASON_2}}
- {{OUT_OF_SCOPE_3}} - {{REASON_3}}

---

## User Journeys

### Journey 1: {{JOURNEY_1_NAME}}

**Actor:** {{JOURNEY_1_ACTOR}}
**Goal:** {{JOURNEY_1_GOAL}}
**Trigger:** {{JOURNEY_1_TRIGGER}}

**Steps:**
1. {{JOURNEY_1_STEP_1}}
2. {{JOURNEY_1_STEP_2}}
3. {{JOURNEY_1_STEP_3}}
4. {{JOURNEY_1_STEP_4}}

**Success Path:** {{JOURNEY_1_SUCCESS}}
**Error Handling:** {{JOURNEY_1_ERRORS}}

### Journey 2: {{JOURNEY_2_NAME}}

**Actor:** {{JOURNEY_2_ACTOR}}
**Goal:** {{JOURNEY_2_GOAL}}
**Trigger:** {{JOURNEY_2_TRIGGER}}

**Steps:**
1. {{JOURNEY_2_STEP_1}}
2. {{JOURNEY_2_STEP_2}}
3. {{JOURNEY_2_STEP_3}}

**Success Path:** {{JOURNEY_2_SUCCESS}}
**Error Handling:** {{JOURNEY_2_ERRORS}}

---

## Domain Requirements

_Include this section if project falls into regulated domains: Healthcare, Fintech, GovTech, E-Commerce, etc._

### Compliance Requirements
| Requirement | Standard | Description | Priority |
|-------------|----------|-------------|----------|
| {{COMPLIANCE_1}} | {{STANDARD_1}} | {{COMPLIANCE_DESC_1}} | MUST |
| {{COMPLIANCE_2}} | {{STANDARD_2}} | {{COMPLIANCE_DESC_2}} | MUST |

### Industry-Specific Capabilities
- {{DOMAIN_CAPABILITY_1}}
- {{DOMAIN_CAPABILITY_2}}

---

## Innovation Analysis

_Include this section for products requiring competitive differentiation analysis._

### Competitive Landscape
| Competitor | Strengths | Weaknesses | Our Advantage |
|------------|-----------|------------|---------------|
| {{COMPETITOR_1}} | {{STRENGTHS_1}} | {{WEAKNESSES_1}} | {{ADVANTAGE_1}} |
| {{COMPETITOR_2}} | {{STRENGTHS_2}} | {{WEAKNESSES_2}} | {{ADVANTAGE_2}} |

### Innovation Opportunities
- {{INNOVATION_1}}
- {{INNOVATION_2}}

---

## Project-Type Requirements

_Platform-specific requirements based on project type (web app, mobile, API, CLI, etc.)._

### Platform: {{PLATFORM_TYPE}}

**Required Capabilities:**
- {{PLATFORM_REQ_1}}
- {{PLATFORM_REQ_2}}
- {{PLATFORM_REQ_3}}

**Technology Constraints:**
- {{TECH_CONSTRAINT_1}}
- {{TECH_CONSTRAINT_2}}

---

## Functional Requirements

_FRs define WHAT capabilities the product must have. Each FR is a testable capability that is implementation-agnostic._

### {{CAPABILITY_AREA_1}}

- FR1: {{ACTOR_1}} can {{CAPABILITY_1}}
- FR2: {{ACTOR_2}} can {{CAPABILITY_2}}
- FR3: {{ACTOR_3}} can {{CAPABILITY_3}}

### {{CAPABILITY_AREA_2}}

- FR4: {{ACTOR_4}} can {{CAPABILITY_4}}
- FR5: {{ACTOR_5}} can {{CAPABILITY_5}}
- FR6: {{ACTOR_6}} can {{CAPABILITY_6}}

### {{CAPABILITY_AREA_3}}

- FR7: {{ACTOR_7}} can {{CAPABILITY_7}}
- FR8: {{ACTOR_8}} can {{CAPABILITY_8}}

_Continue with additional capability areas and FRs as needed. Target 20-50 FRs for typical projects._

---

## Non-Functional Requirements

_NFRs must be measurable. Format: "The system shall [metric] [condition] [measurement method]"_

### Performance

- NFR-PERF-1: {{PERFORMANCE_REQ_1}}
  - Measurement: {{PERF_MEASUREMENT_1}}
- NFR-PERF-2: {{PERFORMANCE_REQ_2}}
  - Measurement: {{PERF_MEASUREMENT_2}}

### Security

- NFR-SEC-1: {{SECURITY_REQ_1}}
  - Measurement: {{SEC_MEASUREMENT_1}}
- NFR-SEC-2: {{SECURITY_REQ_2}}
  - Measurement: {{SEC_MEASUREMENT_2}}

### Scalability

- NFR-SCALE-1: {{SCALABILITY_REQ_1}}
  - Measurement: {{SCALE_MEASUREMENT_1}}

### Reliability

- NFR-REL-1: {{RELIABILITY_REQ_1}}
  - Target SLA: {{REL_SLA_1}}

### Usability

- NFR-USE-1: {{USABILITY_REQ_1}}
  - Accessibility: {{ACCESSIBILITY_STANDARD}}

### Maintainability

- NFR-MAINT-1: {{MAINTAINABILITY_REQ_1}}

---

## Assumptions and Dependencies

### Assumptions
1. {{ASSUMPTION_1}}
2. {{ASSUMPTION_2}}
3. {{ASSUMPTION_3}}

### Dependencies
| Dependency | Type | Owner | Risk Level |
|------------|------|-------|------------|
| {{DEP_1}} | {{TYPE_1}} | {{OWNER_1}} | {{RISK_1}} |
| {{DEP_2}} | {{TYPE_2}} | {{OWNER_2}} | {{RISK_2}} |

---

## Risks and Mitigations

| Risk | Impact | Probability | Mitigation Strategy |
|------|--------|-------------|---------------------|
| {{RISK_1}} | {{IMPACT_1}} | {{PROB_1}} | {{MITIGATION_1}} |
| {{RISK_2}} | {{IMPACT_2}} | {{PROB_2}} | {{MITIGATION_2}} |
| {{RISK_3}} | {{IMPACT_3}} | {{PROB_3}} | {{MITIGATION_3}} |

---

## Traceability

| Requirement | Success Criteria | User Journey | Epic |
|-------------|-----------------|--------------|------|
| FR1 | {{SC_1}} | Journey 1 | EPIC-001 |
| FR2 | {{SC_2}} | Journey 1 | EPIC-001 |
| FR4 | {{SC_3}} | Journey 2 | EPIC-002 |

---

## Glossary

| Term | Definition |
|------|------------|
| {{TERM_1}} | {{DEFINITION_1}} |
| {{TERM_2}} | {{DEFINITION_2}} |

---

## References

- {{REFERENCE_1}}
- {{REFERENCE_2}}

---

**Document End**
