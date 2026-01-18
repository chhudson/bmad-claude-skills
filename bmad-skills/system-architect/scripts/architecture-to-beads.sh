#!/bin/bash
# architecture-to-beads.sh - Create beads architecture epic (molecule)
#
# Usage: architecture-to-beads.sh <project-name> <pattern> [component-count]
#
# Creates a beads epic to represent the architecture document.
# Components can then be linked to this epic via sync-architecture-to-beads.sh.
#
# Arguments:
#   project-name    - Project name (e.g., "ecommerce-platform")
#   pattern         - Architecture pattern (e.g., "Modular Monolith", "Microservices")
#   component-count - Optional: Number of components in the architecture
#
# Output (JSON):
#   { "architecture_id": "bd-xxxx", "status": "created", "project": "ecommerce-platform" }
#   { "architecture_id": null, "status": "skipped", "reason": "..." }
#
# Exit codes:
#   0 - Success (epic created or gracefully skipped)
#   1 - Error (invalid arguments)

set -e

# Arguments
PROJECT_NAME="${1:-}"
PATTERN="${2:-}"
COMPONENT_COUNT="${3:-0}"

# Validate required arguments
if [[ -z "$PROJECT_NAME" || -z "$PATTERN" ]]; then
    echo '{"architecture_id": null, "status": "error", "reason": "Missing required arguments: project-name, pattern"}'
    exit 1
fi

# Check if bd command is available
if ! command -v bd &> /dev/null; then
    echo '{"architecture_id": null, "status": "skipped", "reason": "bd command not installed"}'
    exit 0
fi

# Check if .beads/ directory exists
if [[ ! -d ".beads" ]]; then
    echo '{"architecture_id": null, "status": "skipped", "reason": ".beads/ directory not found"}'
    exit 0
fi

# Build the bd create command for architecture epic
BD_CMD="bd create"
BD_CMD="$BD_CMD \"[ARCHITECTURE] $PROJECT_NAME: $PATTERN\""
BD_CMD="$BD_CMD -t epic"
BD_CMD="$BD_CMD -p 1"

# Add identifying labels
BD_CMD="$BD_CMD -l \"bmad:architecture\""
BD_CMD="$BD_CMD -l \"pattern:$(echo "$PATTERN" | tr '[:upper:]' '[:lower:]' | tr ' ' '-')\""

# Add component count if provided
if [[ "$COMPONENT_COUNT" -gt 0 ]]; then
    BD_CMD="$BD_CMD -l \"components:$COMPONENT_COUNT\""
fi

# Execute bd create and capture the epic ID
BEADS_OUTPUT=$(eval "$BD_CMD" 2>&1) || {
    echo "{\"architecture_id\": null, \"status\": \"error\", \"reason\": \"bd create failed: $BEADS_OUTPUT\"}"
    exit 0
}

# Extract the beads ID from output (format: bd-xxxx)
BEADS_ID=$(echo "$BEADS_OUTPUT" | grep -oE 'bd-[a-z0-9]+' | head -1)

if [[ -z "$BEADS_ID" ]]; then
    # Try alternative: beads might output just the ID
    BEADS_ID=$(echo "$BEADS_OUTPUT" | grep -oE '^[a-z0-9-]+$' | head -1)
fi

if [[ -z "$BEADS_ID" ]]; then
    echo "{\"architecture_id\": null, \"status\": \"warning\", \"reason\": \"Epic created but could not extract ID\", \"output\": \"$BEADS_OUTPUT\"}"
    exit 0
fi

# Output success
echo "{\"architecture_id\": \"$BEADS_ID\", \"status\": \"created\", \"project\": \"$PROJECT_NAME\", \"pattern\": \"$PATTERN\"}"
