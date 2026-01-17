# BMAD Subprocess Architecture Patterns

This document defines standard patterns for leveraging parallel subprocesses across BMAD skills. Each subprocess gets its own 200K token context window, enabling massive parallelization of complex workflows.

## Core Principle

**Never do sequentially what can be done in parallel.** Each BMAD skill should decompose its work into independent subtasks that can be executed by parallel subprocesses, then synthesize results.

## Subprocess Types

BMAD skills use these subprocess patterns via the `Task` tool:

| subagent_type | Purpose | Best For |
|---------------|---------|----------|
| `general-purpose` | Complex multi-step tasks | Research, implementation, analysis |
| `Explore` | Codebase exploration | Finding files, understanding structure |
| `Plan` | Architecture planning | Design decisions, implementation plans |

## Standard Subprocess Invocation

```markdown
Use the Task tool to spawn a subprocess:
- subagent_type: "general-purpose" (or "Explore", "Plan")
- run_in_background: true (for parallel execution)
- prompt: Detailed, self-contained task description
```

## Parallel Execution Patterns

### Pattern 1: Fan-Out Research

When gathering information from multiple sources:

```
┌─────────────────┐
│  Main Context   │
└────────┬────────┘
         │ Launch parallel agents
    ┌────┴────┬────────┬────────┐
    ▼         ▼        ▼        ▼
┌───────┐ ┌───────┐ ┌───────┐ ┌───────┐
│Agent 1│ │Agent 2│ │Agent 3│ │Agent 4│
│Market │ │Compet.│ │Tech   │ │User   │
│Research│ │Analysis│ │Research│ │Research│
└───┬───┘ └───┬───┘ └───┬───┘ └───┬───┘
    │         │        │        │
    └────┬────┴────────┴────────┘
         ▼
┌─────────────────┐
│  Synthesize     │
│  Results        │
└─────────────────┘
```

**Example:** Business Analyst researching a product:
- Agent 1: Market size and trends
- Agent 2: Competitive landscape
- Agent 3: Technical feasibility
- Agent 4: User needs analysis

### Pattern 2: Parallel Section Generation

When creating multi-section documents:

```
┌─────────────────┐
│  Gather Context │
│  (shared info)  │
└────────┬────────┘
         │ Launch parallel agents with shared context
    ┌────┴────┬────────┬────────┐
    ▼         ▼        ▼        ▼
┌───────┐ ┌───────┐ ┌───────┐ ┌───────┐
│Section│ │Section│ │Section│ │Section│
│   1   │ │   2   │ │   3   │ │   4   │
└───┬───┘ └───┬───┘ └───┬───┘ └───┬───┘
    │         │        │        │
    └────┬────┴────────┴────────┘
         ▼
┌─────────────────┐
│  Assemble Doc   │
└─────────────────┘
```

**Example:** Product Manager creating PRD:
- Agent 1: Functional Requirements section
- Agent 2: Non-Functional Requirements section
- Agent 3: Epics and User Stories
- Agent 4: Dependencies and Constraints

### Pattern 3: Component Parallel Design

When designing system components:

```
┌─────────────────┐
│  Load PRD/NFRs  │
│  Define Scope   │
└────────┬────────┘
         │ Each agent designs one component
    ┌────┴────┬────────┬────────┐
    ▼         ▼        ▼        ▼
┌───────┐ ┌───────┐ ┌───────┐ ┌───────┐
│ Auth  │ │ Data  │ │  API  │ │  UI   │
│Service│ │ Layer │ │ Layer │ │ Layer │
└───┬───┘ └───┬───┘ └───┬───┘ └───┬───┘
    │         │        │        │
    └────┬────┴────────┴────────┘
         ▼
┌─────────────────┐
│ Integration     │
│ Architecture    │
└─────────────────┘
```

**Example:** System Architect designing system:
- Agent 1: Authentication/Authorization design
- Agent 2: Data layer and storage design
- Agent 3: API layer design
- Agent 4: Frontend architecture

### Pattern 4: Story Parallel Implementation

When implementing multiple stories:

```
┌─────────────────┐
│  Sprint Plan    │
│  Story Queue    │
└────────┬────────┘
         │ Independent stories in parallel
    ┌────┴────┬────────┬────────┐
    ▼         ▼        ▼        ▼
┌───────┐ ┌───────┐ ┌───────┐ ┌───────┐
│STORY-1│ │STORY-2│ │STORY-3│ │STORY-4│
│Backend│ │Backend│ │Frontend│ │Tests │
└───┬───┘ └───┬───┘ └───┬───┘ └───┬───┘
    │         │        │        │
    └────┬────┴────────┴────────┘
         ▼
┌─────────────────┐
│ Integration &   │
│ Verification    │
└─────────────────┘
```

## Subprocess Prompt Template

Each subprocess prompt should be self-contained:

```markdown
## Task: [Specific Task Name]

## Context
[Provide all necessary context - the subprocess cannot see main conversation]
- Project: {{project_name}}
- Phase: {{current_phase}}
- Related docs: [list paths to read]

## Objective
[Clear, specific goal for this subprocess]

## Constraints
- [Any limitations or requirements]
- Output format: [specify expected output]

## Deliverables
1. [Specific deliverable 1]
2. [Specific deliverable 2]

## Output Location
Write results to: [specific file path]
```

## Coordination Strategies

### Shared Context via Files

Before launching parallel agents, write shared context to a file:

```markdown
1. Write shared context to bmad/context/current-task.md
2. Launch agents that read from this file
3. Each agent writes output to bmad/outputs/agent-{n}.md
4. Main context synthesizes all outputs
```

### Dependency Management

For tasks with dependencies:

```
Phase 1 (Parallel):     Agent A, Agent B, Agent C
                              │
                        Wait for all
                              │
Phase 2 (Parallel):     Agent D (needs A), Agent E (needs B,C)
                              │
                        Wait for all
                              │
Phase 3 (Sequential):   Final synthesis in main context
```

### Result Collection

```python
# Pseudocode for result collection
agents = []
agents.append(launch_agent("task 1", background=True))
agents.append(launch_agent("task 2", background=True))
agents.append(launch_agent("task 3", background=True))

# Continue with other work while agents run

# When ready, collect results
for agent in agents:
    result = get_agent_output(agent, block=True)
    process(result)
```

## Skill-Specific Patterns

### Business Analyst
- **Research Phase**: 4 parallel agents for market/competitive/tech/user research
- **Interview Phase**: Sequential (interactive with user)
- **Document Phase**: 3 parallel agents for different brief sections

### Product Manager
- **Requirements Gathering**: Sequential (interactive)
- **PRD Generation**: 4 parallel agents for FR/NFR/Epics/Stories sections
- **Prioritization**: 1 agent per epic for RICE scoring

### System Architect
- **Requirements Analysis**: 2 parallel agents (FR analysis, NFR analysis)
- **Component Design**: N parallel agents (one per major component)
- **Integration Design**: Sequential (needs component outputs)

### Scrum Master
- **Epic Breakdown**: N parallel agents (one per epic)
- **Story Generation**: Parallel within each epic
- **Sprint Planning**: Sequential (needs all stories)

### Developer
- **Implementation**: Parallel for independent stories
- **Testing**: Parallel test writing for different components
- **Code Review**: Sequential per PR

### Creative Intelligence
- **Brainstorming**: N parallel agents using different techniques
- **Research**: 4+ parallel agents for different source types
- **Synthesis**: Sequential (combines all findings)

### UX Designer
- **Flow Design**: Parallel for independent user journeys
- **Wireframing**: Parallel for different screens
- **Accessibility**: Parallel checklist validation

### Builder
- **Skill Creation**: Parallel for SKILL.md, scripts, templates, resources
- **Validation**: Parallel validation of different components

## Token Budget Guidelines

Each subprocess has ~200K tokens. Budget allocation:

| Activity | Token Budget |
|----------|-------------|
| Context loading | ~20K |
| Research/exploration | ~100K |
| Generation/writing | ~50K |
| Verification | ~30K |

## Anti-Patterns

**Don't:**
- Launch subprocesses for trivial tasks (<1K tokens of work)
- Pass entire conversation history to subprocesses
- Create deep chains of subprocesses calling subprocesses
- Launch dependent tasks in parallel

**Do:**
- Bundle related small tasks into one subprocess
- Write concise, focused prompts with just needed context
- Keep subprocess depth to 1 level when possible
- Clearly identify dependencies before parallelizing

## Monitoring Pattern

```markdown
1. Launch N background agents
2. Continue main context work
3. Periodically check: AgentOutputTool(agent_id, block=false)
4. When all complete: Synthesize results
5. Update TodoWrite with completion status
```

## Integration with BMAD Workflow

Each skill's SKILL.md should include a "Subprocess Strategy" section:

```markdown
## Subprocess Strategy

This skill uses parallel subprocesses for:
- [Task 1]: N subprocesses for [purpose]
- [Task 2]: N subprocesses for [purpose]

Coordination approach: [Fan-out/Parallel sections/etc.]
```
