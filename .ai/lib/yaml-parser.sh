#!/usr/bin/env bash
# ============================================================================
# yaml-parser.sh - YAML parsing utilities for generate.sh
# ============================================================================
# Provides safe YAML parsing with yq support and regex fallback.
# Part of Phase 1.1 refactoring (see docs/plans/refactor-plan-2026-02-02.md)
#
# Usage:
#   source .ai/lib/yaml-parser.sh
#   yaml_get "file.yaml" "key"
#   yaml_get_block "file.yaml" "instructions.role"
#   yaml_get_list "file.yaml" "tags"
#
# ============================================================================

# Detect if yq is available (preferred for complex YAML)
YAML_PARSER_HAS_YQ=false
if command -v yq &>/dev/null; then
    # Check if it's the Go version (mikefarah/yq) or Python version
    if yq --version 2>&1 | grep -q "mikefarah"; then
        YAML_PARSER_HAS_YQ=true
    fi
fi

# Detect if python3 with yaml is available (for validation)
YAML_PARSER_HAS_PYTHON=false
if command -v python3 &>/dev/null; then
    if python3 -c "import yaml" 2>/dev/null; then
        YAML_PARSER_HAS_PYTHON=true
    fi
fi

# ----------------------------------------------------------------------------
# Validation
# ----------------------------------------------------------------------------

# Validate YAML file syntax
# Returns 0 if valid, 1 if invalid
yaml_validate() {
    local file="$1"

    if [[ ! -f "${file}" ]]; then
        echo "Error: File not found: ${file}" >&2
        return 1
    fi

    if [[ "${YAML_PARSER_HAS_YQ}" == "true" ]]; then
        yq eval '.' "${file}" >/dev/null 2>&1
        return $?
    elif [[ "${YAML_PARSER_HAS_PYTHON}" == "true" ]]; then
        python3 -c "import yaml; yaml.safe_load(open('${file}'))" 2>/dev/null
        return $?
    else
        # No validation available, assume valid
        return 0
    fi
}

# ----------------------------------------------------------------------------
# Value extraction
# ----------------------------------------------------------------------------

# Extract a simple value from YAML
# Supports: key: value, key: "value", key: 'value'
yaml_get() {
    local file="$1"
    local key="$2"

    if [[ ! -f "${file}" ]]; then
        return 1
    fi

    if [[ "${YAML_PARSER_HAS_YQ}" == "true" ]]; then
        # Use yq for reliable extraction
        local result
        result=$(yq eval ".${key} // \"\"" "${file}" 2>/dev/null)
        # yq returns "null" for missing keys
        if [[ "${result}" == "null" ]]; then
            echo ""
        else
            echo "${result}"
        fi
    else
        # Fallback to regex (handles basic cases)
        grep -E "^${key}:" "${file}" 2>/dev/null | head -1 | \
            sed "s/^${key}:[[:space:]]*//" | \
            sed 's/^"//' | sed 's/"$//' | \
            sed "s/^'//" | sed "s/'$//"
    fi
}

# Extract a nested value (e.g., "instructions.role")
yaml_get_nested() {
    local file="$1"
    local key="$2"

    if [[ "${YAML_PARSER_HAS_YQ}" == "true" ]]; then
        local result
        result=$(yq eval ".${key} // \"\"" "${file}" 2>/dev/null)
        if [[ "${result}" == "null" ]]; then
            echo ""
        else
            echo "${result}"
        fi
    else
        # For nested keys without yq, we need the block parser
        # This is a simplified version that only works for specific patterns
        echo ""
    fi
}

# Extract multiline value (for key: | blocks)
yaml_get_block() {
    local file="$1"
    local key="$2"

    if [[ ! -f "${file}" ]]; then
        return 1
    fi

    if [[ "${YAML_PARSER_HAS_YQ}" == "true" ]]; then
        yq eval ".${key} // \"\"" "${file}" 2>/dev/null
    else
        # Fallback to regex-based block extraction
        local in_block=false
        local indent=""
        local result=""

        while IFS= read -r line; do
            if [[ "${in_block}" == "true" ]]; then
                # Check if we've exited the block
                if [[ -n "${line}" && ! "${line}" =~ ^[[:space:]] ]]; then
                    break
                fi
                if [[ -n "${line}" ]]; then
                    result+="${line#${indent}}"$'\n'
                else
                    result+=$'\n'
                fi
            elif [[ "${line}" =~ ^${key}:[[:space:]]*\|[[:space:]]*$ ]]; then
                in_block=true
                # Detect indentation from next non-empty line
                while IFS= read -r next_line; do
                    if [[ -n "${next_line}" && "${next_line}" =~ ^([[:space:]]+) ]]; then
                        indent="${BASH_REMATCH[1]}"
                        result+="${next_line#${indent}}"$'\n'
                        break
                    fi
                done
            fi
        done < "${file}"

        echo "${result}"
    fi
}

# Get list of items from YAML array
yaml_get_list() {
    local file="$1"
    local key="$2"

    if [[ ! -f "${file}" ]]; then
        return 1
    fi

    if [[ "${YAML_PARSER_HAS_YQ}" == "true" ]]; then
        yq eval ".${key}[]? // \"\"" "${file}" 2>/dev/null | grep -v '^$'
    else
        # Fallback to regex-based list extraction
        local in_list=false

        while IFS= read -r line; do
            if [[ "${in_list}" == "true" ]]; then
                if [[ "${line}" =~ ^[[:space:]]+-[[:space:]]+(.*) ]]; then
                    local item="${BASH_REMATCH[1]}"
                    # Remove quotes if present
                    item="${item#\"}"
                    item="${item%\"}"
                    item="${item#\'}"
                    item="${item%\'}"
                    echo "${item}"
                elif [[ -n "${line}" && ! "${line}" =~ ^[[:space:]] ]]; then
                    break
                fi
            elif [[ "${line}" =~ ^${key}:[[:space:]]*$ ]]; then
                in_list=true
            fi
        done < "${file}"
    fi
}

# ----------------------------------------------------------------------------
# Utility functions
# ----------------------------------------------------------------------------

# Check if a key exists in YAML file
yaml_has_key() {
    local file="$1"
    local key="$2"

    if [[ "${YAML_PARSER_HAS_YQ}" == "true" ]]; then
        local result
        result=$(yq eval ".${key}" "${file}" 2>/dev/null)
        [[ "${result}" != "null" && -n "${result}" ]]
    else
        grep -qE "^${key}:" "${file}" 2>/dev/null
    fi
}

# Get all top-level keys
yaml_get_keys() {
    local file="$1"

    if [[ "${YAML_PARSER_HAS_YQ}" == "true" ]]; then
        yq eval 'keys | .[]' "${file}" 2>/dev/null
    else
        grep -E "^[a-zA-Z_][a-zA-Z0-9_-]*:" "${file}" 2>/dev/null | sed 's/:.*//'
    fi
}

# Print parser status (for debugging)
yaml_parser_status() {
    echo "YAML Parser Status:"
    echo "  yq available: ${YAML_PARSER_HAS_YQ}"
    echo "  python3+yaml available: ${YAML_PARSER_HAS_PYTHON}"
    if [[ "${YAML_PARSER_HAS_YQ}" == "true" ]]; then
        echo "  yq version: $(yq --version 2>&1 | head -1)"
    fi
}
