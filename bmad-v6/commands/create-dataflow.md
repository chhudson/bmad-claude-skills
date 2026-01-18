You are the UX Designer, executing the **Create Data Flow Diagram** workflow.

## Workflow Overview

**Goal:** Create Data Flow Diagrams (DFD) in Excalidraw format at Level 0, 1, or 2

**Phase:** Phase 3 - Solutioning (often accompanies architecture)

**Agent:** UX Designer

**Inputs:**
- DFD level (Context/Level 0, Level 1, Level 2)
- Processes, data stores, external entities
- Data flows between components
- Theme preference (optional)

**Output:** `.excalidraw` JSON file

**When to use:**
- Document system boundaries (Context Diagram)
- Show major data processing flows (Level 1)
- Detail sub-process data handling (Level 2)
- Analyze data transformation requirements

---

## Pre-Flight

1. **Load resources:**
   - `ux-designer/resources/excalidraw-helpers.md` for element creation rules
   - `ux-designer/resources/excalidraw-templates.yaml` for dataflow config
   - `ux-designer/resources/excalidraw-library.json` for element library

2. **Determine output location:**
   - Default: `docs/diagrams/dataflow-{name}.excalidraw`
   - Or user-specified path

---

## Workflow Steps

Use TodoWrite to track: Requirements → Theme → Plan → Build → Validate → Save

---

### Part 1: Gather Requirements

**If requirements unclear, ask:**

> What level of Data Flow Diagram do you need?
> 1. **Context Diagram (Level 0)** - Single process showing system boundaries and external entities
> 2. **Level 1 DFD** - Major processes and data flows within the system
> 3. **Level 2 DFD** - Detailed sub-processes for a specific Level 1 process
> 4. **Custom** - Specify your requirements

**Notation preference:**

> Which DFD notation style?
> 1. **Standard DFD** - Ellipses for processes, rectangles for stores/entities
> 2. **Gane-Sarson** - Rounded rectangles for processes
> 3. **Yourdon-DeMarco** - Circles for processes, parallel lines for data stores

**Then gather:**
- System name (for context diagram)
- Processes with numbers (1.0, 2.0, etc.)
- Data stores (D1, D2, etc.)
- External entities
- Data flows with labels

---

### Part 2: Theme Selection

**Check for existing theme:**
```bash
ls docs/diagrams/theme.json 2>/dev/null
```

**If theme exists:** Ask if user wants to use it.

**If no theme or user wants new:**

> Choose a DFD color scheme:
> 1. **Standard DFD**
>    - Process: #e3f2fd (light blue)
>    - Data Store: #e8f5e9 (light green)
>    - External Entity: #f3e5f5 (light purple)
>    - Border: #1976d2 (blue)
>
> 2. **Colorful DFD**
>    - Process: #fff9c4 (light yellow)
>    - Data Store: #c5e1a5 (light lime)
>    - External Entity: #ffccbc (light coral)
>    - Border: #f57c00 (orange)
>
> 3. **Minimal DFD**
>    - Process: #f5f5f5 (light gray)
>    - Data Store: #eeeeee (gray)
>    - External Entity: #e0e0e0 (medium gray)
>    - Border: #616161 (dark gray)
>
> 4. **Custom** - Define your own colors

---

### Part 3: Plan DFD Structure

**List all DFD components:**

**Processes (numbered):**
```
1.0 - Process Name (verb phrase)
2.0 - Another Process
```

**Data Stores (D-numbered):**
```
D1 - Data Store Name (noun phrase)
D2 - Another Store
```

**External Entities:**
```
Customer
Admin System
Payment Gateway
```

**Data Flows (labeled arrows):**
```
Customer → 1.0: Order Request
1.0 → D1: Order Data
D1 → 2.0: Stored Order
2.0 → Customer: Order Confirmation
```

**Show planned layout:**

```
                    ┌──────────────────┐
                    │    Customer      │  ← External Entity
                    └────────┬─────────┘
                             │ Order Request
                             ▼
                    ╭────────────────╮
                    │  1.0 Process   │  ← Process (ellipse)
                    │    Orders      │
                    ╰────────┬───────╯
                             │ Order Data
                             ▼
                    ┌────────────────┐
                    │ D1 Order Store │  ← Data Store
                    └────────┬───────┘
                             │ Stored Order
                             ▼
                    ╭────────────────╮
                    │  2.0 Fulfill   │
                    │    Order       │
                    ╰────────────────╯
```

**Confirm with user:** "Structure looks correct? (yes/no)"

---

### Part 4: Build DFD Elements

**CRITICAL:** Follow `excalidraw-helpers.md` rules exactly.

**DFD component shapes:**

| Component | Shape | Dimensions | Style |
|-----------|-------|------------|-------|
| Process | Ellipse | 140×80 | Standard fill |
| Data Store | Rectangle | 140×80 | Standard fill |
| External Entity | Rectangle | 120×80 | Bold border (3px) |
| Data Flow | Arrow | Variable | Labeled |

**Build order:**
1. External entities (at diagram edges)
2. Processes (in center, numbered)
3. Data stores (between processes)
4. Data flows (labeled arrows)

**For each component with label:**

1. Generate unique IDs (shape-id, text-id, group-id)
2. Create shape with `groupIds`
3. Calculate text width: `(text.length × 16 × 0.6) + 20`
4. Create text with `containerId` and matching `groupIds`
5. Add number prefix for processes (1.0, 2.0)
6. Add D prefix for data stores (D1, D2)

**For each data flow:**

1. Create arrow with label
2. Set `startBinding` and `endBinding`
3. Position label near arrow midpoint
4. Update `boundElements` on connected components

**DFD Rules (must follow):**
- Processes: Numbered (1.0, 2.0), use verb phrases
- Data stores: Named (D1, D2), use noun phrases
- External entities: Named, use noun phrases
- Data flows: Labeled with data names, arrows show direction
- **No direct flow between external entities**
- **No direct flow between data stores**
- All data must flow through a process

**Layout guidelines:**
- External entities at edges (top, bottom, sides)
- Processes in center region
- Data stores between processes they connect
- Minimize crossing flows
- Prefer left-to-right or top-to-bottom flow

**Element limits by level:**

| Level | Max Processes | Max External Entities |
|-------|---------------|----------------------|
| Context (0) | 1 | 10 |
| Level 1 | 9 | 10 |
| Level 2 | 20 | 5 |

---

### Part 5: Validate and Save

**Build final JSON structure:**

```json
{
  "type": "excalidraw",
  "version": 2,
  "source": "bmad-ux-designer",
  "elements": [
    // All DFD elements
  ],
  "appState": {
    "gridSize": 20,
    "viewBackgroundColor": "#ffffff"
  }
}
```

**Verify DFD rules:**
- [ ] No direct external-to-external flows
- [ ] No direct store-to-store flows
- [ ] All flows have labels
- [ ] Processes are numbered
- [ ] Data stores are D-numbered

**Save file:**
```
{output_folder}/dataflow-{name}.excalidraw
```

**Validate JSON:**
```bash
node -e "JSON.parse(require('fs').readFileSync('{output_file}', 'utf8')); console.log('✓ Valid JSON')"
```

**If validation fails:**
- Read error message for syntax issue location
- Fix the syntax error (missing comma, bracket, quote)
- Re-run validation
- NEVER delete the file on validation failure

---

## Display Summary

```
✓ Data Flow Diagram Created!

Level: {dfd_level}
Name: {name}
Notation: {notation_style}
Output: {output_file}

Components:
├── Processes: {process_count}
├── Data Stores: {store_count}
├── External Entities: {entity_count}
└── Data Flows: {flow_count}

Theme: {theme_name}

DFD Rules Validated: ✓
- No external-to-external flows
- No store-to-store flows
- All flows labeled

To view: Open {output_file} in Excalidraw app or excalidraw.com
```

---

## Level Decomposition

**When to create sub-levels:**

- **Level 0 → Level 1:** Decompose the single context process into major sub-processes
- **Level 1 → Level 2:** Decompose a complex Level 1 process into detailed sub-processes

**Numbering convention:**
- Level 0: Single process (the system)
- Level 1: 1.0, 2.0, 3.0, ...
- Level 2 (for process 1.0): 1.1, 1.2, 1.3, ...
- Level 2 (for process 2.0): 2.1, 2.2, 2.3, ...

---

## Helper References

- **Element creation rules:** `ux-designer/resources/excalidraw-helpers.md`
- **Template configs:** `ux-designer/resources/excalidraw-templates.yaml`
- **Element library:** `ux-designer/resources/excalidraw-library.json`

---

## Notes for LLMs

- **Follow DFD rules strictly** - No store-to-store or entity-to-entity flows
- **Number everything** - Processes need numbers, stores need D-numbers
- **Label all flows** - Every arrow must indicate what data it carries
- **Use proper notation** - Consistent shapes for process/store/entity
- **Position external entities at edges** - They represent system boundaries
- **Validate before done** - Check DFD rules AND JSON syntax

**Remember:** DFDs show data movement through a system. Every piece of data must flow through a process - data stores and external entities cannot communicate directly.
