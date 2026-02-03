# Project memory

> Persistent memory for AI agents. Read at session start, update via `memory-keeper`.
> **Source of truth**: `prompts/fr/metametaprompts/data/memory/MEMORY.yaml`

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
| Inclusive writing | true |
| Shell standard | Bash (shellcheck-valid) |
| AI tools coverage | Maximum (all platforms) |
| End-of-response summary | true |

## Available skills

| Skill | Purpose | Status |
|-------|---------|--------|
| codebase-analyst | Deep codebase analysis for refactoring and architecture review | Active |
| data-sync | Synchronizes data/ to project files and validates integrity | Active |
| hooks-manager | Manages LLM hooks knowledge base and multi-platform hook generation | Active |
| inclusivity-reviewer | Reviews content for inclusive writing and modern terminology | Active |
| link-checker | Validates internal links and paths in markdown files | Active |
| memory-keeper | Manages persistent project memory between sessions | Active |
| package-manager | Manages external skills, hooks, and commands from registries | Active |
| prompt-engineer | Transforms and optimizes prompts using research-backed frameworks | Active |
| prompt-validator | Validates prompts against schema and quality standards | Active |
| self-improver | Agent d'auto-amélioration du projet Meta-prompt-LLM | Active |
| session-status | Generates end-of-response visual summary of skills, hooks, and commands | Active |
| translator | Manages EN/FR translation and documentation synchronization | Active |
| workflow-documenter | Génère et maintient la documentation des workflows agents/skills/hooks | Active |
| workflow-orchestrator | Orchestrates multi-agent workflows and validation sequences | Active |

## Notes

- All prompts must follow `prompts/_TEMPLATE.md`
- Run `generate.sh` after any skill modification
- French content must use inclusive writing
- **Source of truth**: `prompts/fr/metametaprompts/data/`
- **Generated files**: `.ai/` (never edit directly)
- Use `@future-self` in commits to leave notes for future sessions

## Platform Support Matrix

| Platform | Rating | Limitations |
|----------|--------|-------------|
| Claude Code | ★★★★★ | None - all 6 events + agent hooks |
| Cursor | ★★★★☆ | No SessionStart, no agent hooks |
| OpenCode | ★★★☆☆ | Requires oh-my-opencode plugin |
| Codex CLI | ★★☆☆☆ | Only notify on agent-turn-complete |
| Aider | ★☆☆☆☆ | No hooks, only auto_lint/test_cmd |
| Continue.dev | ★☆☆☆☆ | Data events only, no command hooks |

---

*Last updated: 2026-02-03 by memory-keeper (session 1ctTH)*
*Generated from: prompts/fr/metametaprompts/data/memory/MEMORY.yaml*

