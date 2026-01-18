# Excalidraw Element Creation Guidelines

## Text Width Calculation

For text elements inside shapes (labels):

```
text_width = (text.length × fontSize × 0.6) + 20
```

Round to nearest 10 for grid alignment.

## Element Grouping Rules

**CRITICAL:** When creating shapes with labels:

1. Generate unique IDs:
   - `shape-id` for the shape (e.g., `component-1`, `process-2`)
   - `text-id` for the text (e.g., `text-component-1`, `text-process-2`)
   - `group-id` for the group (e.g., `group-component-1`, `group-process-2`)

2. Shape element must have:
   - `groupIds: [group-id]`
   - `boundElements: [{type: "text", id: text-id}]`

3. Text element must have:
   - `containerId: shape-id`
   - `groupIds: [group-id]` (SAME as shape)
   - `textAlign: "center"`
   - `verticalAlign: "middle"`
   - `width: calculated_width`

## Grid Alignment

- Snap all `x`, `y` coordinates to 20px grid
- Formula: `Math.round(value / 20) * 20`
- Spacing between elements: 60px minimum
- Section spacing: 120px minimum

## Arrow Creation

### Straight Arrows

Use for forward flow (left-to-right, top-to-bottom):

```json
{
  "type": "arrow",
  "startBinding": {
    "elementId": "source-shape-id",
    "focus": 0,
    "gap": 10
  },
  "endBinding": {
    "elementId": "target-shape-id",
    "focus": 0,
    "gap": 10
  },
  "points": [[0, 0], [distance_x, distance_y]]
}
```

### Elbow Arrows

Use for upward flow, backward flow, or complex routing:

```json
{
  "type": "arrow",
  "startBinding": {...},
  "endBinding": {...},
  "points": [
    [0, 0],
    [intermediate_x, 0],
    [intermediate_x, intermediate_y],
    [final_x, final_y]
  ],
  "elbowed": true
}
```

### Update Connected Shapes

After creating arrow, update `boundElements` on both connected shapes:

```json
{
  "id": "shape-id",
  "boundElements": [
    { "type": "text", "id": "text-id" },
    { "type": "arrow", "id": "arrow-id" }
  ]
}
```

## Theme Application

Theme colors should be applied consistently:

- **Shapes**: `backgroundColor` from theme primary fill
- **Borders**: `strokeColor` from theme accent
- **Text**: `strokeColor` = "#1e1e1e" (dark text)
- **Arrows**: `strokeColor` from theme accent

## Required Element Properties

### Shape Element (rectangle/ellipse/diamond)

```json
{
  "id": "unique-id",
  "type": "rectangle",
  "x": 100,
  "y": 100,
  "width": 160,
  "height": 80,
  "angle": 0,
  "strokeColor": "#1976d2",
  "backgroundColor": "#e3f2fd",
  "fillStyle": "solid",
  "strokeWidth": 2,
  "strokeStyle": "solid",
  "roughness": 0,
  "opacity": 100,
  "groupIds": ["group-id"],
  "boundElements": [
    { "type": "text", "id": "text-id" }
  ],
  "roundness": { "type": 3, "value": 8 }
}
```

### Text Element (inside shape)

```json
{
  "id": "text-id",
  "type": "text",
  "x": 110,
  "y": 130,
  "width": 140,
  "height": 20,
  "angle": 0,
  "strokeColor": "#1e1e1e",
  "backgroundColor": "transparent",
  "fillStyle": "solid",
  "strokeWidth": 1,
  "strokeStyle": "solid",
  "roughness": 0,
  "opacity": 100,
  "groupIds": ["group-id"],
  "text": "Label Text",
  "fontSize": 16,
  "fontFamily": 1,
  "textAlign": "center",
  "verticalAlign": "middle",
  "containerId": "unique-id",
  "originalText": "Label Text",
  "autoResize": true
}
```

## Validation Checklist

Before saving, verify:

- [ ] All shapes with labels have matching `groupIds`
- [ ] All text elements have `containerId` pointing to parent shape
- [ ] Text width calculated properly (no cutoff)
- [ ] Text alignment set (`textAlign` + `verticalAlign`)
- [ ] All elements snapped to 20px grid
- [ ] All arrows have `startBinding` and `endBinding`
- [ ] `boundElements` array updated on connected shapes
- [ ] Theme colors applied consistently
- [ ] No metadata or history in final output
- [ ] All IDs are unique

## Output JSON Structure

Final `.excalidraw` file format:

```json
{
  "type": "excalidraw",
  "version": 2,
  "source": "bmad-ux-designer",
  "elements": [
    // All diagram elements
  ],
  "appState": {
    "gridSize": 20,
    "viewBackgroundColor": "#ffffff"
  }
}
```

## Optimization

Remove from final output:

- Large `appState` properties (keep only essential)
- `files` object (unless images used)
- All elements with `isDeleted: true`
- Unused library items
- Version history

## Element Limits by Diagram Type

| Type | Max Elements | Notes |
|------|--------------|-------|
| Flowchart | 50 | Includes shapes + arrows + labels |
| Architecture | 80 | Components + connections |
| Wireframe | 100 | UI elements per screen |
| Dataflow | 60 | DFD components + flows |

Keep diagrams readable by splitting complex systems into multiple files.
