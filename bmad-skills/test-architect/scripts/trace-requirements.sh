#!/bin/bash
# trace-requirements.sh - Generate requirements to tests traceability
# Usage: ./trace-requirements.sh [stories-dir] [tests-dir]
#
# Arguments:
#   stories-dir - Directory containing story files (default: docs/stories)
#   tests-dir   - Directory containing test files (default: tests)
#
# Output: JSON mapping of requirements to tests

set -e

STORIES_DIR="${1:-docs/stories}"
TESTS_DIR="${2:-tests}"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo "Requirements Traceability Analysis"
echo "==================================="
echo "Stories: $STORIES_DIR"
echo "Tests: $TESTS_DIR"
echo ""

# Check directories exist
if [ ! -d "$STORIES_DIR" ]; then
    echo -e "${YELLOW}Warning: Stories directory not found: $STORIES_DIR${NC}"
    STORIES_DIR=""
fi

if [ ! -d "$TESTS_DIR" ]; then
    echo -e "${RED}Error: Tests directory not found: $TESTS_DIR${NC}"
    exit 1
fi

# Extract story IDs from stories directory
echo "Extracting requirements..."
REQUIREMENTS=()

if [ -n "$STORIES_DIR" ]; then
    while IFS= read -r -d '' file; do
        # Extract story ID from filename (e.g., STORY-001.md)
        filename=$(basename "$file")
        if [[ "$filename" =~ ^(STORY-[0-9]+) ]]; then
            story_id="${BASH_REMATCH[1]}"
            REQUIREMENTS+=("$story_id")
            echo "  Found: $story_id"
        fi
    done < <(find "$STORIES_DIR" -name "STORY-*.md" -print0 2>/dev/null)
fi

echo ""
echo "Scanning test files for story references..."

# Create output JSON
OUTPUT_FILE="/tmp/traceability-matrix.json"
echo "{" > "$OUTPUT_FILE"
echo '  "requirements": {' >> "$OUTPUT_FILE"

FIRST=true
COVERED=0
TOTAL=${#REQUIREMENTS[@]}

for req in "${REQUIREMENTS[@]}"; do
    # Search for story ID in test files
    MATCHING_TESTS=$(grep -rl "$req" "$TESTS_DIR" 2>/dev/null | head -10)

    if [ -n "$MATCHING_TESTS" ]; then
        ((COVERED++))
        STATUS="covered"
        COLOR=$GREEN
    else
        STATUS="missing"
        COLOR=$RED
    fi

    echo -e "  $req: ${COLOR}$STATUS${NC}"

    # Add to JSON
    if [ "$FIRST" = true ]; then
        FIRST=false
    else
        echo "," >> "$OUTPUT_FILE"
    fi

    echo -n "    \"$req\": {" >> "$OUTPUT_FILE"
    echo -n "\"status\": \"$STATUS\"" >> "$OUTPUT_FILE"

    if [ -n "$MATCHING_TESTS" ]; then
        echo -n ", \"tests\": [" >> "$OUTPUT_FILE"
        FIRST_TEST=true
        while IFS= read -r test; do
            if [ "$FIRST_TEST" = true ]; then
                FIRST_TEST=false
            else
                echo -n ", " >> "$OUTPUT_FILE"
            fi
            echo -n "\"$test\"" >> "$OUTPUT_FILE"
        done <<< "$MATCHING_TESTS"
        echo -n "]" >> "$OUTPUT_FILE"
    fi

    echo -n "}" >> "$OUTPUT_FILE"
done

echo "" >> "$OUTPUT_FILE"
echo "  }," >> "$OUTPUT_FILE"

# Add summary
if [ $TOTAL -gt 0 ]; then
    COVERAGE=$(echo "scale=1; $COVERED * 100 / $TOTAL" | bc)
else
    COVERAGE=0
fi

echo '  "summary": {' >> "$OUTPUT_FILE"
echo "    \"total_requirements\": $TOTAL," >> "$OUTPUT_FILE"
echo "    \"covered\": $COVERED," >> "$OUTPUT_FILE"
echo "    \"missing\": $((TOTAL - COVERED))," >> "$OUTPUT_FILE"
echo "    \"coverage_percentage\": $COVERAGE" >> "$OUTPUT_FILE"
echo "  }" >> "$OUTPUT_FILE"
echo "}" >> "$OUTPUT_FILE"

echo ""
echo "Summary"
echo "-------"
echo "Total requirements: $TOTAL"
echo -e "Covered: ${GREEN}$COVERED${NC}"
echo -e "Missing: ${RED}$((TOTAL - COVERED))${NC}"
echo -e "Coverage: ${COVERAGE}%"
echo ""
echo "Output: $OUTPUT_FILE"

# Exit with error if coverage is below threshold
THRESHOLD=80
if command -v bc &> /dev/null; then
    BELOW_THRESHOLD=$(echo "$COVERAGE < $THRESHOLD" | bc -l)
else
    BELOW_THRESHOLD=$((${COVERAGE%.*} < THRESHOLD))
fi

if [ "$BELOW_THRESHOLD" -eq 1 ]; then
    echo ""
    echo -e "${YELLOW}Warning: Coverage below ${THRESHOLD}% threshold${NC}"
    exit 1
fi

exit 0
