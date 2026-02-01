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

## Evolution history

| Version | Date | Changes |
|---------|------|---------|
| 0.1.0 | 2026-01-31 | Initial architecture bootstrap |
| 0.2.0 | 2026-02-01 | Meta-Meta-prompt-LLM system for self-improvement |

## Lessons learned

| Date | Lesson | Context |
|------|--------|---------|
| 2026-01-31 | Research before implementation | BMAD, Kiro, AGENTS.md standards inform architecture |
| 2026-02-01 | Semi-automatic propagation | Always propose, never modify without validation |
| 2026-02-01 | @future-self convention | Use commit messages to communicate between sessions |

## Current context

### Active work

- Meta-Meta-prompt-LLM system implementation
- GitHub Pages setup for data access

### Pending decisions

- None currently

### Blockers

- None currently

## Available agents

| Agent | Purpose | Status |
|-------|---------|--------|
| inclusivity-reviewer | Inclusive writing, non-ableist language | Active |
| memory-keeper | Persistent memory management | Active |
| workflow-orchestrator | Multi-agent orchestration | Active |
| translator | EN/FR translation, sync | Active |
| prompt-validator | Prompt validation against schema | Active |
| self-improver | Project self-improvement and rule propagation | Active |
| link-checker | Internal link validation in markdown | Active |

## Notes

- All prompts must follow `prompts/_TEMPLATE.md`
- Run `generate.sh` after any skill modification
- French content must use inclusive writing
- Data source of truth: `prompts/fr/metametaprompts/data/`
- Run `self-improver` at session start to check for rule changes
- Use `@future-self` in commits to leave notes for future sessions

---

*Last updated: 2026-02-01 by memory-keeper*
