#!/bin/bash
# flaky-detector.sh - Run tests multiple times to detect flaky tests
# Usage: ./flaky-detector.sh [runs] [test-command]
#
# Arguments:
#   runs         - Number of test runs (default: 10)
#   test-command - Test command to run (default: npm test)
#
# Exit codes:
#   0 - No flaky tests detected
#   1 - Flaky tests detected

set -e

RUNS="${1:-10}"
TEST_CMD="${2:-npm test}"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo "Flaky Test Detector"
echo "==================="
echo "Runs: $RUNS"
echo "Command: $TEST_CMD"
echo ""

PASSED=0
FAILED=0
FAILED_RUNS=""

for i in $(seq 1 "$RUNS"); do
    echo -n "Run $i/$RUNS: "

    # Run tests and capture exit code
    set +e
    OUTPUT=$($TEST_CMD 2>&1)
    EXIT_CODE=$?
    set -e

    if [ $EXIT_CODE -eq 0 ]; then
        echo -e "${GREEN}PASS${NC}"
        ((PASSED++))
    else
        echo -e "${RED}FAIL${NC}"
        ((FAILED++))
        FAILED_RUNS="$FAILED_RUNS $i"

        # Save failed output for analysis
        echo "$OUTPUT" > "/tmp/flaky-run-$i.log"
    fi
done

echo ""
echo "Results"
echo "-------"
echo -e "Passed: ${GREEN}$PASSED/$RUNS${NC}"
echo -e "Failed: ${RED}$FAILED/$RUNS${NC}"

if [ $FAILED -gt 0 ]; then
    echo ""
    echo -e "${RED}⚠️  FLAKY TESTS DETECTED${NC}"
    echo "Failed runs:$FAILED_RUNS"
    echo ""
    echo "Failure rate: $(echo "scale=1; $FAILED * 100 / $RUNS" | bc)%"
    echo ""
    echo "To investigate:"
    echo "1. Check logs in /tmp/flaky-run-*.log"
    echo "2. Look for:"
    echo "   - Race conditions"
    echo "   - Timing-dependent assertions"
    echo "   - Shared state between tests"
    echo "   - Network/external dependencies"
    echo "   - Non-deterministic data (timestamps, random)"
    echo ""
    echo "Common fixes:"
    echo "   - Use explicit waits instead of sleeps"
    echo "   - Isolate test data with factories"
    echo "   - Mock external dependencies"
    echo "   - Use deterministic IDs and timestamps"
    exit 1
else
    echo ""
    echo -e "${GREEN}✓ No flaky tests detected after $RUNS runs${NC}"
    exit 0
fi
