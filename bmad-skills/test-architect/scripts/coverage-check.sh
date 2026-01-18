#!/bin/bash
# coverage-check.sh - Verify test coverage meets threshold
# Usage: ./coverage-check.sh [threshold] [coverage-file]
#
# Arguments:
#   threshold     - Minimum coverage percentage (default: 80)
#   coverage-file - Path to coverage JSON file (auto-detected if not provided)
#
# Exit codes:
#   0 - Coverage meets threshold
#   1 - Coverage below threshold
#   2 - Coverage file not found

set -e

THRESHOLD="${1:-80}"
COVERAGE_FILE="${2:-}"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "Coverage Check"
echo "=============="
echo "Threshold: ${THRESHOLD}%"

# Auto-detect coverage file if not provided
if [ -z "$COVERAGE_FILE" ]; then
    # Check common coverage file locations
    POSSIBLE_FILES=(
        "coverage/coverage-summary.json"
        "coverage/coverage-final.json"
        "coverage/lcov-report/index.html"
        ".nyc_output/coverage-summary.json"
        "coverage.json"
    )

    for file in "${POSSIBLE_FILES[@]}"; do
        if [ -f "$file" ]; then
            COVERAGE_FILE="$file"
            break
        fi
    done
fi

if [ -z "$COVERAGE_FILE" ] || [ ! -f "$COVERAGE_FILE" ]; then
    echo -e "${YELLOW}Warning: Coverage file not found${NC}"
    echo "Run tests with coverage first:"
    echo "  npm run test:coverage"
    echo "  npx vitest --coverage"
    echo "  npx jest --coverage"
    exit 2
fi

echo "Coverage file: ${COVERAGE_FILE}"
echo ""

# Parse coverage based on file type
if [[ "$COVERAGE_FILE" == *.json ]]; then
    # JSON coverage file (Jest, c8, v8)
    if command -v jq &> /dev/null; then
        # Try to extract coverage from different JSON formats

        # Istanbul/Jest format
        LINES=$(jq -r '.total.lines.pct // empty' "$COVERAGE_FILE" 2>/dev/null)
        BRANCHES=$(jq -r '.total.branches.pct // empty' "$COVERAGE_FILE" 2>/dev/null)
        FUNCTIONS=$(jq -r '.total.functions.pct // empty' "$COVERAGE_FILE" 2>/dev/null)
        STATEMENTS=$(jq -r '.total.statements.pct // empty' "$COVERAGE_FILE" 2>/dev/null)

        # If not found, try alternative format
        if [ -z "$LINES" ]; then
            LINES=$(jq -r '.lines.pct // .lines.percent // empty' "$COVERAGE_FILE" 2>/dev/null)
            BRANCHES=$(jq -r '.branches.pct // .branches.percent // empty' "$COVERAGE_FILE" 2>/dev/null)
            FUNCTIONS=$(jq -r '.functions.pct // .functions.percent // empty' "$COVERAGE_FILE" 2>/dev/null)
            STATEMENTS=$(jq -r '.statements.pct // .statements.percent // empty' "$COVERAGE_FILE" 2>/dev/null)
        fi
    else
        echo -e "${YELLOW}Warning: jq not installed, cannot parse JSON coverage${NC}"
        echo "Install jq: brew install jq (macOS) or apt-get install jq (Linux)"
        exit 2
    fi
elif [[ "$COVERAGE_FILE" == *.html ]]; then
    # HTML coverage report - extract from summary
    if command -v grep &> /dev/null; then
        LINES=$(grep -oP 'Lines[^0-9]*\K[0-9.]+' "$COVERAGE_FILE" | head -1)
        BRANCHES=$(grep -oP 'Branches[^0-9]*\K[0-9.]+' "$COVERAGE_FILE" | head -1)
        FUNCTIONS=$(grep -oP 'Functions[^0-9]*\K[0-9.]+' "$COVERAGE_FILE" | head -1)
        STATEMENTS=$(grep -oP 'Statements[^0-9]*\K[0-9.]+' "$COVERAGE_FILE" | head -1)
    fi
fi

# Default to 0 if not found
LINES="${LINES:-0}"
BRANCHES="${BRANCHES:-0}"
FUNCTIONS="${FUNCTIONS:-0}"
STATEMENTS="${STATEMENTS:-0}"

# Display results
echo "Coverage Results:"
echo "-----------------"

check_metric() {
    local name="$1"
    local value="$2"
    local threshold="$3"

    # Handle "Unknown" or empty values
    if [ "$value" = "Unknown" ] || [ -z "$value" ] || [ "$value" = "0" ]; then
        echo -e "  $name: ${YELLOW}Unknown${NC}"
        return 1
    fi

    # Compare (using bc for float comparison)
    if command -v bc &> /dev/null; then
        result=$(echo "$value >= $threshold" | bc -l)
    else
        # Fallback to integer comparison
        value_int="${value%.*}"
        result=$((value_int >= threshold))
    fi

    if [ "$result" -eq 1 ]; then
        echo -e "  $name: ${GREEN}${value}%${NC} (>= ${threshold}%)"
        return 0
    else
        echo -e "  $name: ${RED}${value}%${NC} (< ${threshold}%)"
        return 1
    fi
}

FAILED=0

check_metric "Lines" "$LINES" "$THRESHOLD" || FAILED=1
check_metric "Branches" "$BRANCHES" "$THRESHOLD" || FAILED=1
check_metric "Functions" "$FUNCTIONS" "$THRESHOLD" || FAILED=1
check_metric "Statements" "$STATEMENTS" "$THRESHOLD" || FAILED=1

echo ""

if [ $FAILED -eq 0 ]; then
    echo -e "${GREEN}✓ Coverage meets ${THRESHOLD}% threshold${NC}"
    exit 0
else
    echo -e "${RED}✗ Coverage below ${THRESHOLD}% threshold${NC}"
    echo ""
    echo "To improve coverage:"
    echo "1. Review uncovered files in coverage report"
    echo "2. Add tests for uncovered branches and functions"
    echo "3. Focus on business logic and error handling"
    exit 1
fi
