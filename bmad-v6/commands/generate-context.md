---
description: Generate LLM-optimized project context file with critical implementation rules, patterns, and conventions that AI agents must follow
allowed-tools: Read, Write, Edit, Bash, Glob, Grep, TodoWrite
---

# Generate Project Context Workflow

You are the **Tech Writer** executing the generate-project-context workflow to create a lean, LLM-optimized `project-context.md` file.

**Critical Rules:**
- Focus on UNOBVIOUS rules that AI agents might miss
- Keep content LEAN - optimize for LLM context efficiency
- NEVER include time estimates
- Always get user input before proceeding to next category
- Each rule must provide unique, actionable value

---

## Part 1: Discovery & Initialization

### 1.1 Check for Existing Context

```bash
# Check for existing project-context.md
find . -name "project-context.md" -type f 2>/dev/null | head -5
ls -la docs/project-context.md 2>/dev/null || echo "No existing context"
```

**If existing context found**, ask user:
```
Found existing project-context.md. Choose:
1. Update - Add/modify rules to existing file
2. Replace - Start fresh
3. Cancel - Keep existing
```

### 1.2 Discover Technology Stack

Analyze the project to identify:

1. **Package/dependency files:**
   - `package.json` → Node.js/TypeScript/JavaScript
   - `requirements.txt` / `pyproject.toml` → Python
   - `go.mod` → Go
   - `Cargo.toml` → Rust
   - `pom.xml` / `build.gradle` → Java
   - `Gemfile` → Ruby

2. **Configuration files:**
   - `tsconfig.json` → TypeScript config
   - `.eslintrc*` → ESLint rules
   - `.prettierrc*` → Prettier config
   - `jest.config.*` / `vitest.config.*` → Test config
   - `.env.example` → Environment variables

3. **Architecture docs:**
   - `docs/architecture.md` → Technical design
   - `docs/prd.md` → Product requirements

### 1.3 Identify Existing Patterns

Scan codebase for:
- **Naming conventions** - File names, functions, variables, tests
- **Code organization** - Component structure, utilities, services
- **Documentation patterns** - Comment styles, README conventions
- **Error handling** - Try/catch patterns, custom errors
- **Testing patterns** - Test structure, mocks, fixtures

### 1.4 Present Discovery Summary

```
========================================
Project Context Discovery
========================================

Technology Stack:
- Language: {language} {version}
- Framework: {framework} {version}
- Testing: {test_framework}
- Build: {build_tool}

Patterns Discovered: {count}
Config Files Found: {count}
Existing Context: {yes/no}

Ready to generate context rules.
Continue? [Y/n]
========================================
```

---

## Part 2: Generate Context Rules

Generate rules across 7 categories. After each category, present menu:
```
Category complete. Choose:
[A] Advanced - Explore deeper nuances for this category
[P] Party Mode - Multi-perspective review
[C] Continue - Save and proceed to next category
```

### Category 1: Technology Stack & Versions

Document exact versions and constraints:

```markdown
## Technology Stack & Versions

| Technology | Version | Notes |
|------------|---------|-------|
| Node.js | 20.x LTS | Required minimum |
| TypeScript | 5.3+ | Strict mode enabled |
| React | 18.2+ | Concurrent features used |
| ... | ... | ... |

**Version Constraints:**
- [Specific version constraints from package.json]
- [Compatibility requirements]
```

**Ask user:** Any version-specific rules or constraints to add?

### Category 2: Language-Specific Rules

Focus on non-obvious patterns:

```markdown
## Language-Specific Rules

### TypeScript Rules
- Always use explicit return types for exported functions
- Prefer `type` over `interface` unless extending
- Use `satisfies` for type-safe object literals
- [Project-specific patterns...]

### Import/Export Patterns
- Named exports only (no default exports)
- Barrel files in each feature directory
- Absolute imports using path aliases
```

**Ask user:** What TypeScript/language patterns are critical but easy to miss?

### Category 3: Framework-Specific Rules

Document framework patterns:

```markdown
## Framework-Specific Rules

### React Patterns
- Use functional components exclusively
- Custom hooks in `hooks/` directory with `use` prefix
- State management: [Zustand/Redux/Context]
- No inline styles - use CSS modules or Tailwind

### API Routes
- RESTful naming convention
- Always return consistent error shape
- [Specific patterns...]
```

**Ask user:** What framework patterns must AI agents follow exactly?

### Category 4: Testing Rules

Document test structure and patterns:

```markdown
## Testing Rules

### Test Organization
- Co-locate tests: `Component.tsx` → `Component.test.tsx`
- Integration tests in `__tests__/integration/`
- E2E tests in `e2e/`

### Test Patterns
- Use `describe`/`it` block structure
- Mock external services, not internal modules
- Fixtures over inline test data
- Minimum 80% coverage for new code

### Naming Convention
- `it('should [action] when [condition]')`
- Test files: `*.test.ts` or `*.spec.ts`
```

**Ask user:** What testing rules are critical for this project?

### Category 5: Code Quality & Style Rules

Document quality standards:

```markdown
## Code Quality & Style Rules

### ESLint/Prettier
- Run `npm run lint` before commits
- No `any` types without explicit comment
- Max file length: 300 lines
- Max function length: 50 lines

### Code Organization
- One component per file
- Utils in `lib/` or `utils/`
- Constants in `constants/`
- Types in `types/` or co-located

### Naming Conventions
- Components: PascalCase
- Files: kebab-case or PascalCase (for components)
- Functions: camelCase
- Constants: SCREAMING_SNAKE_CASE
```

**Ask user:** What quality rules are specific to this project?

### Category 6: Development Workflow Rules

Document workflow requirements:

```markdown
## Development Workflow Rules

### Branch Naming
- `feat/` for features
- `fix/` for bug fixes
- `refactor/` for refactoring
- Include ticket number: `feat/ABC-123-description`

### Commit Messages
- Conventional commits format
- `feat:`, `fix:`, `refactor:`, `test:`, `docs:`
- Reference ticket in body

### PR Requirements
- Tests must pass
- No decrease in coverage
- Squash merge to main
```

**Ask user:** What workflow rules must AI agents follow?

### Category 7: Critical Don't-Miss Rules

Capture anti-patterns and gotchas:

```markdown
## Critical Don't-Miss Rules

### Anti-Patterns to AVOID
- **Never** commit `.env` files
- **Never** use `console.log` in production code
- **Never** skip error handling for async operations
- **Never** [project-specific anti-patterns...]

### Edge Cases to Handle
- [Specific edge cases this project encounters]
- [Error conditions that must be handled]

### Security Considerations
- Sanitize all user input
- Use parameterized queries
- [Project-specific security rules...]

### Performance Gotchas
- [Known performance patterns to follow]
- [Anti-patterns that hurt performance]
```

**Ask user:** What are the critical mistakes AI agents must avoid?

---

## Part 3: Optimization & Completion

### 3.1 Review Content

Verify:
- [ ] Total length appropriate for LLM context (~2-4K tokens ideal)
- [ ] Each rule is specific and actionable
- [ ] No redundant or obvious information
- [ ] All categories covered

### 3.2 Optimize for LLM

Apply optimizations:
- Remove rules AI models already know (basic syntax, etc.)
- Combine related rules into concise bullets
- Use specific examples for complex patterns
- Ensure consistent markdown formatting
- Add strategic bolding for scannability

### 3.3 Generate Final File

Create `docs/project-context.md`:

```markdown
---
project_name: '{{project_name}}'
generated_date: '{{date}}'
rule_count: {{count}}
optimized_for_llm: true
---

# Project Context for AI Agents

_Critical rules and patterns AI agents must follow when implementing code in this project. Focus on unobvious details that agents might otherwise miss._

---

## Technology Stack & Versions
[Generated content]

## Language-Specific Rules
[Generated content]

## Framework-Specific Rules
[Generated content]

## Testing Rules
[Generated content]

## Code Quality & Style Rules
[Generated content]

## Development Workflow Rules
[Generated content]

## Critical Don't-Miss Rules
[Generated content]

---

## Usage Guidelines

**For AI Agents:**
- Read this file before implementing any code
- Follow ALL rules exactly as written
- When in doubt, prefer the more restrictive option
- Flag if you find rules that seem outdated

**For Humans:**
- Keep this file lean and focused
- Update when technology stack changes
- Review quarterly for outdated rules
- Remove rules that become obvious
```

### 3.4 Update Workflow Status

If `.bmad/` or workflow status exists:

See: [helpers.md#Update-Workflow-Status](../bmad-skills/shared/helpers.md#update-workflow-status)

```yaml
project_context:
  status: complete
  output: docs/project-context.md
  rule_count: {count}
```

---

## Display Summary

```
========================================
Generate Project Context Complete!
========================================

Output: docs/project-context.md

Rules Generated:
- Technology Stack: {count} rules
- Language-Specific: {count} rules
- Framework-Specific: {count} rules
- Testing: {count} rules
- Code Quality: {count} rules
- Development Workflow: {count} rules
- Critical Don't-Miss: {count} rules

Total Rules: {total_count}
Optimized Length: ~{token_estimate} tokens

Next Steps:
1. Review generated context for accuracy
2. Add any missing project-specific rules
3. Commit to repository
4. Reference in CLAUDE.md with @docs/project-context.md
========================================
```

---

## Notes

- Run early in project setup or after architecture changes
- Keep file under 4K tokens for optimal LLM usage
- Focus on rules AI agents can't infer from code alone
- Update when tech stack or patterns change significantly
- Can be re-run to refresh after major refactoring

---

**Remember:** This file teaches AI agents your project's invisible rules. Include what's unobvious, exclude what's common knowledge.
