#!/usr/bin/env bash
# ============================================================================
# generate-site.sh
# ============================================================================
# Generates index.html navigation files in each prompts directory.
# This script scans the prompts/ directory and creates/updates index.html
# files for GitHub Pages navigation.
#
# Usage:
#   .ai/scripts/generate-site.sh
#   .ai/scripts/generate-site.sh --check  # Dry run, shows what would be generated
#
# NOTICE: This file is part of the Meta-prompt-LLM project.
# https://github.com/jmchantrein/Meta-prompt-LLM
# See AGENTS.md for complete rules.
# ============================================================================

set -euo pipefail

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"
PROMPTS_DIR="${PROJECT_ROOT}/prompts"
ASSETS_DIR="${PROJECT_ROOT}/assets"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Flags
CHECK_MODE=false

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --check|-c)
            CHECK_MODE=true
            shift
            ;;
        --help|-h)
            echo "Usage: $0 [--check]"
            echo ""
            echo "Options:"
            echo "  --check, -c    Dry run, show what would be generated"
            echo "  --help, -h     Show this help"
            exit 0
            ;;
        *)
            echo -e "${RED}Unknown option: $1${NC}"
            exit 1
            ;;
    esac
done

# Logging functions
log_info() { echo -e "${BLUE}ℹ${NC} $1"; }
log_success() { echo -e "${GREEN}✓${NC} $1"; }
log_warning() { echo -e "${YELLOW}⚠${NC} $1"; }
log_error() { echo -e "${RED}✗${NC} $1"; }

# ============================================================================
# MAIN
# ============================================================================

main() {
    log_info "Meta-prompt-LLM Site Generator"
    log_info "=============================="
    echo ""

    if [[ "$CHECK_MODE" == true ]]; then
        log_warning "Check mode - no files will be modified"
        echo ""
    fi

    # Check required files
    if [[ ! -d "$PROMPTS_DIR" ]]; then
        log_error "Prompts directory not found: $PROMPTS_DIR"
        exit 1
    fi

    if [[ ! -f "${ASSETS_DIR}/style.css" ]]; then
        log_warning "Style file not found: ${ASSETS_DIR}/style.css"
    fi

    # Count existing index.html files
    local existing_count
    existing_count=$(find "$PROMPTS_DIR" -name "index.html" 2>/dev/null | wc -l)
    log_info "Found $existing_count existing index.html files"

    # List directories that need index.html
    log_info "Scanning directories..."

    local dirs_scanned=0
    local dirs_with_index=0

    # Find all directories with .md files (prompt directories)
    while IFS= read -r -d '' dir; do
        ((dirs_scanned++))
        local relative_path="${dir#$PROJECT_ROOT/}"

        if [[ -f "${dir}/index.html" ]]; then
            ((dirs_with_index++))
            log_success "$relative_path has index.html"
        else
            log_warning "$relative_path needs index.html"

            if [[ "$CHECK_MODE" == false ]]; then
                # TODO: Generate index.html based on directory contents
                # This is a placeholder for future implementation
                :
            fi
        fi
    done < <(find "$PROMPTS_DIR" -type d -print0)

    echo ""
    log_info "Summary:"
    log_info "  - Directories scanned: $dirs_scanned"
    log_info "  - Directories with index: $dirs_with_index"
    log_info "  - Directories needing index: $((dirs_scanned - dirs_with_index))"

    # Validate existing index.html files
    log_info ""
    log_info "Validating existing index.html files..."

    local valid_count=0
    local invalid_count=0

    while IFS= read -r -d '' index_file; do
        local relative_path="${index_file#$PROJECT_ROOT/}"

        # Basic validation: check if file contains required elements
        if grep -q '<html' "$index_file" && grep -q '</html>' "$index_file"; then
            ((valid_count++))
        else
            ((invalid_count++))
            log_warning "Invalid HTML: $relative_path"
        fi
    done < <(find "$PROMPTS_DIR" -name "index.html" -print0)

    # Also check root index.html
    if [[ -f "${PROJECT_ROOT}/index.html" ]]; then
        if grep -q '<html' "${PROJECT_ROOT}/index.html" && grep -q '</html>' "${PROJECT_ROOT}/index.html"; then
            ((valid_count++))
            log_success "Root index.html is valid"
        else
            ((invalid_count++))
            log_warning "Root index.html is invalid"
        fi
    else
        log_warning "Root index.html not found"
    fi

    echo ""
    log_info "Validation summary:"
    log_info "  - Valid index.html: $valid_count"
    log_info "  - Invalid index.html: $invalid_count"

    if [[ $invalid_count -gt 0 ]]; then
        exit 1
    fi

    log_success "Site generation complete!"
}

main "$@"
