> [Version francaise](./README.fr.md)

> [!WARNING]
> This project is under development. Structure and APIs may change.

> [!NOTE]
> This project has been developed from the ground up with LLMs.

# Meta-prompt-LLM

A framework for creating, modifying, and maintaining prompt collections with hybrid AI architecture support.

## Features

- **Centralized skill definitions** in YAML format
- **Multi-platform generation** for Claude Code, Cursor, Ollama, OpenCode, Aider, Continue.dev, Codex, and more
- **Persistent memory** between AI sessions
- **Workflow orchestration** for automated validation
- **Bilingual documentation** (English/French) with cross-references
- **Inclusive writing** enforcement for French content

## Quick start

```bash
# Clone the repository
git clone https://github.com/your-org/Meta-prompt-LLM.git
cd Meta-prompt-LLM

# Generate platform configurations
.ai/generate.sh

# Start using with your AI tool
```

## Project structure

```
Meta-prompt-LLM/
├── .ai/                    # AI configuration
│   ├── skills/             # Skill definitions (YAML)
│   ├── commands/           # Reusable commands
│   ├── plans/              # Execution plans
│   ├── MEMORY.md           # Persistent memory
│   ├── sources.yaml        # Reference URLs
│   └── generate.sh         # Generator script
├── prompts/                # Prompt collection
│   ├── _TEMPLATE.md        # Prompt template
│   ├── _metadata/          # Categories and languages
│   └── [categories]/       # Organized prompts
├── docs/                   # Documentation
│   ├── en/                 # English (primary)
│   └── fr/                 # French (mirror)
├── AGENTS.md               # Fundamental rules
├── CLAUDE.md               # Claude Code config
└── README.md               # This file
```

## How it works

### Single source of truth

All AI agent configurations are defined once in `.ai/skills/*.yaml`. The `generate.sh` script then creates platform-specific files:

| Source | Generated files |
|--------|-----------------|
| `.ai/skills/*.yaml` | `AGENTS.md`, `CLAUDE.md`, `.cursorrules`, etc. |

### Available skills

| Skill | Purpose |
|-------|---------|
| `inclusivity-reviewer` | Inclusive writing validation |
| `memory-keeper` | Persistent memory management |
| `workflow-orchestrator` | Multi-agent orchestration |
| `translator` | EN/FR translation and sync |
| `prompt-validator` | Prompt schema validation |

### Workflow

1. **Session start**: Read `.ai/MEMORY.md`
2. **Modify skills**: Edit YAML files in `.ai/skills/`
3. **Generate**: Run `.ai/generate.sh`
4. **Validate**: Pre-commit checks via `workflow-orchestrator`
5. **Update memory**: Record decisions via `memory-keeper`

## Usage

### Generate configurations

```bash
# Generate if needed
.ai/generate.sh

# Force regeneration
.ai/generate.sh --force

# Check if regeneration needed (CI/CD)
.ai/generate.sh --check

# Preview changes
.ai/generate.sh --dry-run --verbose
```

### Add a new skill

1. Copy the template:
   ```bash
   cp .ai/skills/_TEMPLATE.yaml .ai/skills/my-skill.yaml
   ```

2. Edit the YAML file with your skill definition

3. Generate configurations:
   ```bash
   .ai/generate.sh
   ```

### Add a new prompt

1. Copy the template:
   ```bash
   cp prompts/_TEMPLATE.md prompts/[category]/my-prompt.md
   ```

2. Edit with your prompt content

3. Validate:
   ```bash
   # Use prompt-validator skill
   ```

## Documentation

- [English documentation](./docs/en/)
- [French documentation](./docs/fr/)

## Contributing

1. Read `AGENTS.md` for contribution guidelines
2. Follow inclusive writing rules for French content
3. Run `generate.sh --check` before committing
4. Ensure documentation is bilingual

## License

GPL-3.0 License - see [LICENSE](./LICENSE)
