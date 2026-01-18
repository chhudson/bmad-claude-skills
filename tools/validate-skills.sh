#!/usr/bin/env bash
# =============================================================================
# BMAD Skill Validator
# Validates SKILL.md files against the BMAD skill schema
#
# Usage:
#   ./tools/validate-skills.sh              # Validate all skills
#   ./tools/validate-skills.sh <path>       # Validate specific SKILL.md
#   ./tools/validate-skills.sh --help       # Show help
#   ./tools/validate-skills.sh --verbose    # Verbose output
# =============================================================================

# Strict mode (but allow non-zero returns in subshells)
set -uo pipefail

# Disable history expansion to avoid issues with ! in patterns
set +H

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Valid tools list
VALID_TOOLS="Read Write Edit Bash Glob Grep TodoWrite WebSearch AskUserQuestion Task WebFetch NotebookEdit"

# Counters
TOTAL=0
PASSED=0
FAILED=0
WARNINGS=0

# Flags
VERBOSE=false

# =============================================================================
# Helper Functions
# =============================================================================

usage() {
    cat << 'EOF'
BMAD Skill Validator

Usage:
    validate-skills.sh [OPTIONS] [PATH]

Arguments:
    PATH    Path to specific SKILL.md file or directory containing skills
            Default: bmad-skills/

Options:
    -v, --verbose    Show detailed validation output
    -h, --help       Show this help message

Examples:
    ./tools/validate-skills.sh                    # Validate all skills in bmad-skills/
    ./tools/validate-skills.sh bmad-skills/developer     # Validate developer skill
    ./tools/validate-skills.sh path/to/SKILL.md          # Validate specific file
    ./tools/validate-skills.sh --verbose                 # Verbose output

Exit Codes:
    0    All validations passed
    1    One or more validations failed
    2    Invalid arguments or file not found
EOF
}

log_info() {
    printf "${BLUE}[INFO]${NC} %s\n" "$1"
}

log_pass() {
    printf "${GREEN}[PASS]${NC} %s\n" "$1"
}

log_fail() {
    printf "${RED}[FAIL]${NC} %s\n" "$1"
}

log_warn() {
    printf "${YELLOW}[WARN]${NC} %s\n" "$1"
}

log_verbose() {
    if [[ "$VERBOSE" == "true" ]]; then
        printf "       %s\n" "$1"
    fi
}

# =============================================================================
# YAML Frontmatter Extraction
# =============================================================================

extract_frontmatter() {
    local file="$1"

    # Check file starts with ---
    local first_line
    first_line=$(head -1 "$file")
    if [[ "$first_line" != "---" ]]; then
        echo ""
        return 1
    fi

    # Extract content between first and second ---
    awk '/^---$/{if(++n==1)next; if(n==2)exit} n==1{print}' "$file"
}

get_yaml_field() {
    local yaml="$1"
    local field="$2"

    printf '%s\n' "$yaml" | grep "^${field}:" | sed "s/^${field}:[[:space:]]*//" | sed 's/^"//' | sed 's/"$//'
}

# =============================================================================
# Validation Functions
# =============================================================================

validate_name() {
    local name="$1"

    # Check required
    if [[ -z "$name" ]]; then
        echo "name field is required"
        return 1
    fi

    # Check kebab-case pattern using grep with fixed string where possible
    if ! printf '%s\n' "$name" | grep -qE '^[a-z0-9]+(-[a-z0-9]+)*$'; then
        echo "name must be kebab-case (lowercase letters, numbers, hyphens only)"
        return 1
    fi

    # Check length
    if [[ ${#name} -gt 64 ]]; then
        echo "name must be 64 characters or less (found: ${#name})"
        return 1
    fi

    return 0
}

validate_description() {
    local desc="$1"

    # Check required
    if [[ -z "$desc" ]]; then
        echo "description field is required"
        return 1
    fi

    # Check length
    if [[ ${#desc} -gt 1024 ]]; then
        echo "description must be 1024 characters or less (found: ${#desc})"
        return 1
    fi

    # Check minimum length
    if [[ ${#desc} -lt 10 ]]; then
        echo "description must be at least 10 characters (found: ${#desc})"
        return 1
    fi

    return 0
}

validate_allowed_tools() {
    local tools="$1"

    # Check required
    if [[ -z "$tools" ]]; then
        echo "allowed-tools field is required"
        return 1
    fi

    # Parse comma-separated list (use subshell-style parsing to avoid IFS pollution)
    local tool_array=()
    local OLD_IFS="$IFS"
    IFS=','
    read -ra tool_array <<< "$tools"
    IFS="$OLD_IFS"

    for tool in "${tool_array[@]}"; do
        # Trim whitespace
        tool=$(printf '%s' "$tool" | xargs)

        # Handle Bash wildcards like Bash(git:*)
        local base_tool="${tool%%(*}"

        # Check if base tool is valid
        local valid=false
        for valid_tool in $VALID_TOOLS; do
            if [[ "$base_tool" == "$valid_tool" ]]; then
                valid=true
                break
            fi
        done

        if [[ "$valid" != "true" ]]; then
            echo "invalid tool: '$tool'. Valid tools: $VALID_TOOLS"
            return 1
        fi
    done

    return 0
}

validate_model() {
    local model="$1"

    # Optional field
    if [[ -z "$model" ]]; then
        return 0
    fi

    if [[ "$model" != "sonnet" && "$model" != "opus" && "$model" != "haiku" ]]; then
        echo "model must be one of: sonnet, opus, haiku (found: $model)"
        return 1
    fi

    return 0
}

validate_context() {
    local context="$1"

    # Optional field
    if [[ -z "$context" ]]; then
        return 0
    fi

    if [[ "$context" != "fork" && "$context" != "inherit" ]]; then
        echo "context must be one of: fork, inherit (found: $context)"
        return 1
    fi

    return 0
}

# =============================================================================
# Content Validation
# =============================================================================

validate_content() {
    local file="$1"
    local name="$2"
    local warnings=""

    # Check for H1 header
    if ! grep -q "^# " "$file"; then
        warnings="${warnings}\n  - Missing level 1 header (# Title)"
    fi

    # Check for Subprocess Strategy section (recommended but not required)
    if ! grep -qi "subprocess strategy" "$file"; then
        warnings="${warnings}\n  - Missing 'Subprocess Strategy' section (recommended)"
    fi

    # Check approximate token count (rough estimate: 1 token ≈ 4 chars)
    local char_count
    char_count=$(wc -c < "$file" | xargs)
    local approx_tokens=$((char_count / 4))

    if [[ $approx_tokens -gt 5000 ]]; then
        warnings="${warnings}\n  - File may exceed 5K token limit (~$approx_tokens tokens estimated)"
    fi

    if [[ -n "$warnings" ]]; then
        printf '%b' "$warnings"
        return 1
    fi

    return 0
}

# =============================================================================
# Main Validation Function
# =============================================================================

validate_skill() {
    local file="$1"
    local skill_name
    local has_errors=false
    local has_warnings=false

    TOTAL=$((TOTAL + 1))

    # Get skill directory name for reference
    skill_name=$(dirname "$file" | xargs basename)

    log_verbose "Validating: $file"

    # Extract frontmatter
    local frontmatter
    frontmatter=$(extract_frontmatter "$file")

    if [[ -z "$frontmatter" ]]; then
        log_fail "$skill_name: Missing or invalid YAML frontmatter (must start with ---)"
        FAILED=$((FAILED + 1))
        return 1
    fi

    # Extract fields
    local name desc tools model context
    name=$(get_yaml_field "$frontmatter" "name")
    desc=$(get_yaml_field "$frontmatter" "description")
    tools=$(get_yaml_field "$frontmatter" "allowed-tools")
    model=$(get_yaml_field "$frontmatter" "model")
    context=$(get_yaml_field "$frontmatter" "context")

    log_verbose "  name: $name"
    log_verbose "  description: ${desc:0:50}..."
    log_verbose "  allowed-tools: $tools"

    # Validate required fields
    local error

    if ! error=$(validate_name "$name"); then
        log_fail "$skill_name: $error"
        has_errors=true
    fi

    if ! error=$(validate_description "$desc"); then
        log_fail "$skill_name: $error"
        has_errors=true
    fi

    if ! error=$(validate_allowed_tools "$tools"); then
        log_fail "$skill_name: $error"
        has_errors=true
    fi

    # Validate optional fields
    if ! error=$(validate_model "$model"); then
        log_fail "$skill_name: $error"
        has_errors=true
    fi

    if ! error=$(validate_context "$context"); then
        log_fail "$skill_name: $error"
        has_errors=true
    fi

    # Validate content (warnings only)
    local content_warnings
    if ! content_warnings=$(validate_content "$file" "$name"); then
        log_warn "$skill_name: Content suggestions:$content_warnings"
        has_warnings=true
        WARNINGS=$((WARNINGS + 1))
    fi

    # Check name matches directory
    if [[ "$name" != "$skill_name" ]]; then
        log_warn "$skill_name: Skill name '$name' doesn't match directory name '$skill_name'"
        has_warnings=true
        WARNINGS=$((WARNINGS + 1))
    fi

    if [[ "$has_errors" == "true" ]]; then
        FAILED=$((FAILED + 1))
        return 1
    else
        log_pass "$skill_name"
        PASSED=$((PASSED + 1))
        return 0
    fi
}

# =============================================================================
# Main
# =============================================================================

main() {
    local target_path=""

    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case "$1" in
            -h|--help)
                usage
                exit 0
                ;;
            -v|--verbose)
                VERBOSE=true
                shift
                ;;
            -*)
                echo "Unknown option: $1"
                usage
                exit 2
                ;;
            *)
                target_path="$1"
                shift
                ;;
        esac
    done

    # Find script directory
    local script_dir
    script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    local repo_root
    repo_root="$(cd "$script_dir/.." && pwd)"

    # Determine what to validate
    local skill_files=()

    if [[ -z "$target_path" ]]; then
        # Default: validate all skills in bmad-skills/
        target_path="$repo_root/bmad-skills"
    fi

    if [[ -f "$target_path" ]]; then
        # Single file
        if [[ "$(basename "$target_path")" != "SKILL.md" ]]; then
            echo "Error: File must be named SKILL.md"
            exit 2
        fi
        skill_files+=("$target_path")
    elif [[ -d "$target_path" ]]; then
        # Directory - find all SKILL.md files
        while IFS= read -r -d '' file; do
            skill_files+=("$file")
        done < <(find "$target_path" -name "SKILL.md" -print0 | sort -z)
    else
        echo "Error: Path not found: $target_path"
        exit 2
    fi

    if [[ ${#skill_files[@]} -eq 0 ]]; then
        echo "No SKILL.md files found in: $target_path"
        exit 2
    fi

    # Header
    echo ""
    echo "========================================================================"
    echo "                    BMAD Skill Schema Validator                         "
    echo "========================================================================"
    echo ""
    log_info "Validating ${#skill_files[@]} skill file(s)..."
    echo ""

    # Validate each file
    for file in "${skill_files[@]}"; do
        validate_skill "$file" || true
    done

    # Summary
    echo ""
    echo "------------------------------------------------------------------------"
    echo "Summary:"
    echo "  Total:    $TOTAL"
    printf "  ${GREEN}Passed:   $PASSED${NC}\n"
    if [[ $FAILED -gt 0 ]]; then
        printf "  ${RED}Failed:   $FAILED${NC}\n"
    else
        echo "  Failed:   $FAILED"
    fi
    if [[ $WARNINGS -gt 0 ]]; then
        printf "  ${YELLOW}Warnings: $WARNINGS${NC}\n"
    else
        echo "  Warnings: $WARNINGS"
    fi
    echo "------------------------------------------------------------------------"
    echo ""

    # Exit code
    if [[ $FAILED -gt 0 ]]; then
        exit 1
    fi

    exit 0
}

main "$@"
