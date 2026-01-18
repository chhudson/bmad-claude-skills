#!/bin/bash
# burndown.sh - Generate sprint burndown data from beads
#
# Usage: burndown.sh <sprint-id> [--format json|table]
#
# Queries beads for sprint burndown data by examining the sprint molecule
# and its child stories. Calculates completed, in-progress, and remaining points.
#
# Gracefully skips if bd is not installed or .beads/ doesn't exist.
#
# Arguments:
#   sprint-id  - Beads sprint molecule ID (e.g., bd-a1b2)
#   --format   - Output format: json (default) or table
#
# Output (JSON):
#   {
#     "sprint_id": "bd-a1b2",
#     "total_stories": 5,
#     "total_points": 21,
#     "completed_stories": 2,
#     "completed_points": 8,
#     "in_progress_stories": 1,
#     "in_progress_points": 3,
#     "remaining_stories": 2,
#     "remaining_points": 10,
#     "completion_percentage": 38.1,
#     "stories": [...]
#   }
#
# Exit codes:
#   0 - Success (data retrieved or gracefully skipped)
#   1 - Error (invalid arguments)
#
# Example:
#   bash burndown.sh bd-a1b2
#   bash burndown.sh bd-a1b2 --format table

set -e

# Arguments
SPRINT_ID="${1:-}"
FORMAT="json"

# Parse optional arguments
shift || true
while [[ $# -gt 0 ]]; do
    case "$1" in
        --format)
            FORMAT="${2:-json}"
            shift 2
            ;;
        *)
            shift
            ;;
    esac
done

# Validate required arguments
if [[ -z "$SPRINT_ID" ]]; then
    echo '{"sprint_id": null, "status": "error", "reason": "Missing required argument: sprint-id"}'
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

# Check if jq is available for JSON processing
if ! command -v jq &> /dev/null; then
    echo '{"sprint_id": null, "status": "error", "reason": "jq command not installed (required for JSON processing)"}'
    exit 1
fi

# Get sprint details and children
# bd list with parent filter shows child issues
SPRINT_CHILDREN=$(bd list --parent "$SPRINT_ID" --json 2>/dev/null) || {
    echo "{\"sprint_id\": \"$SPRINT_ID\", \"status\": \"error\", \"reason\": \"Failed to query sprint children\"}"
    exit 0
}

# Check if we got valid JSON
if [[ -z "$SPRINT_CHILDREN" || "$SPRINT_CHILDREN" == "null" || "$SPRINT_CHILDREN" == "[]" ]]; then
    # Try alternative: list all issues with bmad:story label and filter
    SPRINT_CHILDREN=$(bd list -l "bmad:story" --json 2>/dev/null) || SPRINT_CHILDREN="[]"
fi

# Calculate metrics using jq
# Note: Story points are stored in sp:N labels
METRICS=$(echo "$SPRINT_CHILDREN" | jq -r '
  # Function to extract story points from labels
  def get_points:
    if .labels then
      (.labels | map(select(startswith("sp:"))) | .[0] // "sp:0" | split(":")[1] | tonumber)
    else
      0
    end;

  # Categorize stories by status
  {
    total_stories: length,
    total_points: [.[] | get_points] | add // 0,
    completed_stories: [.[] | select(.status == "closed" or .status == "done")] | length,
    completed_points: [.[] | select(.status == "closed" or .status == "done") | get_points] | add // 0,
    in_progress_stories: [.[] | select(.status == "in_progress")] | length,
    in_progress_points: [.[] | select(.status == "in_progress") | get_points] | add // 0,
    not_started_stories: [.[] | select(.status == "open" or .status == "todo" or .status == null)] | length,
    not_started_points: [.[] | select(.status == "open" or .status == "todo" or .status == null) | get_points] | add // 0,
    stories: [.[] | {
      id: .id,
      title: .title,
      status: .status,
      points: get_points,
      priority: .priority
    }]
  }
' 2>/dev/null) || {
    # Fallback if jq processing fails
    echo "{\"sprint_id\": \"$SPRINT_ID\", \"status\": \"error\", \"reason\": \"Failed to parse sprint data\"}"
    exit 0
}

# Calculate remaining and completion percentage
TOTAL_POINTS=$(echo "$METRICS" | jq -r '.total_points')
COMPLETED_POINTS=$(echo "$METRICS" | jq -r '.completed_points')
IN_PROGRESS_POINTS=$(echo "$METRICS" | jq -r '.in_progress_points')

if [[ "$TOTAL_POINTS" -gt 0 ]]; then
    COMPLETION_PCT=$(echo "scale=1; ($COMPLETED_POINTS * 100) / $TOTAL_POINTS" | bc)
else
    COMPLETION_PCT="0.0"
fi

REMAINING_POINTS=$((TOTAL_POINTS - COMPLETED_POINTS))
REMAINING_STORIES=$(echo "$METRICS" | jq -r '.not_started_stories')

# Build final output
if [[ "$FORMAT" == "table" ]]; then
    # Table format output
    echo "Sprint Burndown: $SPRINT_ID"
    echo "================================"
    echo ""
    printf "%-20s %s\n" "Total Stories:" "$(echo "$METRICS" | jq -r '.total_stories')"
    printf "%-20s %s\n" "Total Points:" "$TOTAL_POINTS"
    echo "--------------------------------"
    printf "%-20s %s (%s pts)\n" "Completed:" "$(echo "$METRICS" | jq -r '.completed_stories')" "$COMPLETED_POINTS"
    printf "%-20s %s (%s pts)\n" "In Progress:" "$(echo "$METRICS" | jq -r '.in_progress_stories')" "$IN_PROGRESS_POINTS"
    printf "%-20s %s (%s pts)\n" "Not Started:" "$REMAINING_STORIES" "$(echo "$METRICS" | jq -r '.not_started_points')"
    echo "--------------------------------"
    printf "%-20s %s%%\n" "Completion:" "$COMPLETION_PCT"
    echo ""
    echo "Stories:"
    echo "$METRICS" | jq -r '.stories[] | "  [\(.status // "open")] \(.id): \(.title) (\(.points) pts)"'
else
    # JSON format output (default)
    echo "$METRICS" | jq --arg sprint_id "$SPRINT_ID" --arg completion "$COMPLETION_PCT" --argjson remaining "$REMAINING_POINTS" --argjson remaining_stories "$REMAINING_STORIES" '
      {
        sprint_id: $sprint_id,
        status: "success",
        total_stories: .total_stories,
        total_points: .total_points,
        completed_stories: .completed_stories,
        completed_points: .completed_points,
        in_progress_stories: .in_progress_stories,
        in_progress_points: .in_progress_points,
        remaining_stories: $remaining_stories,
        remaining_points: $remaining,
        completion_percentage: ($completion | tonumber),
        stories: .stories
      }
    '
fi
