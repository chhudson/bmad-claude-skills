#!/bin/bash
# landing-check.sh - Verify session is ready to end ("landing the plane")
#
# Checks before ending a Claude Code session:
# 1. No uncommitted changes
# 2. No unpushed commits
# 3. Beads synced (if configured)
#
# Usage:
#   landing-check.sh           # Full check, returns JSON
#   landing-check.sh --quick   # Quick check, returns pass/fail
#   landing-check.sh --fix     # Attempt to auto-fix issues
#
# Output (JSON):
#   {
#     "ready_to_land": true|false,
#     "issues": [...],
#     "warnings": [...],
#     "summary": "..."
#   }
#
# Exit codes:
#   0 - Ready to land (or issues fixed)
#   1 - Has blocking issues
#   2 - Has warnings only

set -e

# Parse arguments
QUICK_MODE=false
FIX_MODE=false

while [[ $# -gt 0 ]]; do
    case "$1" in
        --quick)
            QUICK_MODE=true
            shift
            ;;
        --fix)
            FIX_MODE=true
            shift
            ;;
        -h|--help)
            echo "Usage: landing-check.sh [--quick] [--fix]"
            echo "  --quick  Quick pass/fail check"
            echo "  --fix    Attempt to auto-fix issues"
            exit 0
            ;;
        *)
            echo '{"error": "Unknown argument: '"$1"'"}'
            exit 1
            ;;
    esac
done

# Initialize result arrays
ISSUES=()
WARNINGS=()
FIXES_APPLIED=()

# Check if we're in a git repository
if ! git rev-parse --git-dir &> /dev/null; then
    if [[ "$QUICK_MODE" == "true" ]]; then
        echo "SKIP: Not a git repository"
        exit 0
    fi
    cat << 'EOF'
{
  "ready_to_land": true,
  "issues": [],
  "warnings": ["Not a git repository - skipping git checks"],
  "summary": "Not a git repository"
}
EOF
    exit 0
fi

# Check for uncommitted changes (staged)
STAGED_CHANGES=$(git diff --cached --name-only 2>/dev/null | wc -l | tr -d ' ')
if [[ "$STAGED_CHANGES" -gt 0 ]]; then
    if [[ "$FIX_MODE" == "true" ]]; then
        # In fix mode, we could commit but that's dangerous without user input
        WARNINGS+=("$STAGED_CHANGES staged changes not committed (use git commit)")
    else
        ISSUES+=("$STAGED_CHANGES staged changes not committed")
    fi
fi

# Check for unstaged changes (modified tracked files)
UNSTAGED_CHANGES=$(git diff --name-only 2>/dev/null | wc -l | tr -d ' ')
if [[ "$UNSTAGED_CHANGES" -gt 0 ]]; then
    WARNINGS+=("$UNSTAGED_CHANGES modified files not staged")
fi

# Check for untracked files (only in project directories, not all)
UNTRACKED_COUNT=$(git ls-files --others --exclude-standard 2>/dev/null | wc -l | tr -d ' ')
if [[ "$UNTRACKED_COUNT" -gt 0 ]]; then
    WARNINGS+=("$UNTRACKED_COUNT untracked files")
fi

# Check for unpushed commits
UPSTREAM=$(git rev-parse --abbrev-ref --symbolic-full-name @{u} 2>/dev/null) || UPSTREAM=""
if [[ -n "$UPSTREAM" ]]; then
    UNPUSHED=$(git log @{u}..HEAD --oneline 2>/dev/null | wc -l | tr -d ' ')
    if [[ "$UNPUSHED" -gt 0 ]]; then
        if [[ "$FIX_MODE" == "true" ]]; then
            # Attempt to push
            if git push 2>/dev/null; then
                FIXES_APPLIED+=("Pushed $UNPUSHED commits to remote")
                UNPUSHED=0
            else
                ISSUES+=("$UNPUSHED unpushed commits (push failed)")
            fi
        else
            ISSUES+=("$UNPUSHED unpushed commits")
        fi
    fi
else
    WARNINGS+=("No upstream branch configured")
fi

# Check beads status (if available)
BEADS_STATUS="not_configured"
if command -v bd &> /dev/null && [[ -d ".beads" ]]; then
    BEADS_STATUS="configured"

    # Check if beads has pending changes
    BEADS_DIRTY=$(bd status --json 2>/dev/null | grep -o '"dirty": *true' || echo "")
    if [[ -n "$BEADS_DIRTY" ]]; then
        if [[ "$FIX_MODE" == "true" ]]; then
            # Run bd sync to flush and push
            if bd sync 2>/dev/null; then
                FIXES_APPLIED+=("Synced beads to remote")
            else
                WARNINGS+=("Beads sync failed")
            fi
        else
            WARNINGS+=("Beads has unsaved changes (run: bd sync)")
        fi
    fi
fi

# Quick mode - just return pass/fail
if [[ "$QUICK_MODE" == "true" ]]; then
    if [[ ${#ISSUES[@]} -eq 0 ]]; then
        echo "PASS: Ready to land"
        exit 0
    else
        echo "FAIL: ${ISSUES[*]}"
        exit 1
    fi
fi

# Build JSON output
READY_TO_LAND="true"
EXIT_CODE=0

if [[ ${#ISSUES[@]} -gt 0 ]]; then
    READY_TO_LAND="false"
    EXIT_CODE=1
elif [[ ${#WARNINGS[@]} -gt 0 ]]; then
    EXIT_CODE=2
fi

# Format arrays as JSON
format_json_array() {
    local arr=("$@")
    if [[ ${#arr[@]} -eq 0 ]]; then
        echo "[]"
        return
    fi
    local json="["
    local first=true
    for item in "${arr[@]}"; do
        if [[ "$first" == "true" ]]; then
            first=false
        else
            json+=", "
        fi
        json+="\"$item\""
    done
    json+="]"
    echo "$json"
}

ISSUES_JSON=$(format_json_array "${ISSUES[@]}")
WARNINGS_JSON=$(format_json_array "${WARNINGS[@]}")
FIXES_JSON=$(format_json_array "${FIXES_APPLIED[@]}")

# Build summary
if [[ "$READY_TO_LAND" == "true" && ${#WARNINGS[@]} -eq 0 ]]; then
    SUMMARY="All clear - ready to land"
elif [[ "$READY_TO_LAND" == "true" ]]; then
    SUMMARY="${#WARNINGS[@]} warnings, but ready to land"
else
    SUMMARY="${#ISSUES[@]} issues must be resolved before ending session"
fi

# Output JSON result
cat << EOF
{
  "ready_to_land": $READY_TO_LAND,
  "issues": $ISSUES_JSON,
  "warnings": $WARNINGS_JSON,
  "fixes_applied": $FIXES_JSON,
  "beads_status": "$BEADS_STATUS",
  "summary": "$SUMMARY"
}
EOF

exit $EXIT_CODE
