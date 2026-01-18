#!/bin/bash
# sync-architecture-to-beads.sh - Bridge architecture components with beads dependency tracking
#
# Usage: sync-architecture-to-beads.sh <component-name> <responsibility> [dependencies] [nfrs] [architecture-id]
#
# Creates a beads issue for an architecture component and links dependencies.
# Gracefully skips if bd is not installed or .beads/ doesn't exist.
#
# Arguments:
#   component-name  - Component name (e.g., "API Gateway", "Auth Service")
#   responsibility  - Brief description of what the component does
#   dependencies    - Optional: Comma-separated list of component beads IDs this depends on
#   nfrs            - Optional: Comma-separated NFR IDs addressed (e.g., "NFR-001,NFR-003")
#   architecture-id - Optional: beads architecture epic ID to link to
#
# Output (JSON):
#   { "beads_id": "bd-xxxx", "status": "created", "component": "API Gateway" }
#   { "beads_id": null, "status": "skipped", "reason": "..." }
#
# Exit codes:
#   0 - Success (issue created or gracefully skipped)
#   1 - Error (invalid arguments)

set -e

# Arguments
COMPONENT_NAME="${1:-}"
RESPONSIBILITY="${2:-}"
DEPENDENCIES="${3:-}"
NFRS="${4:-}"
ARCHITECTURE_ID="${5:-}"

# Validate required arguments
if [[ -z "$COMPONENT_NAME" || -z "$RESPONSIBILITY" ]]; then
    echo '{"beads_id": null, "status": "error", "reason": "Missing required arguments: component-name, responsibility"}'
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

# Build the bd create command
# Components are created as high priority (P1) since they're architectural foundations
BD_CMD="bd create"
BD_CMD="$BD_CMD \"[COMPONENT] $COMPONENT_NAME: $RESPONSIBILITY\""
BD_CMD="$BD_CMD -p 1"

# Add BMAD label to identify components created via BMAD
BD_CMD="$BD_CMD -l \"bmad:component\""

# Add NFR labels if provided
if [[ -n "$NFRS" ]]; then
    # Split comma-separated NFRs and add each as a label
    IFS=',' read -ra NFR_ARRAY <<< "$NFRS"
    for nfr in "${NFR_ARRAY[@]}"; do
        # Trim whitespace and convert to lowercase
        nfr_clean=$(echo "$nfr" | xargs | tr '[:upper:]' '[:lower:]')
        BD_CMD="$BD_CMD -l \"nfr:$nfr_clean\""
    done
fi

# Execute bd create and capture the issue ID
BEADS_OUTPUT=$(eval "$BD_CMD" 2>&1) || {
    echo "{\"beads_id\": null, \"status\": \"error\", \"reason\": \"bd create failed: $BEADS_OUTPUT\"}"
    exit 0
}

# Extract the beads ID from output (format: bd-xxxx)
BEADS_ID=$(echo "$BEADS_OUTPUT" | grep -oE 'bd-[a-z0-9]+' | head -1)

if [[ -z "$BEADS_ID" ]]; then
    # Try alternative: beads might output just the ID
    BEADS_ID=$(echo "$BEADS_OUTPUT" | grep -oE '^[a-z0-9-]+$' | head -1)
fi

if [[ -z "$BEADS_ID" ]]; then
    echo "{\"beads_id\": null, \"status\": \"warning\", \"reason\": \"Issue created but could not extract ID\", \"output\": \"$BEADS_OUTPUT\"}"
    exit 0
fi

# If dependencies provided, add blocking relationships
# A component blocks dependent components (dependency must be completed first)
if [[ -n "$DEPENDENCIES" ]]; then
    IFS=',' read -ra DEP_ARRAY <<< "$DEPENDENCIES"
    for dep_id in "${DEP_ARRAY[@]}"; do
        dep_id_clean=$(echo "$dep_id" | xargs)
        if [[ -n "$dep_id_clean" && "$dep_id_clean" =~ ^bd- ]]; then
            # This component depends on dep_id, so dep_id blocks this component
            bd dep add "$dep_id_clean" blocks "$BEADS_ID" 2>/dev/null || true
        fi
    done
fi

# If architecture ID provided, link this component to the architecture epic
if [[ -n "$ARCHITECTURE_ID" ]]; then
    bd dep add "$BEADS_ID" blocks "$ARCHITECTURE_ID" 2>/dev/null || true
fi

# Output success
echo "{\"beads_id\": \"$BEADS_ID\", \"status\": \"created\", \"component\": \"$COMPONENT_NAME\"}"
