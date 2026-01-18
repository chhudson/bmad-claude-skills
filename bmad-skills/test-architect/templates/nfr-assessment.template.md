# Non-Functional Requirements Assessment

**Project:** {{project_name}}
**Date:** {{date}}
**Assessment Scope:** {{scope}}
**Overall Status:** {{overall_status}}

---

## Executive Summary

| Category | Status | Score | Notes |
|----------|--------|-------|-------|
| Security | {{security_status}} | {{security_score}}/10 | {{security_notes}} |
| Performance | {{performance_status}} | {{performance_score}}/10 | {{performance_notes}} |
| Reliability | {{reliability_status}} | {{reliability_score}}/10 | {{reliability_notes}} |
| Maintainability | {{maintainability_status}} | {{maintainability_score}}/10 | {{maintainability_notes}} |

**Release Recommendation:** {{recommendation}}

---

## Security Assessment

### Authentication & Authorization

| Requirement | Evidence | Status |
|-------------|----------|--------|
| Secure password storage | bcrypt/argon2 hashing verified | {{auth_password}} |
| Token validation | JWT verification tests pass | {{auth_token}} |
| Session management | Session timeout/invalidation tested | {{auth_session}} |
| RBAC enforcement | Permission tests for all roles | {{auth_rbac}} |

### Input Validation

| Requirement | Evidence | Status |
|-------------|----------|--------|
| SQL injection prevention | Parameterized queries verified | {{input_sql}} |
| XSS prevention | Output encoding verified | {{input_xss}} |
| CSRF protection | Token validation tested | {{input_csrf}} |
| File upload validation | Type/size checks verified | {{input_file}} |

### Dependency Security

```
npm audit results:
- Critical: {{audit_critical}}
- High: {{audit_high}}
- Moderate: {{audit_moderate}}
- Low: {{audit_low}}

Status: {{audit_status}}
```

### Security Test Coverage

| Test Type | Count | Status |
|-----------|-------|--------|
| Authentication tests | {{auth_test_count}} | {{auth_test_status}} |
| Authorization tests | {{authz_test_count}} | {{authz_test_status}} |
| Injection tests | {{injection_test_count}} | {{injection_test_status}} |
| Security scan findings | {{scan_findings}} | {{scan_status}} |

---

## Performance Assessment

### Response Time

| Endpoint | Target | P50 | P95 | P99 | Status |
|----------|--------|-----|-----|-----|--------|
{{#endpoints}}
| {{name}} | {{target}}ms | {{p50}}ms | {{p95}}ms | {{p99}}ms | {{status}} |
{{/endpoints}}

### Throughput

| Metric | Target | Actual | Status |
|--------|--------|--------|--------|
| Requests/second | {{rps_target}} | {{rps_actual}} | {{rps_status}} |
| Concurrent users | {{users_target}} | {{users_actual}} | {{users_status}} |
| Error rate under load | <1% | {{error_rate}}% | {{error_status}} |

### Resource Utilization

| Resource | Baseline | Under Load | Limit | Status |
|----------|----------|------------|-------|--------|
| CPU | {{cpu_baseline}}% | {{cpu_load}}% | 80% | {{cpu_status}} |
| Memory | {{mem_baseline}}MB | {{mem_load}}MB | {{mem_limit}}MB | {{mem_status}} |
| Database connections | {{db_baseline}} | {{db_load}} | {{db_limit}} | {{db_status}} |

### Database Performance

| Metric | Target | Actual | Status |
|--------|--------|--------|--------|
| N+1 queries | 0 | {{n_plus_one}} | {{n_plus_one_status}} |
| Slow queries (>100ms) | 0 | {{slow_queries}} | {{slow_status}} |
| Index coverage | 100% | {{index_coverage}}% | {{index_status}} |

---

## Reliability Assessment

### Error Handling

| Scenario | Test Coverage | Status |
|----------|---------------|--------|
| Network failures | {{net_fail_tests}} tests | {{net_fail_status}} |
| Database failures | {{db_fail_tests}} tests | {{db_fail_status}} |
| External service failures | {{ext_fail_tests}} tests | {{ext_fail_status}} |
| Invalid input | {{input_fail_tests}} tests | {{input_fail_status}} |

### Resilience Patterns

| Pattern | Implemented | Tested | Status |
|---------|-------------|--------|--------|
| Circuit breaker | {{circuit_impl}} | {{circuit_test}} | {{circuit_status}} |
| Retry with backoff | {{retry_impl}} | {{retry_test}} | {{retry_status}} |
| Timeout handling | {{timeout_impl}} | {{timeout_test}} | {{timeout_status}} |
| Graceful degradation | {{degrade_impl}} | {{degrade_test}} | {{degrade_status}} |

### Recovery Testing

| Scenario | Recovery Time | Data Integrity | Status |
|----------|---------------|----------------|--------|
| Application restart | {{app_restart}}s | {{app_integrity}} | {{app_status}} |
| Database failover | {{db_failover}}s | {{db_integrity}} | {{db_status}} |
| Cache failure | {{cache_fail}}s | {{cache_integrity}} | {{cache_status}} |

---

## Maintainability Assessment

### Code Quality

| Metric | Target | Actual | Status |
|--------|--------|--------|--------|
| Test coverage | 80% | {{test_coverage}}% | {{coverage_status}} |
| Cyclomatic complexity | <10 | {{complexity_avg}} | {{complexity_status}} |
| Code duplication | <5% | {{duplication}}% | {{duplication_status}} |
| Technical debt ratio | <5% | {{tech_debt}}% | {{debt_status}} |

### Documentation

| Document | Status | Last Updated |
|----------|--------|--------------|
| API documentation | {{api_docs}} | {{api_docs_date}} |
| Architecture docs | {{arch_docs}} | {{arch_docs_date}} |
| Deployment guide | {{deploy_docs}} | {{deploy_docs_date}} |
| Runbook | {{runbook}} | {{runbook_date}} |

### Test Quality

| Metric | Target | Actual | Status |
|--------|--------|--------|--------|
| Flaky tests | 0 | {{flaky_tests}} | {{flaky_status}} |
| Test execution time | <{{test_time_target}}min | {{test_time}}min | {{test_time_status}} |
| Test maintainability | High | {{test_maintainability}} | {{test_maint_status}} |

---

## Findings Summary

### Critical Issues (Must Fix)

{{#critical_issues}}
1. **{{title}}**
   - Category: {{category}}
   - Impact: {{impact}}
   - Recommendation: {{recommendation}}
{{/critical_issues}}

### High Priority Issues

{{#high_issues}}
1. **{{title}}**
   - Category: {{category}}
   - Impact: {{impact}}
   - Recommendation: {{recommendation}}
{{/high_issues}}

### Recommendations

{{#recommendations}}
- {{recommendation}}
{{/recommendations}}

---

## Release Readiness

### Checklist

- [{{security_check}}] Security requirements met
- [{{performance_check}}] Performance requirements met
- [{{reliability_check}}] Reliability requirements met
- [{{maintainability_check}}] Maintainability requirements met
- [{{documentation_check}}] Documentation complete
- [{{testing_check}}] All tests passing

### Decision

**{{recommendation}}**

{{recommendation_rationale}}

---

*Generated by Test Architect skill on {{date}}*
