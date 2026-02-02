> [Version francaise](./README.fr.md)

> [!WARNING]
> This project is under development. Structure and APIs may change.

> [!NOTE]
> **LLM (AI) development assisted by human(s)**: This project has been developed from the ground up with LLM assistance. The codebase includes a hybrid AI architecture with specialized agents. This architecture was defined with the [hybrid-ai-bootstrap](./prompts/en/metaprompts/hybrid-ai-bootstrap) prompt.

# Meta-prompt-LLM

A framework for creating, modifying, and maintaining prompt collections with hybrid AI architecture support.

## Features

- **Centralized skill definitions** in YAML format
- **Multi-platform generation** for Claude Code, Cursor, Ollama, OpenCode, Aider, Continue.dev, Codex, and more
- **Persistent memory** between AI sessions
- **Workflow orchestration** for automated validation
- **Bilingual documentation** (English/French) with cross-references
- **Inclusive writing** enforcement for French content
- **Version check system**: Prompts can self-check for updates via GitHub raw URLs
- **Data source of truth**: All rules, skills, and prompts managed in `data/`

## Quick start

```bash
# Clone the repository
git clone https://github.com/jmchantrein/Meta-prompt-LLM.git
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
| `data-sync` | Synchronizes data/ to project files and validates integrity |
| `inclusivity-reviewer` | Inclusive writing validation |
| `link-checker` | Validates internal links in markdown |
| `memory-keeper` | Persistent memory management |
| `prompt-validator` | Prompt schema validation |
| `self-improver` | Project self-improvement agent |
| `translator` | EN/FR translation and sync |
| `workflow-orchestrator` | Multi-agent orchestration |

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

## Version check system

Prompts from this collection include a `<!-- META -->` block that enables:

- **Self-checking**: Prompts verify if updates are available at session start
- **Copy-paste friendly**: Mini-prompts for update checking in deployed prompts
- **User control**: Updates are proposed, never forced

### How it works

Each prompt contains metadata pointing to its source:

```markdown
<!-- META
prompt_id: "my-prompt"
version: "1.0.0"
source_url: "https://raw.githubusercontent.com/jmchantrein/Meta-prompt-LLM/main/..."
-->
```

At session start, the LLM can fetch the source and compare versions.

For more details, see [Version Check System Specification](./docs/en/specs/version-check-system.md).

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
