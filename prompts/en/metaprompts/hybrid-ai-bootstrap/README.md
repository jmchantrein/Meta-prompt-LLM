# hybrid-ai-bootstrap

> [Version francaise](../../../fr/metaprompts/hybrid-ai-bootstrap/README.md)

Initialization prompt for creating new projects with a hybrid AI architecture supporting multiple platforms (Claude Code, Cursor, Ollama, etc.).

## Use cases

- Starting a new software project with AI assistance
- Creating a prompt collection framework
- Setting up multi-platform AI agent configuration
- Establishing a bilingual (EN/FR) documentation structure

## When to use

Use this prompt when:

- You are starting a **new project** from scratch
- You want to centralize AI agent definitions in YAML
- You need multi-platform support (cloud + local AI)
- You want persistent memory between sessions
- You need automatic workflow orchestration

For existing projects, use [hybrid-ai-takeover](../../hybrid-ai-takeover/hybrid-ai-takeover.md) instead.

## Requirements

- An AI assistant capable of file creation (Claude Code, Cursor, etc.)
- Bash environment for generate.sh script
- Basic understanding of YAML syntax

## What it creates

```
.ai/
├── skills/*.yaml          # Centralized agent definitions
├── MEMORY.md              # Persistent project memory
├── generate.sh            # Multi-platform generator
└── sources.yaml           # Reference URLs

AGENTS.md                  # Fundamental rules
CLAUDE.md                  # Pointer to AGENTS.md
docs/en/ + docs/fr/        # Bilingual documentation
```

## Mandatory skills

The prompt creates these core skills:

| Skill | Purpose |
|-------|---------|
| inclusivity-reviewer | Inclusive writing and modern terminology |
| memory-keeper | Persistent memory management |
| workflow-orchestrator | Automatic agent orchestration |
| translator | EN/FR translation and sync |

## Related resources

- [AGENTS.md standard](https://agents.md/)
- [MCP protocol](https://modelcontextprotocol.io/)
- [BMAD method](https://github.com/bmad-code-org/BMAD-METHOD)
- [Kiro spec-driven](https://kiro.dev/)
