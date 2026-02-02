# Project memory

> Persistent memory for AI agents. Read at session start, update via `memory-keeper`.

## Project identity

| Property | Value |
|----------|-------|
| Name | Meta-prompt-LLM |
| Type | Prompt framework and collection |
| Created | 2026-01-31 |
| Main language | English (with French translation) |
| Paradigm | Doc-driven + Spec-driven hybrid |

## Description

A framework for creating, modifying, and maintaining prompt collections with:
- Centralized skill definitions in YAML
- Multi-platform generation (Claude Code, Cursor, Ollama, OpenCode, Aider, Continue.dev, Codex, etc.)
- Persistent memory between sessions
- Workflow orchestration for validation
- Bilingual documentation (EN/FR)

## User preferences

| Preference | Value |
|------------|-------|
| Language (interface) | French |
| Language (code/docs) | English |
| Inclusive writing | Yes (French content) |
| Shell standard | Bash (shellcheck-valid) |
| AI tools coverage | Maximum (all platforms) |

## Technical decisions

| Date | Decision | Reason |
|------|----------|--------|
| 2026-01-31 | Doc-driven + Spec-driven paradigm | Meta-project about prompts; docs ARE the product |
| 2026-01-31 | YAML as single source for skills | DRY principle; generate platform-specific files |
| 2026-01-31 | Bash-only for generate.sh | Maximize portability, LLM-only stack |
| 2026-01-31 | AGENTS.md standard adopted | Industry consensus, Linux Foundation backing |
| 2026-01-31 | Bilingual EN/FR documentation | User preference, inclusivity |
| 2026-02-01 | Meta-Meta-prompt-LLM system | Self-reference for coherent project evolution |
| 2026-02-01 | Data in FR as source of truth | YAML data in prompts/fr/metametaprompts/data/ |
| 2026-02-01 | GitHub Pages for data access | YAML served directly, no duplication |
| 2026-02-01 | Rule 15: mandatory post-review | Ensures memory update and self-improver run |
| 2026-02-02 | KISS for data/ structure | Simplified from nested to flat structure (2994926) |
| 2026-02-02 | Hooks in source of truth | hooks.yaml in data/ generates platform configs |
| 2026-02-02 | SessionStart hook needed | Initialize session BEFORE user input |
| 2026-02-02 | Stop hook for consistency | Agent-based check after each Claude response |
| 2026-02-02 | Visual feedback for agents | Show agent hierarchy/nesting during session |

## Evolution history

| Version | Date | Changes |
|---------|------|---------|
| 0.1.0 | 2026-01-31 | Initial architecture bootstrap |
| 0.2.0 | 2026-02-01 | Meta-Meta-prompt-LLM system for self-improvement |
| 0.3.0 | 2026-02-02 | Hooks system, workflow-documenter, architecture docs |

## Session history

| Date | Session | Key commits | Summary |
|------|---------|-------------|---------|
| 2026-01-31 | PR #1 | a93cd40→d08129a | Initial bootstrap: prompt structure, link-checker, hybrid-ai-takeover |
| 2026-02-01 | PR #2 | 6853193→95d71e9 | Rule 15, README notices for LLM contribution |
| 2026-02-01 | PR #3 | 268b72e→a91ec36 | Self-improver, orchestrator workflows |
| 2026-02-01 | - | 616c005→8beaafb | Version check system (spec→impl) |
| 2026-02-01 | - | 15bd248→0fa9ba7 | Socratic-tutor prompt, audit fixes |
| 2026-02-02 | PR #4 | 2994926→d1876f9 | KISS refactor, hooks-manager skill |
| 2026-02-02 | PR #5 | fc1c3db→c1e0b88 | Workflow-documenter, architecture docs |

## Lessons learned

| Date | Lesson | Context |
|------|--------|---------|
| 2026-01-31 | Research before implementation | BMAD, Kiro, AGENTS.md standards inform architecture |
| 2026-02-01 | Semi-automatic propagation | Always propose, never modify without validation |
| 2026-02-01 | @future-self convention | Use commit messages to communicate between sessions |
| 2026-02-02 | KISS principle for data/ | Flat structure better than nested (2994926) |
| 2026-02-02 | Source of truth = data/ | .ai/ is generated, never edit directly |
| 2026-02-02 | SessionStart exists | Hook event runs BEFORE user input, not just UserPromptSubmit |
| 2026-02-02 | Stop hook for consistency | Agent-type hook can validate and continue if needed |
| 2026-02-02 | MEMORY.md not auto-updated | Sessions without memory-keeper invocation lose context |

## Current context

### Active work

- **[DONE]** Complete hooks lifecycle (SessionStart, Stop, SessionEnd)
- **[DONE]** Visual feedback system for agent hierarchy
- **[IN PROGRESS]** Make self-improver fully functional
- GitHub Pages setup for data access

### Pending decisions

- None currently

### Blockers

- None currently

## Available agents

| Agent | Purpose | Status |
|-------|---------|--------|
| data-sync | Syncs data/ to .ai/ and validates integrity | Active |
| hooks-manager | Multi-platform hook generation from YAML | Active |
| inclusivity-reviewer | Inclusive writing, non-ableist language | Active |
| link-checker | Internal link validation in markdown | Active |
| memory-keeper | Persistent memory management | Active |
| prompt-validator | Prompt validation against schema | Active |
| self-improver | Project self-improvement and rule propagation | Active |
| translator | EN/FR translation, sync | Active |
| workflow-documenter | Generates workflow documentation | Active |
| workflow-orchestrator | Multi-agent orchestration | Active |

## Notes

- All prompts must follow `prompts/_TEMPLATE.md`
- Run `generate.sh` after any skill modification
- French content must use inclusive writing
- **Source of truth**: `prompts/fr/metametaprompts/data/`
- **Generated files**: `.ai/` (never edit directly)
- Use `@future-self` in commits to leave notes for future sessions

## Hook Lifecycle (implemented 2026-02-02)

```
┌─ SessionStart ─────────────────────────────────────────────┐
│  🔧 [data-sync] Vérifie synchronisation data/ → .ai/      │
│  🔧 [generate] Vérifie si régénération nécessaire         │
│  🧠 [memory-keeper] Charge .ai/MEMORY.md dans le contexte │
│  🔄 [self-improver] Vérifie les changements de règles     │
└────────────────────────────────────────────────────────────┘
                            ↓
┌─ UserPromptSubmit ─────────────────────────────────────────┐
│  📋 Feedback discret: "Session active | Mémoire: ..."     │
└────────────────────────────────────────────────────────────┘
                            ↓
┌─ PreToolUse ───────────────────────────────────────────────┐
│  Guardrails: .env, credentials, destructive ops, .ai/     │
└────────────────────────────────────────────────────────────┘
                            ↓
┌─ PostToolUse ──────────────────────────────────────────────┐
│  📦 [generate] Auto-régénère si skill modifié             │
│  🔧 [data-sync] Auto-sync si data/ modifié                │
│  🔍 [inclusivity] Rappel si contenu FR modifié            │
│  🌍 [translator] Rappel si doc EN modifié                 │
└────────────────────────────────────────────────────────────┘
                            ↓
┌─ Stop ─────────────────────────────────────────────────────┐
│  ✅ [consistency-check] Agent vérifie si MEMORY.md        │
│     doit être mis à jour. Si oui, continue la session.    │
└────────────────────────────────────────────────────────────┘
                            ↓
┌─ SessionEnd ───────────────────────────────────────────────┐
│  📝 Rappel final de mise à jour mémoire                   │
└────────────────────────────────────────────────────────────┘
```

## Visual Feedback Convention

| Emoji | Agent | Purpose |
|-------|-------|---------|
| 🔧 | [data-sync] | Synchronisation data/ → .ai/ |
| 🔧 | [generate] | Génération de fichiers |
| 🧠 | [memory-keeper] | Gestion mémoire |
| 🔄 | [self-improver] | Auto-amélioration |
| ✅ | [consistency-check] | Vérification post-réponse |
| 🔍 | [inclusivity] | Écriture inclusive |
| 🌍 | [translator] | Synchronisation EN/FR |
| 📦 | - | Skill/règle modifié |
| 📋 | - | Information générale |
| ⚠️ | - | Attention requise |
| ❌ | - | Échec |

---

*Last updated: 2026-02-02 by memory-keeper*
