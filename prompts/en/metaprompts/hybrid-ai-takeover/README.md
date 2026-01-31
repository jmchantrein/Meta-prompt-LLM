# hybrid-ai-takeover

> [Version francaise](../../../fr/metaprompts/hybrid-ai-takeover/README.md)

Migration prompt for converting existing projects to a hybrid AI architecture with centralized configuration and multi-platform support.

## Use cases

- Migrating a project with scattered AI config files
- Consolidating CLAUDE.md, .cursorrules, Modelfile, etc.
- Adding persistent memory to an existing project
- Establishing bilingual documentation from existing docs

## When to use

Use this prompt when:

- You have an **existing project** with AI configuration
- AI config files have become desynchronized
- You want to centralize and unify agent definitions
- You need to add workflow orchestration to an existing setup

For new projects, use [hybrid-ai-bootstrap](../hybrid-ai-bootstrap/hybrid-ai-bootstrap.md) instead.

## What it does

1. **Discovery**: scans for existing AI files (CLAUDE.md, .cursorrules, etc.)
2. **Backup**: saves all legacy files to `.ai/legacy-backup/`
3. **Analysis**: generates a structured report of current state
4. **Migration**: extracts rules and skills from legacy files
5. **Centralization**: creates unified `.ai/skills/*.yaml` structure
6. **Generation**: produces platform-specific configs from YAML

## Paradigm selection

The prompt helps you choose the right development paradigm:

| Context | Recommended |
|---------|-------------|
| Rapid prototype, POC | Vibe coding |
| Production, team | Spec-driven (Kiro-style) |
| Complex, multi-agent | BMAD method |
| Refactoring, tech debt | TDD strict |
| Documentation focus | Doc-driven |

## Safety features

- **Mandatory backup** before any modification
- Legacy files preserved in `.ai/legacy-backup/`
- Conflict resolution with priority rules
- Validation checklist before finalization

## Requirements

- An AI assistant capable of file operations
- Bash environment for scripts
- Existing project to migrate

## Related resources

- [hybrid-ai-bootstrap](../hybrid-ai-bootstrap/hybrid-ai-bootstrap.md) - for new projects
- [AGENTS.md standard](https://agents.md/)
