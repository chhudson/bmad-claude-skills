#!/bin/bash
# Beads Context Injection Hook
# Runs `bd prime` to inject beads workflow context into Claude Code session
#
# This hook is optional - it will silently skip if:
# - bd command is not installed
# - beads is not initialized in the project (.beads/ doesn't exist)
#
# Integration: BMAD + Beads
# See: https://github.com/steveyegge/beads

# Check if bd command is available
if ! command -v bd &> /dev/null; then
    # bd not installed - skip silently (optional integration)
    exit 0
fi

# Check if beads is initialized in the project
if [ ! -d ".beads" ]; then
    # No .beads directory - not a beads-tracked project
    exit 0
fi

# Run bd prime to inject workflow context
# bd prime outputs context that Claude will use for the session
bd prime 2>/dev/null || true
