#!/bin/bash
# sprint-from-beads.sh - Create a beads sprint molecule for BMAD sprint planning
#
# Usage: sprint-from-beads.sh <sprint-number> <sprint-goal> [start-date] [end-date]
#
# Creates a beads epic (molecule) to track a sprint. Stories can then be linked
# as children using sync-to-beads.sh with the sprint-id parameter.
#
# Gracefully skips if bd is not installed or .beads/ doesn't exist.
#
# Arguments:
#   sprint-number - Sprint number (e.g., 1, 2, 3)
#   sprint-goal   - Brief sprint goal description
#   start-date    - Optional: Sprint start date (YYYY-MM-DD)
#   end-date      - Optional: Sprint end date (YYYY-MM-DD)
#
# Output (JSON):
#   { "sprint_id": "bd-xxxx", "status": "created", "sprint_number": 1 }
#   { "sprint_id": null, "status": "skipped", "reason": "..." }
#
# Exit codes:
#   0 - Success (molecule created or gracefully skipped)
#   1 - Error (invalid arguments)
#
# Example:
#   bash sprint-from-beads.sh 1 "Complete user authentication" "2026-01-20" "2026-02-03"
#
# Integration with sync-to-beads.sh:
#   After creating a sprint molecule, pass its ID to sync-to-beads.sh:
#     SPRINT_ID=$(bash sprint-from-beads.sh 1 "Sprint goal" | jq -r '.sprint_id')
#     bash sync-to-beads.sh "STORY-001" "Login feature" "Must Have" "5" "$SPRINT_ID"

set -e

# Arguments
SPRINT_NUMBER="${1:-}"
SPRINT_GOAL="${2:-}"
START_DATE="${3:-}"
END_DATE="${4:-}"

# Validate required arguments
if [[ -z "$SPRINT_NUMBER" || -z "$SPRINT_GOAL" ]]; then
    echo '{"sprint_id": null, "status": "error", "reason": "Missing required arguments: sprint-number, sprint-goal"}'
    exit 1
fi

# Validate sprint number is numeric
if ! [[ "$SPRINT_NUMBER" =~ ^[0-9]+$ ]]; then
    echo '{"sprint_id": null, "status": "error", "reason": "Sprint number must be numeric"}'
    exit 1
fi

# Check if bd command is available
if ! command -v bd &> /dev/null; then
    echo '{"sprint_id": null, "status": "skipped", "reason": "bd command not installed"}'
    exit 0
fi

# Check if .beads/ directory exists
if [[ ! -d ".beads" ]]; then
    echo '{"sprint_id": null, "status": "skipped", "reason": ".beads/ directory not found"}'
    exit 0
fi

# Build sprint title
SPRINT_TITLE="Sprint $SPRINT_NUMBER: $SPRINT_GOAL"

# Build the bd create command for epic
BD_CMD="bd create \"$SPRINT_TITLE\" -t epic -p 1"

# Add labels
BD_CMD="$BD_CMD -l \"bmad:sprint\""
BD_CMD="$BD_CMD -l \"sprint:$SPRINT_NUMBER\""

# Add date labels if provided
if [[ -n "$START_DATE" ]]; then
    BD_CMD="$BD_CMD -l \"start:$START_DATE\""
fi
if [[ -n "$END_DATE" ]]; then
    BD_CMD="$BD_CMD -l \"end:$END_DATE\""
fi

# Execute bd create and capture the issue ID
BEADS_OUTPUT=$(eval "$BD_CMD" 2>&1) || {
    echo "{\"sprint_id\": null, \"status\": \"error\", \"reason\": \"bd create failed: $BEADS_OUTPUT\"}"
    exit 0
}

# Extract the beads ID from output (format: bd-xxxx)
SPRINT_ID=$(echo "$BEADS_OUTPUT" | grep -oE 'bd-[a-z0-9]+' | head -1)

if [[ -z "$SPRINT_ID" ]]; then
    # Try alternative: beads might output just the ID
    SPRINT_ID=$(echo "$BEADS_OUTPUT" | grep -oE '^[a-z0-9-]+$' | head -1)
fi

if [[ -z "$SPRINT_ID" ]]; then
    echo "{\"sprint_id\": null, \"status\": \"warning\", \"reason\": \"Epic created but could not extract ID\", \"output\": \"$BEADS_OUTPUT\"}"
    exit 0
fi

# Output success with all details
if [[ -n "$START_DATE" && -n "$END_DATE" ]]; then
    echo "{\"sprint_id\": \"$SPRINT_ID\", \"status\": \"created\", \"sprint_number\": $SPRINT_NUMBER, \"sprint_goal\": \"$SPRINT_GOAL\", \"start_date\": \"$START_DATE\", \"end_date\": \"$END_DATE\"}"
else
    echo "{\"sprint_id\": \"$SPRINT_ID\", \"status\": \"created\", \"sprint_number\": $SPRINT_NUMBER, \"sprint_goal\": \"$SPRINT_GOAL\"}"
fi
