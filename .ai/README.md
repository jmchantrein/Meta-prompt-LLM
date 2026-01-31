# .ai directory

> AI configuration and skill definitions

## Structure

```
.ai/
├── skills/           # Skill definitions (YAML)
│   ├── _TEMPLATE.yaml
│   └── *.yaml
├── commands/         # Reusable prompt commands
├── plans/            # Execution plans
├── MEMORY.md         # Persistent memory
├── sources.yaml      # Reference URLs
├── VERSION           # Current version/hash
├── README.md         # This file
└── generate.sh       # Multi-platform generator
```

## Usage

### Generate platform configurations

```bash
./generate.sh           # Generate if needed
./generate.sh --force   # Force regeneration
./generate.sh --check   # Check if regeneration needed
./generate.sh --dry-run # Preview without writing
```

### Add a new skill

1. Copy `skills/_TEMPLATE.yaml` to `skills/your-skill.yaml`
2. Edit the YAML with your skill definition
3. Run `./generate.sh`

### Modify rules

1. Edit the relevant skill in `skills/`
2. Run `./generate.sh` to update all platforms

## Generated files

| File | Platform |
|------|----------|
| `AGENTS.md` | Universal standard |
| `CLAUDE.md` | Claude Code |
| `.claude/agents/*.md` | Claude Code subagents |
| `.cursorrules` | Cursor |
| `.continuerc.json` | Continue.dev |
| `.aider.conf.yml` | Aider |
| `ollama/Modelfile.*` | Ollama |
| `.opencode/agents/*.md` | OpenCode |
| `.codex/agents/*.md` | Codex CLI |

## Important

- **Never edit generated files directly** - they will be overwritten
- Edit source YAML in `skills/` instead
- Run `generate.sh` after any modification
