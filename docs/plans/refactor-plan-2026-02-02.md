# Refactoring Plan: Meta-prompt-LLM

**Date**: 2026-02-02
**Based on**: Codebase Analysis Report (same date)
**Status**: PENDING USER APPROVAL

---

## Executive Summary

This plan addresses 6 identified issues from the codebase analysis, organized into 3 phases with clear deliverables and estimated effort.

**Total estimated effort**: 40-60 hours
**Recommended approach**: Incremental, one phase at a time

---

## Phase 1: Foundation Improvements (Priority: HIGH)

**Goal**: Stabilize core infrastructure and reduce technical debt

### 1.1 Extract YAML Parsing Module

**Issue**: `generate.sh:160-225` - Fragile regex-based YAML parsing

**Current state**:
```bash
# Line 160 - Simple regex that fails on edge cases
yaml_get() {
    grep -E "^${key}:" "${file}" | sed "s/^${key}:[[:space:]]*//"
}
```

**Proposed solution**:
```bash
# Create: .ai/lib/yaml-parser.sh
# Option A: Use yq if available (preferred)
# Option B: Fallback to Python validation
yaml_get_safe() {
    if command -v yq &>/dev/null; then
        yq -r ".$key" "$file"
    else
        # Current regex as fallback with validation
        python3 -c "import yaml; yaml.safe_load(open('$file'))" 2>/dev/null || {
            log_error "Invalid YAML: $file"
            return 1
        }
        grep -E "^${key}:" "${file}" | sed "s/^${key}:[[:space:]]*//"
    fi
}
```

**Files to modify**:
- [ ] `.ai/generate.sh` - Extract YAML functions
- [ ] `.ai/lib/yaml-parser.sh` (new) - Centralized parsing
- [ ] Add yq to recommended dependencies

**Estimated effort**: 4-6 hours
**Risk**: Low (backward compatible)

---

### 1.2 Implement Manifest Validation

**Issue**: `data/manifest.yaml` integrity hashes unused

**Current state**: Manifest exists but never validated

**Proposed solution**:
```bash
# Add to generate.sh startup
validate_manifest() {
    local manifest="${DATA_DIR}/manifest.yaml"
    [[ ! -f "$manifest" ]] && return 0

    while IFS=: read -r file hash; do
        local actual=$(sha256sum "${DATA_DIR}/${file}" | cut -d' ' -f1)
        if [[ "$actual" != "$hash" ]]; then
            log_warn "Integrity mismatch: $file"
            log_warn "  Expected: $hash"
            log_warn "  Actual:   $actual"
        fi
    done < <(yq '.integrity | to_entries | .[] | "\(.key):\(.value.hash)"' "$manifest")
}
```

**Files to modify**:
- [ ] `.ai/generate.sh` - Add validation at startup
- [ ] `prompts/fr/metametaprompts/data/manifest.yaml` - Update hashes

**Estimated effort**: 2-3 hours
**Risk**: Low

---

## Phase 2: Hook System Refactoring (Priority: HIGH)

### 2.1 Extract Hook Generation State Machine

**Issue**: `generate.sh:1089-1310` - 222-line state machine with 13+ variables

**Current state**: Complex, hard to test, error-prone

**Proposed solution**: Split into 3 phases

```
Phase A: Parse hooks.yaml → Intermediate JSON
Phase B: Transform for platform
Phase C: Write platform config
```

**New structure**:
```
.ai/lib/
├── yaml-parser.sh      # From 1.1
├── hooks-parser.sh     # Parse hooks.yaml
├── hooks-transformer.sh # Platform-specific transforms
└── platform-writers/
    ├── claude.sh
    ├── cursor.sh
    └── opencode.sh
```

**Files to modify**:
- [ ] `.ai/generate.sh` - Extract `generate_claude_hooks()`
- [ ] `.ai/lib/hooks-parser.sh` (new)
- [ ] `.ai/lib/hooks-transformer.sh` (new)
- [ ] `.ai/lib/platform-writers/*.sh` (new)

**Estimated effort**: 12-16 hours
**Risk**: Medium (requires careful testing)

---

### 2.2 Create Platform Capability Mapping

**Issue**: Inconsistent feature support across platforms

**Proposed solution**:
```yaml
# .ai/data/platform-capabilities.yaml
platforms:
  claude-code:
    events: [SessionStart, PreToolUse, PostToolUse, UserPromptSubmit, Notification, Stop]
    supports_subagents: true
    supports_hooks: true

  cursor:
    events: [PreToolUse, PostToolUse, UserPromptSubmit]
    supports_subagents: false
    supports_hooks: true

  opencode:
    events: []
    supports_subagents: false
    supports_hooks: false
    notes: "Requires oh-my-opencode plugin"
```

**Files to modify**:
- [ ] `.ai/data/platform-capabilities.yaml` (new)
- [ ] `.ai/generate.sh` - Use capabilities map

**Estimated effort**: 4-5 hours
**Risk**: Low

---

## Phase 3: Documentation & Quality (Priority: MEDIUM)

### 3.1 Bilingual Documentation Sync Check

**Issue**: No automated detection of translation drift

**Proposed solution**:
```bash
# Add: --check-docs flag to generate.sh
check_docs_sync() {
    local mismatches=0
    for en_doc in docs/en/*.md; do
        local fr_doc="${en_doc/\/en\//\/fr\/}"
        if [[ ! -f "$fr_doc" ]]; then
            log_warn "Missing FR: $fr_doc"
            ((mismatches++))
        else
            local en_hash=$(md5sum "$en_doc" | cut -d' ' -f1)
            local fr_hash=$(md5sum "$fr_doc" | cut -d' ' -f1)
            # Compare last-modified or content structure
            # (exact match not expected, just structure)
        fi
    done
    return $mismatches
}
```

**Files to modify**:
- [ ] `.ai/generate.sh` - Add `--check-docs` flag
- [ ] Update translator skill to call this check

**Estimated effort**: 3-4 hours
**Risk**: Low

---

### 3.2 Add State Machine Documentation

**Issue**: Hook parsing logic undocumented

**Proposed solution**:
```markdown
# Add to: docs/en/architecture.md

## Hook Parsing State Machine

States:
1. IDLE - Looking for event declaration
2. IN_EVENT - Inside event block, looking for hooks
3. IN_HOOK - Inside hook definition
4. IN_MULTILINE - Processing multiline command

Transitions:
- IDLE → IN_EVENT: When `^[A-Z][a-zA-Z]+:` matched
- IN_EVENT → IN_HOOK: When `  - ` hook marker found
- IN_HOOK → IN_MULTILINE: When `command: |` found
- IN_MULTILINE → IN_HOOK: When indent decreases
```

**Files to modify**:
- [ ] `docs/en/architecture.md` - Add state machine docs
- [ ] `docs/fr/architecture.md` - French translation
- [ ] `.ai/generate.sh` - Add inline comments

**Estimated effort**: 2-3 hours
**Risk**: Low

---

## Implementation Order

```
Week 1: Phase 1 (Foundation)
├── Day 1-2: 1.1 YAML Parsing Module
└── Day 3: 1.2 Manifest Validation

Week 2-3: Phase 2 (Hooks)
├── Day 1-4: 2.1 Hook State Machine Extraction
└── Day 5: 2.2 Platform Capability Mapping

Week 4: Phase 3 (Quality)
├── Day 1-2: 3.1 Docs Sync Check
└── Day 3: 3.2 State Machine Documentation
```

---

## Success Criteria

### Phase 1 Complete
- [ ] `yq` used when available, graceful fallback otherwise
- [ ] Manifest validation runs at startup
- [ ] No regressions in existing generation

### Phase 2 Complete
- [ ] Hook parsing in separate module
- [ ] Each platform has dedicated writer
- [ ] Capabilities documented in YAML

### Phase 3 Complete
- [ ] `--check-docs` flag functional
- [ ] State machine fully documented
- [ ] All tests pass

---

## Risks & Mitigations

| Risk | Probability | Impact | Mitigation |
|------|-------------|--------|------------|
| Hook parsing regression | Medium | High | Create test suite before refactoring |
| YAML parser edge cases | Low | Medium | Keep regex fallback |
| Platform writer inconsistency | Low | Low | Share common code |

---

## Rollback Plan

Each phase is independently deployable. If issues arise:
1. Revert commits for that phase
2. Previous functionality remains intact
3. Document what failed for future attempt

---

## Approval Required

**Before proceeding, please confirm**:
1. Do you approve this refactoring plan?
2. Which phase(s) should be prioritized?
3. Any constraints on timing or scope?

---

*Generated by codebase-analyst + prompt-engineer skills*
*Session: https://claude.ai/code/session_01JNmEr5MnX8wWXY3U2d2JgD*
