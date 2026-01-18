#!/usr/bin/env bash
# =============================================================================
# BMAD Claude Skills - Remote Installer
#
# One-liner installation:
#   curl -fsSL https://raw.githubusercontent.com/chhudson/bmad-claude-skills/main/install.sh | bash
#
# With Beads integration:
#   curl -fsSL https://raw.githubusercontent.com/chhudson/bmad-claude-skills/main/install.sh | bash -s -- --with-beads
#
# =============================================================================

set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m'

REPO_URL="https://github.com/chhudson/bmad-claude-skills.git"
BRANCH="main"
INSTALL_BEADS=false

# -----------------------------------------------------------------------------
# Parse arguments
# -----------------------------------------------------------------------------
while [[ $# -gt 0 ]]; do
    case "$1" in
        --version|-v)
            BRANCH="$2"
            shift 2
            ;;
        --with-beads|-b)
            INSTALL_BEADS=true
            shift
            ;;
        --help|-h)
            echo ""
            echo "BMAD Claude Skills - Remote Installer"
            echo ""
            echo "Usage:"
            echo "  curl -fsSL https://raw.githubusercontent.com/chhudson/bmad-claude-skills/main/install.sh | bash"
            echo ""
            echo "Options:"
            echo "  -v, --version VERSION   Install specific version/tag (default: main)"
            echo "  -b, --with-beads        Also install Beads issue tracker"
            echo "  -h, --help              Show this help message"
            echo ""
            echo "Examples:"
            echo "  # Install BMAD only"
            echo "  curl -fsSL https://raw.githubusercontent.com/chhudson/bmad-claude-skills/main/install.sh | bash"
            echo ""
            echo "  # Install BMAD + Beads"
            echo "  curl -fsSL https://raw.githubusercontent.com/chhudson/bmad-claude-skills/main/install.sh | bash -s -- --with-beads"
            echo ""
            echo "  # Install specific version"
            echo "  curl -fsSL https://raw.githubusercontent.com/chhudson/bmad-claude-skills/main/install.sh | bash -s -- -v v6.1.0"
            echo ""
            exit 0
            ;;
        *)
            echo -e "${RED}Unknown option: $1${NC}"
            echo "Use --help for usage information"
            exit 1
            ;;
    esac
done

# -----------------------------------------------------------------------------
# Header
# -----------------------------------------------------------------------------
echo ""
echo -e "${BLUE}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}${BOLD}                 BMAD Claude Skills Installer${NC}"
echo -e "${BLUE}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "  ${BOLD}BMAD Repository:${NC}  github.com/chhudson/bmad-claude-skills"
echo -e "  ${BOLD}Branch/Tag:${NC}       $BRANCH"
echo -e "  ${BOLD}Install Beads:${NC}    $INSTALL_BEADS"
echo ""

# -----------------------------------------------------------------------------
# Check prerequisites
# -----------------------------------------------------------------------------
echo -e "${BLUE}[1/4]${NC} Checking prerequisites..."

if ! command -v git &> /dev/null; then
    echo -e "${RED}  ✗ git is required but not installed${NC}"
    echo ""
    echo "  Install git first:"
    echo "    macOS:  brew install git"
    echo "    Ubuntu: sudo apt install git"
    echo "    Windows: https://git-scm.com/download/win"
    exit 1
fi
echo -e "${GREEN}  ✓ git found${NC}"

# -----------------------------------------------------------------------------
# Download BMAD
# -----------------------------------------------------------------------------
echo -e "${BLUE}[2/4]${NC} Downloading BMAD Claude Skills..."

TEMP_DIR=$(mktemp -d)
trap "rm -rf $TEMP_DIR" EXIT

if ! git clone --depth 1 --branch "$BRANCH" "$REPO_URL" "$TEMP_DIR" 2>/dev/null; then
    echo -e "${RED}  ✗ Failed to clone repository${NC}"
    echo ""
    echo "  Check that:"
    echo "    - You have internet connectivity"
    echo "    - The branch/tag '$BRANCH' exists"
    exit 1
fi
echo -e "${GREEN}  ✓ Downloaded to temp directory${NC}"

# -----------------------------------------------------------------------------
# Install BMAD
# -----------------------------------------------------------------------------
echo -e "${BLUE}[3/4]${NC} Installing BMAD skills and commands..."

cd "$TEMP_DIR"
chmod +x install-v6.sh

if ! ./install-v6.sh; then
    echo -e "${RED}  ✗ BMAD installation failed${NC}"
    exit 1
fi

# -----------------------------------------------------------------------------
# Install Beads (optional)
# -----------------------------------------------------------------------------
if [[ "$INSTALL_BEADS" == "true" ]]; then
    echo ""
    echo -e "${BLUE}[3.5/4]${NC} Installing Beads issue tracker..."

    # Check if beads is already installed
    if command -v bd &> /dev/null; then
        echo -e "${GREEN}  ✓ Beads (bd) is already installed${NC}"
        bd --version 2>/dev/null || true
    else
        # Detect best installation method
        BEADS_INSTALLED=false

        # Try npm first (most common)
        if command -v npm &> /dev/null; then
            echo -e "  Installing via npm..."
            if npm install -g @beads/bd 2>/dev/null; then
                BEADS_INSTALLED=true
                echo -e "${GREEN}  ✓ Beads installed via npm${NC}"
            fi
        fi

        # Try Homebrew (macOS)
        if [[ "$BEADS_INSTALLED" == "false" ]] && command -v brew &> /dev/null; then
            echo -e "  Installing via Homebrew..."
            if brew install steveyegge/beads/bd 2>/dev/null; then
                BEADS_INSTALLED=true
                echo -e "${GREEN}  ✓ Beads installed via Homebrew${NC}"
            fi
        fi

        # Try Go
        if [[ "$BEADS_INSTALLED" == "false" ]] && command -v go &> /dev/null; then
            echo -e "  Installing via Go..."
            if go install github.com/steveyegge/beads/cmd/bd@latest 2>/dev/null; then
                BEADS_INSTALLED=true
                echo -e "${GREEN}  ✓ Beads installed via Go${NC}"
            fi
        fi

        # Fall back to curl installer
        if [[ "$BEADS_INSTALLED" == "false" ]]; then
            echo -e "  Installing via curl..."
            if curl -fsSL https://raw.githubusercontent.com/steveyegge/beads/main/scripts/install.sh | bash; then
                BEADS_INSTALLED=true
                echo -e "${GREEN}  ✓ Beads installed via curl${NC}"
            fi
        fi

        if [[ "$BEADS_INSTALLED" == "false" ]]; then
            echo -e "${YELLOW}  ⚠ Could not install Beads automatically${NC}"
            echo -e "    Install manually: https://github.com/steveyegge/beads"
        fi
    fi
fi

# -----------------------------------------------------------------------------
# Complete
# -----------------------------------------------------------------------------
echo -e "${BLUE}[4/4]${NC} Cleaning up..."
# Cleanup handled by trap

echo ""
echo -e "${GREEN}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}${BOLD}                    Installation Complete!${NC}"
echo -e "${GREEN}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "  ${BOLD}Next steps:${NC}"
echo ""
echo -e "  1. ${YELLOW}Restart Claude Code${NC} (skills load on startup)"
echo ""
echo -e "  2. Initialize BMAD in your project:"
echo -e "     ${BLUE}/workflow-init${NC}"
echo ""
echo -e "  3. Check status and get recommendations:"
echo -e "     ${BLUE}/workflow-status${NC}"
echo ""

if [[ "$INSTALL_BEADS" == "true" ]]; then
    echo -e "  4. Initialize Beads in your project (optional):"
    echo -e "     ${BLUE}bd init${NC}"
    echo ""
fi

if [[ "$INSTALL_BEADS" == "false" ]]; then
    echo -e "  ${BOLD}Optional:${NC} Add Beads for context persistence across sessions"
    echo -e "     Re-run with: ${BLUE}--with-beads${NC}"
    echo -e "     Or see: https://github.com/steveyegge/beads"
    echo ""
fi
