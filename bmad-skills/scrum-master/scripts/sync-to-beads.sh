#!/bin/bash
# sync-to-beads.sh - Bridge BMAD story creation with beads issue tracking
#
# Usage: sync-to-beads.sh <story-id> <title> <priority> [story-points] [sprint-id]
#
# Creates a beads issue for a BMAD story and optionally links it to a sprint molecule.
# Gracefully skips if bd is not installed or .beads/ doesn't exist.
#
# Arguments:
#   story-id     - BMAD story ID (e.g., STORY-001)
#   title        - Story title
#   priority     - BMAD priority (Must Have, Should Have, Could Have, Won't Have)
#   story-points - Optional: Fibonacci story points (1, 2, 3, 5, 8)
#   sprint-id    - Optional: beads sprint molecule ID to link to
#
# Output (JSON):
#   { "beads_id": "bd-xxxx", "status": "created" }
#   { "beads_id": null, "status": "skipped", "reason": "..." }
#
# Exit codes:
#   0 - Success (issue created or gracefully skipped)
#   1 - Error (invalid arguments)

set -e

# Arguments
STORY_ID="${1:-}"
TITLE="${2:-}"
PRIORITY="${3:-}"
STORY_POINTS="${4:-}"
SPRINT_ID="${5:-}"

# Validate required arguments
if [[ -z "$STORY_ID" || -z "$TITLE" || -z "$PRIORITY" ]]; then
    echo '{"beads_id": null, "status": "error", "reason": "Missing required arguments: story-id, title, priority"}'
    exit 1
fi

# Check if bd command is available
if ! command -v bd &> /dev/null; then
    echo '{"beads_id": null, "status": "skipped", "reason": "bd command not installed"}'
    exit 0
fi

# Check if .beads/ directory exists
if [[ ! -d ".beads" ]]; then
    echo '{"beads_id": null, "status": "skipped", "reason": ".beads/ directory not found"}'
    exit 0
fi

# Map BMAD priority to beads priority (1=highest, 4=lowest)
map_priority() {
    case "$1" in
        "Must Have"|"must have"|"must-have"|"P1"|"p1"|"1")
            echo "1"
            ;;
        "Should Have"|"should have"|"should-have"|"P2"|"p2"|"2")
            echo "2"
            ;;
        "Could Have"|"could have"|"could-have"|"P3"|"p3"|"3")
            echo "3"
            ;;
        "Won't Have"|"wont have"|"won't have"|"wont-have"|"P4"|"p4"|"4")
            echo "4"
            ;;
        *)
            echo "2"  # Default to Should Have
            ;;
    esac
}

BEADS_PRIORITY=$(map_priority "$PRIORITY")

# Build the bd create command
BD_CMD="bd create"
BD_CMD="$BD_CMD \"[$STORY_ID] $TITLE\""
BD_CMD="$BD_CMD -p $BEADS_PRIORITY"

# Add story points as label if provided
if [[ -n "$STORY_POINTS" ]]; then
    BD_CMD="$BD_CMD -l \"sp:$STORY_POINTS\""
fi

# Add BMAD label to identify stories created via BMAD
BD_CMD="$BD_CMD -l \"bmad:story\""

# Execute bd create and capture the issue ID
# bd create outputs the issue ID on success
BEADS_OUTPUT=$(eval "$BD_CMD" 2>&1) || {
    echo "{\"beads_id\": null, \"status\": \"error\", \"reason\": \"bd create failed: $BEADS_OUTPUT\"}"
    exit 0
}

# Extract the beads ID from output
# Beads IDs can be in formats like: bd-xxxx, prefix-random-xyz, tool-name-abc
# General pattern: alphanumeric segments separated by dashes
BEADS_ID=$(echo "$BEADS_OUTPUT" | grep -oE '[a-z0-9]+-[a-z0-9-]+' | head -1)

if [[ -z "$BEADS_ID" ]]; then
    # Try alternative: beads might output just a simple ID on its own line
    BEADS_ID=$(echo "$BEADS_OUTPUT" | grep -oE '^[a-zA-Z0-9_-]+$' | head -1)
fi

if [[ -z "$BEADS_ID" ]]; then
    echo "{\"beads_id\": null, \"status\": \"warning\", \"reason\": \"Issue created but could not extract ID\", \"output\": \"$BEADS_OUTPUT\"}"
    exit 0
fi

# If sprint ID provided, add dependency (story blocks sprint completion)
if [[ -n "$SPRINT_ID" ]]; then
    bd dep add "$BEADS_ID" blocks "$SPRINT_ID" 2>/dev/null || true
fi

# Output success
echo "{\"beads_id\": \"$BEADS_ID\", \"status\": \"created\", \"story_id\": \"$STORY_ID\"}"
