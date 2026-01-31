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

## Evolution history

| Version | Date | Changes |
|---------|------|---------|
| 0.1.0 | 2026-01-31 | Initial architecture bootstrap |

## Lessons learned

| Date | Lesson | Context |
|------|--------|---------|
| 2026-01-31 | Research before implementation | BMAD, Kiro, AGENTS.md standards inform architecture |

## Current context

### Active work

- Initial project setup and architecture creation

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

## Notes

- All prompts must follow `prompts/_TEMPLATE.md`
- Run `generate.sh` after any skill modification
- French content must use inclusive writing

---

*Last updated: 2026-01-31 by memory-keeper*
