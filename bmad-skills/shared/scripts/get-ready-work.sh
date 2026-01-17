#!/bin/bash
# get-ready-work.sh - Get ready work from beads with BMAD story cross-reference
#
# Usage:
#   get-ready-work.sh           # Get all ready work as JSON
#   get-ready-work.sh --check   # Check if beads is available
#   get-ready-work.sh --with-stories  # Include BMAD story metadata
#
# Combines beads issue tracking with local BMAD story documents.
# Gracefully handles case where beads is not configured.
#
# Output (JSON):
#   {
#     "beads_available": true,
#     "ready_issues": [...],
#     "blocked_issues": [...],
#     "total_ready": 3,
#     "total_blocked": 2
#   }
#
# Exit codes:
#   0 - Success (data returned or graceful skip)
#   1 - Error (invalid usage)

set -e

# Parse arguments
CHECK_ONLY=false
WITH_STORIES=false

while [[ $# -gt 0 ]]; do
    case "$1" in
        --check)
            CHECK_ONLY=true
            shift
            ;;
        --with-stories)
            WITH_STORIES=true
            shift
            ;;
        -h|--help)
            echo "Usage: get-ready-work.sh [--check] [--with-stories]"
            echo "  --check        Only check if beads is available"
            echo "  --with-stories Include BMAD story metadata"
            exit 0
            ;;
        *)
            echo '{"error": "Unknown argument: '"$1"'"}'
            exit 1
            ;;
    esac
done

# Function to check beads availability
check_beads() {
    # Check if bd command exists
    if ! command -v bd &> /dev/null; then
        echo '{"beads_available": false, "reason": "bd command not installed"}'
        return 1
    fi

    # Check if .beads/ directory exists
    if [[ ! -d ".beads" ]]; then
        echo '{"beads_available": false, "reason": ".beads/ directory not found"}'
        return 1
    fi

    echo '{"beads_available": true}'
    return 0
}

# If --check flag, just return availability status
if [[ "$CHECK_ONLY" == "true" ]]; then
    check_beads
    exit 0
fi

# Check beads availability
BEADS_CHECK=$(check_beads 2>/dev/null) || true
BEADS_AVAILABLE=$(echo "$BEADS_CHECK" | grep -o '"beads_available": *[a-z]*' | grep -o 'true\|false')

if [[ "$BEADS_AVAILABLE" != "true" ]]; then
    # Beads not available - return empty structure
    REASON=$(echo "$BEADS_CHECK" | grep -o '"reason": *"[^"]*"' | sed 's/"reason": *"//' | sed 's/"$//')
    cat << EOF
{
  "beads_available": false,
  "reason": "${REASON:-beads not configured}",
  "ready_issues": [],
  "blocked_issues": [],
  "in_progress_issues": [],
  "total_ready": 0,
  "total_blocked": 0,
  "total_in_progress": 0
}
EOF
    exit 0
fi

# Beads is available - get ready work
# bd ready --json returns list of unblocked issues

READY_OUTPUT=$(bd ready --json 2>/dev/null) || READY_OUTPUT="[]"
BLOCKED_OUTPUT=$(bd blocked --json 2>/dev/null) || BLOCKED_OUTPUT="[]"

# Get in-progress issues (status = in_progress)
IN_PROGRESS_OUTPUT=$(bd list --status in_progress --json 2>/dev/null) || IN_PROGRESS_OUTPUT="[]"

# Count totals
TOTAL_READY=$(echo "$READY_OUTPUT" | grep -c '"id"' 2>/dev/null || echo "0")
TOTAL_BLOCKED=$(echo "$BLOCKED_OUTPUT" | grep -c '"id"' 2>/dev/null || echo "0")
TOTAL_IN_PROGRESS=$(echo "$IN_PROGRESS_OUTPUT" | grep -c '"id"' 2>/dev/null || echo "0")

# If --with-stories, enrich with BMAD story metadata
if [[ "$WITH_STORIES" == "true" ]]; then
    # This would require more complex parsing
    # For now, just return raw beads data
    # The LLM will cross-reference with docs/stories/
    :
fi

# Build output JSON
cat << EOF
{
  "beads_available": true,
  "ready_issues": ${READY_OUTPUT:-[]},
  "blocked_issues": ${BLOCKED_OUTPUT:-[]},
  "in_progress_issues": ${IN_PROGRESS_OUTPUT:-[]},
  "total_ready": ${TOTAL_READY},
  "total_blocked": ${TOTAL_BLOCKED},
  "total_in_progress": ${TOTAL_IN_PROGRESS}
}
EOF
