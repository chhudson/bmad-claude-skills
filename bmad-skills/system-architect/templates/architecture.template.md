# Architecture Decision Document: {{project_name}}

---
stepsCompleted: []
inputDocuments: []
workflowType: 'architecture'
project_name: '{{project_name}}'
date: '{{date}}'
status: 'Draft'
---

_This document builds collaboratively through architectural discovery. Each section captures decisions that ensure consistent implementation by AI agents._

---

## 1. Project Context Analysis

### Requirements Overview

**Input Documents:**
- PRD: `{{prd_path}}`
- UX Design: `{{ux_design_path}}`
- Product Brief: `{{product_brief_path}}`

**Functional Requirements Summary:**
{{fr_analysis_summary}}

**Non-Functional Requirements:**
| NFR-ID | Category | Requirement | Architectural Impact |
|--------|----------|-------------|---------------------|
| {{nfr_id}} | {{category}} | {{requirement}} | {{impact}} |

**Scale & Complexity:**
- Project Level: {{project_level}}
- Primary Domain: {{technical_domain}}
- Complexity Assessment: {{complexity_level}}
- Estimated Components: {{component_count}}

### Technical Constraints & Dependencies

{{known_constraints_dependencies}}

### Cross-Cutting Concerns

{{concerns_that_affect_multiple_components}}

---

## 2. Technology Foundation

### Starter Template Selection

**Selected Approach:** {{starter_template_or_custom}}

**Technology Domain:** {{primary_technology_domain}}

**Initialization Command:**
```bash
{{initialization_command}}
```

**Decisions Made by Starter:**
- {{starter_decision_1}}
- {{starter_decision_2}}
- {{starter_decision_3}}

**Rationale:**
{{starter_selection_rationale}}

### Technology Stack

| Layer | Technology | Version | Rationale |
|-------|------------|---------|-----------|
| Frontend | {{frontend_framework}} | {{version}} | {{rationale}} |
| Backend | {{backend_framework}} | {{version}} | {{rationale}} |
| Database | {{database}} | {{version}} | {{rationale}} |
| Cache | {{cache}} | {{version}} | {{rationale}} |
| Auth | {{auth_provider}} | {{version}} | {{rationale}} |
| Infrastructure | {{cloud_provider}} | - | {{rationale}} |

---

## 3. Core Architectural Decisions

### Architecture Pattern

**Selected Pattern:** {{pattern_name}}

**Pattern Application:**
{{how_pattern_is_applied}}

**Alternatives Considered:**
| Alternative | Rejected Because |
|-------------|-----------------|
| {{alternative_1}} | {{rejection_reason}} |
| {{alternative_2}} | {{rejection_reason}} |

### Data Architecture

**Primary Database:** {{database_type}}
- Data Modeling: {{modeling_approach}}
- Migration Strategy: {{migration_approach}}
- Caching Strategy: {{caching_approach}}

**Entity Relationship Diagram:**
```
{{erd_ascii_diagram}}
```

**Key Entities:**
| Entity | Purpose | Key Attributes |
|--------|---------|----------------|
| {{entity_name}} | {{purpose}} | {{attributes}} |

### Authentication & Security

**Authentication Method:** {{auth_method}}
**Authorization Model:** {{authz_model}}
**Security Considerations:**
- {{security_item_1}}
- {{security_item_2}}
- {{security_item_3}}

### API & Communication

**API Style:** {{api_style}}
**Versioning Strategy:** {{versioning_strategy}}

**Endpoint Groups:**
| Group | Base Path | Purpose |
|-------|-----------|---------|
| {{group_name}} | `/api/v1/{{path}}` | {{purpose}} |

**Error Response Format:**
```json
{
  "error": {
    "code": "{{ERROR_CODE}}",
    "message": "{{Human readable message}}",
    "details": {}
  }
}
```

### Infrastructure & Deployment

**Deployment Strategy:** {{deployment_strategy}}
**Environment Configuration:**
- Development: {{dev_config}}
- Staging: {{staging_config}}
- Production: {{prod_config}}

**Deployment Architecture:**
```
{{deployment_ascii_diagram}}
```

---

## 4. Implementation Patterns & Consistency Rules

_These rules ensure AI agents implement consistently across the codebase._

### Naming Conventions

| Category | Pattern | Example |
|----------|---------|---------|
| Files (components) | {{file_pattern}} | `{{example}}` |
| Files (utilities) | {{util_pattern}} | `{{example}}` |
| Database tables | {{table_pattern}} | `{{example}}` |
| API endpoints | {{endpoint_pattern}} | `{{example}}` |
| Environment vars | {{env_pattern}} | `{{example}}` |

### Structural Patterns

**Component Structure:**
```
{{component_structure_template}}
```

**Service Structure:**
```
{{service_structure_template}}
```

**Test Location Rules:**
- Unit tests: `{{unit_test_location}}`
- Integration tests: `{{integration_test_location}}`
- E2E tests: `{{e2e_test_location}}`

### Code Quality Rules

**Required Patterns:**
- {{required_pattern_1}}
- {{required_pattern_2}}
- {{required_pattern_3}}

**Forbidden Patterns:**
- {{forbidden_pattern_1}}
- {{forbidden_pattern_2}}

**Error Handling Standard:**
```{{language}}
{{error_handling_example}}
```

### Communication Patterns

**Internal Service Communication:**
{{internal_communication_pattern}}

**Event Naming Convention:**
{{event_naming_pattern}}

**State Management Rules:**
{{state_management_rules}}

---

## 5. Project Structure & Boundaries

### Complete Directory Structure

```
{{project_name}}/
├── README.md
├── {{package_file}}
├── {{config_files}}
├── .env.example
├── .gitignore
├── .github/
│   └── workflows/
│       └── ci.yml
├── src/
│   ├── {{entry_point}}
│   ├── {{app_structure}}
│   ├── components/
│   │   ├── ui/
│   │   ├── forms/
│   │   └── features/
│   ├── lib/
│   │   ├── db.{{ext}}
│   │   ├── auth.{{ext}}
│   │   └── utils.{{ext}}
│   ├── types/
│   └── middleware/
├── {{database_dir}}/
│   ├── schema.{{ext}}
│   └── migrations/
├── tests/
│   ├── __mocks__/
│   ├── unit/
│   ├── integration/
│   └── e2e/
├── docs/
│   └── api/
└── public/
    └── assets/
```

### Architectural Boundaries

**API Boundaries:**
| Boundary | Internal Services | External Consumers |
|----------|-------------------|-------------------|
| {{boundary_name}} | {{internal}} | {{external}} |

**Component Boundaries:**
{{component_boundary_rules}}

**Data Access Boundaries:**
{{data_access_rules}}

### Requirements to Structure Mapping

**Epic/Feature Mapping:**
| Epic/Feature | Components | Services | Database | Tests |
|--------------|------------|----------|----------|-------|
| {{epic_name}} | `{{components_path}}` | `{{services_path}}` | `{{db_path}}` | `{{tests_path}}` |

**Cross-Cutting Concerns:**
| Concern | Implementation Location |
|---------|------------------------|
| Authentication | `{{auth_location}}` |
| Logging | `{{logging_location}}` |
| Error Handling | `{{error_location}}` |
| Validation | `{{validation_location}}` |

---

## 6. Architecture Validation

### Coherence Checks

| Check | Status | Notes |
|-------|--------|-------|
| Technology choices align | {{status}} | {{notes}} |
| Patterns support NFRs | {{status}} | {{notes}} |
| Structure matches decisions | {{status}} | {{notes}} |
| Security requirements met | {{status}} | {{notes}} |
| Scalability path defined | {{status}} | {{notes}} |

### Requirements Coverage

**FR Coverage:**
| FR-ID | Covered By | Status |
|-------|------------|--------|
| {{fr_id}} | {{component}} | {{status}} |

**NFR Coverage:**
| NFR-ID | Architectural Decision | Validation Method |
|--------|----------------------|------------------|
| {{nfr_id}} | {{decision}} | {{validation}} |

### Identified Risks

| Risk | Impact | Probability | Mitigation |
|------|--------|-------------|------------|
| {{risk}} | {{impact}} | {{probability}} | {{mitigation}} |

### Trade-off Analysis

**Trade-off: {{trade_off_name}}**
- **Decision:** {{what_was_decided}}
- **Benefit:** {{what_we_gain}}
- **Cost:** {{what_we_give_up}}
- **Mitigation:** {{how_we_minimize_cost}}
- **Revisit When:** {{conditions_to_reconsider}}

---

## 7. Future Considerations

### Scalability Path

**Current Capacity:** {{current_capacity}}

**Scale to {{next_tier}}:**
- {{scaling_step_1}}
- {{scaling_step_2}}
- {{scaling_step_3}}

**Scale to {{future_tier}}:**
- {{future_scaling_step_1}}
- {{future_scaling_step_2}}

### Technology Evolution

**Anticipated Updates:**
- {{technology_1}}: {{upgrade_path}}
- {{technology_2}}: {{upgrade_path}}

**Migration Paths:**
- {{migration_scenario}}: {{approach}}

---

## Appendix

### Glossary

| Term | Definition |
|------|------------|
| {{term}} | {{definition}} |

### References

- PRD: `docs/prd-{{project_name}}-{{date}}.md`
- UX Design: `docs/ux-design-{{project_name}}.md`
- API Documentation: `docs/api/`

### Beads Integration

**Architecture Molecule ID:** {{beads_architecture_id}}
**Status:** {{beads_status}}

#### Component Dependency Map

| Component | Beads ID | Depends On | NFRs |
|-----------|----------|------------|------|
| {{component_name}} | {{bd_id}} | {{dependencies}} | {{nfr_ids}} |

#### Implementation Order

Based on dependencies, `bd ready` will show components in this order:
1. {{tier_1_components}} - No dependencies, can start immediately
2. {{tier_2_components}} - Depends on tier 1
3. {{tier_3_components}} - Depends on tier 2

**Note:** Run `bd ready` to see which components are unblocked for implementation.

---

### Document History

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | {{date}} | System Architect | Initial architecture document |

---

**END OF DOCUMENT**
