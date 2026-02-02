# Architecture and Data Flow

> [Version française](../fr/architecture.md)

## Overview

Meta-prompt-LLM uses a **single source of truth** architecture where all configuration data lives in one place and is synchronized/generated to platform-specific formats.

## Architecture Diagram

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                         SOURCE OF TRUTH                                      │
│                                                                              │
│   prompts/fr/metametaprompts/data/                                          │
│   ├── manifest.yaml          # Central index (versions, hashes, URLs)       │
│   ├── rules/                                                                 │
│   │   └── rules.yaml         # AGENTS.md rules in YAML                      │
│   ├── skills/                                                                │
│   │   └── *.yaml             # Skill definitions (9 skills)                 │
│   ├── hooks/                                                                 │
│   │   └── hooks.yaml         # Lifecycle hooks configuration                │
│   └── prompts/                                                               │
│       └── */                 # Versioned prompts (EN + FR)                  │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
                                      │
                                      │ data-sync (manual or automated)
                                      ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                         LOCAL WORKING COPY                                   │
│                                                                              │
│   .ai/                                                                       │
│   ├── skills/*.yaml          # Skills (synced from data/)                   │
│   ├── hooks/hooks.yaml       # Hooks (synced from data/)                    │
│   ├── generate.sh            # Multi-platform generator                     │
│   ├── MEMORY.md              # Persistent project memory                    │
│   └── sources.yaml           # Reference URLs                               │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
                                      │
                                      │ generate.sh --force
                                      ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                         GENERATED FILES (Platform-Specific)                  │
│                                                                              │
│   ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐            │
│   │   AGENTS.md     │  │   CLAUDE.md     │  │  .cursorrules   │            │
│   │   (Standard)    │  │ (Claude Code)   │  │    (Cursor)     │            │
│   └─────────────────┘  └─────────────────┘  └─────────────────┘            │
│                                                                              │
│   ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐            │
│   │.claude/         │  │.continuerc.json │  │.aider.conf.yml  │            │
│   │├── settings.json│  │ (Continue.dev)  │  │    (Aider)      │            │
│   │└── agents/*.md  │  └─────────────────┘  └─────────────────┘            │
│   └─────────────────┘                                                        │
│                                                                              │
│   ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐            │
│   │ollama/          │  │.opencode/       │  │.codex/          │            │
│   │└── Modelfile.*  │  │└── agents/*.md  │  │└── agents/*.md  │            │
│   │    (Ollama)     │  │   (OpenCode)    │  │   (Codex CLI)   │            │
│   └─────────────────┘  └─────────────────┘  └─────────────────┘            │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
```

## Data Flow Rules

### Rule 1: Single Source of Truth

**All modifications MUST be made in `data/` first.**

```
✅ CORRECT:
   1. Edit data/skills/translator.yaml
   2. Run data-sync to copy to .ai/skills/
   3. Run generate.sh to update platform files

❌ WRONG:
   1. Edit .ai/skills/translator.yaml directly
   (Changes will be overwritten by next data-sync)
```

### Rule 2: Synchronization Direction

```
data/ ──────────────────────► .ai/ ──────────────────────► platform files
       data-sync (copy)              generate.sh (transform)

NEVER: .ai/ → data/ (reverse sync is forbidden)
```

### Rule 3: Modification Workflow

```
┌─────────────┐    ┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│   Modify    │    │   Update    │    │  data-sync  │    │ generate.sh │
│   data/     │───►│  manifest   │───►│  to .ai/    │───►│   --force   │
│             │    │   (hash)    │    │             │    │             │
└─────────────┘    └─────────────┘    └─────────────┘    └─────────────┘
```

## Component Details

### Source of Truth (`data/`)

| File | Purpose |
|------|---------|
| `manifest.yaml` | Central index with SHA256 hashes for integrity verification |
| `rules/rules.yaml` | AGENTS.md rules in structured YAML format |
| `skills/*.yaml` | Skill definitions (role, guidelines, triggers, constraints) |
| `hooks/hooks.yaml` | Lifecycle hooks (guardrails, automation, audit) |
| `prompts/*/` | Versioned prompts with EN/FR translations |

### Working Copy (`.ai/`)

| File | Purpose |
|------|---------|
| `skills/*.yaml` | Local copy of skills (synced from data/) |
| `hooks/hooks.yaml` | Local copy of hooks (synced from data/) |
| `generate.sh` | Multi-platform configuration generator |
| `MEMORY.md` | Persistent project memory (read at session start) |
| `sources.yaml` | Reference URLs for documentation |

### Generated Files

| Platform | Files Generated |
|----------|----------------|
| Standard | `AGENTS.md` |
| Claude Code | `CLAUDE.md`, `.claude/settings.json`, `.claude/agents/*.md` |
| Cursor | `.cursorrules` |
| Continue.dev | `.continuerc.json` |
| Aider | `.aider.conf.yml` |
| Ollama | `ollama/Modelfile.*` |
| OpenCode | `.opencode/agents/*.md` |
| Codex CLI | `.codex/agents/*.md` |

## Hooks System

### Lifecycle Events

```
┌──────────────────┐
│ UserPromptSubmit │ ◄── User sends a message
└────────┬─────────┘
         │
         ▼
┌──────────────────┐
│   PreToolUse     │ ◄── Before tool executes (can BLOCK)
└────────┬─────────┘
         │
         ▼
┌──────────────────┐
│  [Tool Executes] │
└────────┬─────────┘
         │
         ▼
┌──────────────────┐
│   PostToolUse    │ ◄── After tool completes
└────────┬─────────┘
         │
         ▼
┌──────────────────┐
│      Stop        │ ◄── Session ends
└──────────────────┘
```

### Hook Types

| Type | Purpose | Example |
|------|---------|---------|
| `command` | Execute shell command | Check if MEMORY.md exists |
| `prompt` | Ask yes/no confirmation | Confirm before `rm` command |
| `agent` | Spawn subagent for validation | Run inclusivity-reviewer |

### Configured Hooks

| Event | Hook | Action |
|-------|------|--------|
| `UserPromptSubmit` | load-memory | Remind to read MEMORY.md |
| `PreToolUse` | protect-env | Confirm before writing .env files |
| `PreToolUse` | confirm-delete | Confirm before `rm` commands |
| `PreToolUse` | confirm-force-push | Confirm before `git push --force` |
| `PostToolUse` | auto-generate | Run generate.sh after skill changes |
| `PostToolUse` | inclusivity-reminder | Remind about FR inclusive writing |
| `Stop` | memory-reminder | Remind to update MEMORY.md |

## Quick Reference

### Adding a New Skill

```bash
# 1. Create skill in data/ (source of truth)
cp data/skills/_TEMPLATE.yaml data/skills/new-skill.yaml
edit data/skills/new-skill.yaml

# 2. Update manifest.yaml
sha256sum data/skills/new-skill.yaml  # Get hash
edit data/manifest.yaml               # Add entry

# 3. Sync to .ai/
cp data/skills/new-skill.yaml .ai/skills/

# 4. Regenerate platform files
.ai/generate.sh --force
```

### Modifying Hooks

```bash
# 1. Edit in data/ (source of truth)
edit data/hooks/hooks.yaml

# 2. Update manifest.yaml hash
sha256sum data/hooks/hooks.yaml
edit data/manifest.yaml

# 3. Sync to .ai/
cp data/hooks/hooks.yaml .ai/hooks/

# 4. Regenerate
.ai/generate.sh --force
```

### Checking Workflow Status

```bash
# Check if regeneration needed
.ai/generate.sh --check

# Force regeneration
.ai/generate.sh --force --verbose

# Dry run (preview changes)
.ai/generate.sh --dry-run
```

## Hook Parsing State Machine

The `generate_claude_hooks()` function in `.ai/generate.sh` uses a state machine to parse the YAML hooks file and generate JSON configuration.

### States

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                           HOOK PARSING STATE MACHINE                         │
│                                                                              │
│   ┌──────────┐        Event match          ┌──────────────┐                 │
│   │   IDLE   │ ──────────────────────────► │   IN_EVENT   │                 │
│   │          │    (SessionStart:)          │              │                 │
│   └──────────┘                             └───────┬──────┘                 │
│        ▲                                           │                         │
│        │ Top-level key                             │ Hook marker             │
│        │ (exits event)                             │ (- name: "...")         │
│        │                                           ▼                         │
│        │                                   ┌──────────────┐                 │
│        │                                   │   IN_HOOK    │◄────────────┐   │
│        │                                   │              │             │   │
│        │                                   └───────┬──────┘             │   │
│        │                                           │                    │   │
│        │                                           │ hooks: array       │   │
│        │                                           ▼                    │   │
│        │                                   ┌──────────────┐             │   │
│        │                                   │ IN_HOOKS_ARR │             │   │
│        │                                   │              │─────────────┘   │
│        │                                   └───────┬──────┘  New hook       │
│        │                                           │                         │
│        │                                           │ command: | or prompt: | │
│        │                                           ▼                         │
│        │                                   ┌──────────────┐                 │
│        └───────────────────────────────────│ IN_MULTILINE │                 │
│                    End of multiline        │              │                 │
│                    (indent decreases)      └──────────────┘                 │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
```

### State Variables

| Variable | Type | Purpose |
|----------|------|---------|
| `current_event` | string | Current event being parsed (SessionStart, etc.) |
| `in_hook_list` | bool | Inside an event's hook list |
| `in_hook_item` | bool | Inside a specific hook definition |
| `in_hooks_array` | bool | Inside the `hooks:` array of a hook |
| `reading_multiline` | string | Type of multiline content (command/prompt) |
| `multiline_indent` | int | Indentation level for multiline content |

### Transitions

| From | To | Trigger |
|------|-----|---------|
| IDLE | IN_EVENT | Line matches `^(SessionStart\|...):`$ |
| IN_EVENT | IN_HOOK | Line matches `^[[:space:]]+-[[:space:]]+name:` |
| IN_HOOK | IN_HOOKS_ARRAY | Line matches `hooks:$` |
| IN_HOOKS_ARRAY | IN_MULTILINE | Line matches `command:\|$` or `prompt:\|$` |
| IN_MULTILINE | IN_HOOK | Indentation decreases below threshold |
| IN_EVENT | IDLE | Top-level key without indentation |

### JSON Output Structure

```json
{
  "_comment": "Auto-generated by generate.sh",
  "hooks": {
    "SessionStart": [
      {
        "matcher": "optional-pattern",
        "hooks": [
          {
            "type": "command",
            "command": "shell command here",
            "timeout": 30
          }
        ]
      }
    ],
    "PreToolUse": [...],
    "PostToolUse": [...]
  }
}
```

### Future Refactoring

The state machine is a candidate for extraction into separate modules:
- `.ai/lib/hooks-parser.sh` - Parse hooks.yaml
- `.ai/lib/hooks-transformer.sh` - Transform to platform format
- `.ai/lib/platform-writers/*.sh` - Write platform-specific files

See `docs/plans/refactor-plan-2026-02-02.md` for the full refactoring plan.

## See Also

- [AGENTS.md](../../AGENTS.md) - Fundamental rules for AI agents
- [data/README.md](../../prompts/fr/metametaprompts/data/README.md) - Source of truth documentation
- [hooks-manager skill](../../.ai/skills/hooks-manager.yaml) - Hooks knowledge base
- [Platform Capabilities](../../.ai/data/platform-capabilities.yaml) - Platform feature matrix
