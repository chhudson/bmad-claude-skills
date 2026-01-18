#!/bin/bash
# Generate llms-full.txt from BMAD skills documentation
# This concatenates all docs into a single file for LLM consumption

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
SKILLS_DIR="$PROJECT_ROOT/bmad-skills"
COMMANDS_DIR="$PROJECT_ROOT/bmad-v6/commands"
OUTPUT_FILE="$PROJECT_ROOT/docs/llms-full.txt"

# Header
cat > "$OUTPUT_FILE" << 'EOF'
# BMAD Skills for Claude Code - Complete Documentation

> This file contains the complete BMAD Skills documentation for LLM consumption.
> Generated automatically from the documentation source files.
> For installation and web docs, visit: https://github.com/bmadmethod/claude-code-bmad-skills

---

EOF

# Function to process a markdown file (preserves frontmatter for skills)
process_file() {
    local file="$1"
    local relative_path="${file#$PROJECT_ROOT/}"

    echo "<document path=\"$relative_path\">" >> "$OUTPUT_FILE"
    echo "" >> "$OUTPUT_FILE"

    # Include full content (preserve frontmatter for SKILL.md files)
    cat "$file" >> "$OUTPUT_FILE"

    echo "" >> "$OUTPUT_FILE"
    echo "</document>" >> "$OUTPUT_FILE"
    echo "" >> "$OUTPUT_FILE"
}

# Function to process a markdown file (strips frontmatter)
process_file_strip_frontmatter() {
    local file="$1"
    local relative_path="${file#$PROJECT_ROOT/}"

    echo "<document path=\"$relative_path\">" >> "$OUTPUT_FILE"
    echo "" >> "$OUTPUT_FILE"

    # Remove frontmatter and add content
    sed '/^---$/,/^---$/d' "$file" >> "$OUTPUT_FILE"

    echo "" >> "$OUTPUT_FILE"
    echo "</document>" >> "$OUTPUT_FILE"
    echo "" >> "$OUTPUT_FILE"
}

echo "Generating llms-full.txt..."

# =============================================================================
# SECTION 1: Core Reference Files
# =============================================================================
cat >> "$OUTPUT_FILE" << 'EOF'
# ============================================================================
# SECTION 1: Core Reference Files
# ============================================================================

EOF

# Root README
if [ -f "$PROJECT_ROOT/README.md" ]; then
    process_file_strip_frontmatter "$PROJECT_ROOT/README.md"
fi

# Main CLAUDE.md (skill activation guide - THE KEY FILE)
if [ -f "$SKILLS_DIR/CLAUDE.md" ]; then
    process_file "$SKILLS_DIR/CLAUDE.md"
fi

# Subprocess patterns
if [ -f "$SKILLS_DIR/SUBPROCESS-PATTERNS.md" ]; then
    process_file "$SKILLS_DIR/SUBPROCESS-PATTERNS.md"
fi

# Shared helpers
if [ -f "$SKILLS_DIR/shared/helpers.md" ]; then
    process_file "$SKILLS_DIR/shared/helpers.md"
fi

# =============================================================================
# SECTION 2: Skill Documentation (12 skills)
# =============================================================================
cat >> "$OUTPUT_FILE" << 'EOF'
# ============================================================================
# SECTION 2: Skill Documentation
# ============================================================================

EOF

# Process skills in logical order (orchestrator first, then by phase)
SKILL_ORDER="bmad-orchestrator business-analyst product-manager system-architect scrum-master developer test-architect ux-designer creative-intelligence tech-writer quick-flow builder"

for skill in $SKILL_ORDER; do
    skill_dir="$SKILLS_DIR/$skill"
    if [ -d "$skill_dir" ]; then
        # SKILL.md (preserve frontmatter - critical for skill activation)
        if [ -f "$skill_dir/SKILL.md" ]; then
            process_file "$skill_dir/SKILL.md"
        fi
    fi
done

# =============================================================================
# SECTION 3: Skill Reference Documentation
# =============================================================================
cat >> "$OUTPUT_FILE" << 'EOF'
# ============================================================================
# SECTION 3: Skill Reference Documentation
# ============================================================================

EOF

for skill in $SKILL_ORDER; do
    skill_dir="$SKILLS_DIR/$skill"
    if [ -d "$skill_dir" ]; then
        # REFERENCE.md (detailed patterns and knowledge)
        if [ -f "$skill_dir/REFERENCE.md" ]; then
            process_file_strip_frontmatter "$skill_dir/REFERENCE.md"
        fi
    fi
done

# =============================================================================
# SECTION 4: Command Documentation (35+ commands)
# =============================================================================
cat >> "$OUTPUT_FILE" << 'EOF'
# ============================================================================
# SECTION 4: Command Documentation
# ============================================================================

EOF

# Process commands in alphabetical order
if [ -d "$COMMANDS_DIR" ]; then
    for cmd in "$COMMANDS_DIR"/*.md; do
        if [ -f "$cmd" ]; then
            process_file "$cmd"
        fi
    done
fi

# =============================================================================
# SECTION 5: Templates
# =============================================================================
cat >> "$OUTPUT_FILE" << 'EOF'
# ============================================================================
# SECTION 5: Key Templates
# ============================================================================

EOF

# Process key templates from each skill
for skill in $SKILL_ORDER; do
    template_dir="$SKILLS_DIR/$skill/templates"
    if [ -d "$template_dir" ]; then
        for template in "$template_dir"/*.md "$template_dir"/*.yaml; do
            if [ -f "$template" ]; then
                process_file "$template"
            fi
        done
    fi
done

# Shared templates
if [ -d "$SKILLS_DIR/shared/templates" ]; then
    for template in "$SKILLS_DIR/shared/templates"/*.md; do
        if [ -f "$template" ]; then
            process_file "$template"
        fi
    done
fi

# =============================================================================
# SECTION 6: Resources
# =============================================================================
cat >> "$OUTPUT_FILE" << 'EOF'
# ============================================================================
# SECTION 6: Resources
# ============================================================================

EOF

# Process resources from each skill
for skill in $SKILL_ORDER; do
    resource_dir="$SKILLS_DIR/$skill/resources"
    if [ -d "$resource_dir" ]; then
        for resource in "$resource_dir"/*.md; do
            if [ -f "$resource" ]; then
                process_file_strip_frontmatter "$resource"
            fi
        done
    fi
done

# Add footer
cat >> "$OUTPUT_FILE" << 'EOF'
---

# End of Documentation

For updates and contributions, visit: https://github.com/bmadmethod/claude-code-bmad-skills

## Quick Reference

**Installation:**
```bash
curl -fsSL https://raw.githubusercontent.com/bmadmethod/claude-code-bmad-skills/main/install-v6.sh | bash
```

**Initialize BMAD in a project:**
```
/workflow-init
```

**Check status:**
```
/workflow-status
```

**Key Commands:**
- `/product-brief` - Create product brief (Phase 1)
- `/prd` - Create PRD (Phase 2)
- `/architecture` - Design architecture (Phase 3)
- `/sprint-planning` - Plan sprints (Phase 4)
- `/dev-story STORY-ID` - Implement a story
- `/quick-spec` + `/quick-dev` - Bypass for Level 0-1 work

EOF

echo "Generated: $OUTPUT_FILE"
echo "Size: $(wc -c < "$OUTPUT_FILE" | tr -d ' ') bytes"
echo "Lines: $(wc -l < "$OUTPUT_FILE" | tr -d ' ')"
