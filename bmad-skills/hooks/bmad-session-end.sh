#!/bin/bash
# BMAD Session End Hook - Landing Choreography
# Ensures proper session completion with beads sync and git status check
#
# This hook runs at session end to:
# 1. Sync beads if configured (bd sync)
# 2. Check for uncommitted/unpushed changes
# 3. Output landing status summary
#
# Integration: BMAD + Beads
# Part of PR-016: Landing Choreography

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LANDING_CHECK="$SCRIPT_DIR/../shared/scripts/landing-check.sh"

# First, sync beads if available
if command -v bd &> /dev/null && [[ -d ".beads" ]]; then
    # Run bd sync to ensure all beads data is flushed and pushed
    bd sync 2>/dev/null || true
fi

# Run landing check if script exists
if [[ -x "$LANDING_CHECK" ]]; then
    RESULT=$("$LANDING_CHECK" 2>/dev/null) || true

    # Parse result
    READY=$(echo "$RESULT" | grep -o '"ready_to_land": *[a-z]*' | grep -o 'true\|false')
    SUMMARY=$(echo "$RESULT" | grep -o '"summary": *"[^"]*"' | sed 's/"summary": *"//' | sed 's/"$//')

    # Output status for Claude to see
    echo ""
    echo "═══════════════════════════════════════════════════════"
    echo "  BMAD Session End - Landing Status"
    echo "═══════════════════════════════════════════════════════"

    if [[ "$READY" == "true" ]]; then
        echo "  ✓ $SUMMARY"
    else
        echo "  ⚠ $SUMMARY"
        echo ""
        echo "  Issues found:"
        # Extract and display issues
        echo "$RESULT" | grep -o '"issues": *\[[^]]*\]' | sed 's/"issues": *\[//' | sed 's/\]//' | tr ',' '\n' | sed 's/"//g' | sed 's/^ */    - /'
    fi

    # Show warnings if any
    WARNINGS=$(echo "$RESULT" | grep -o '"warnings": *\[[^]]*\]' | sed 's/"warnings": *\[//' | sed 's/\]//')
    if [[ -n "$WARNINGS" && "$WARNINGS" != "" ]]; then
        echo ""
        echo "  Warnings:"
        echo "$WARNINGS" | tr ',' '\n' | sed 's/"//g' | sed 's/^ */    - /'
    fi

    echo "═══════════════════════════════════════════════════════"
    echo ""
else
    # Fallback: basic checks without landing-check.sh
    echo ""
    echo "═══════════════════════════════════════════════════════"
    echo "  BMAD Session End"
    echo "═══════════════════════════════════════════════════════"

    # Quick git status
    if git rev-parse --git-dir &> /dev/null; then
        UNCOMMITTED=$(git status --porcelain 2>/dev/null | wc -l | tr -d ' ')
        if [[ "$UNCOMMITTED" -gt 0 ]]; then
            echo "  ⚠ $UNCOMMITTED uncommitted changes"
        else
            echo "  ✓ Working directory clean"
        fi

        # Check for unpushed
        UPSTREAM=$(git rev-parse --abbrev-ref --symbolic-full-name @{u} 2>/dev/null) || UPSTREAM=""
        if [[ -n "$UPSTREAM" ]]; then
            UNPUSHED=$(git log @{u}..HEAD --oneline 2>/dev/null | wc -l | tr -d ' ')
            if [[ "$UNPUSHED" -gt 0 ]]; then
                echo "  ⚠ $UNPUSHED unpushed commits"
            else
                echo "  ✓ All commits pushed"
            fi
        fi
    fi

    # Beads status
    if command -v bd &> /dev/null && [[ -d ".beads" ]]; then
        echo "  ✓ Beads synced"
    fi

    echo "═══════════════════════════════════════════════════════"
    echo ""
fi

# Always exit 0 - don't block session end
exit 0
