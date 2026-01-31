---
name: "hybrid-ai-bootstrap"
version: "2.1.0"
category: "meta"
description: "Initialization prompt for hybrid AI architecture with multi-platform support"

tags: ["bootstrap", "architecture", "multi-platform", "meta-prompt", "initialization"]
author: "Meta-prompt-LLM"
created: "2026-01-31"
updated: "2026-01-31"
language: "en"
difficulty: "advanced"
---

# Hybrid AI architecture bootstrap

> Startup prompt to initialize a new project with a hybrid AI architecture (cloud + local), including persistent memory and automatic agent orchestration.

## Context

You are initializing a new project with a hybrid AI architecture comprising:
- A single source for agent definitions (`.ai/skills/*.yaml`)
- A script that generates files for each platform (Claude Code, Ollama, Cursor, etc.)
- Fundamental rules that all agents must respect
- Persistent memory for context between sessions
- A workflow orchestrator for automation

**Why this architecture**: Avoids duplication of AI configuration files (CLAUDE.md, .cursorrules, Modelfile, etc.) by centralizing everything in YAML files. A script then generates platform-specific formats.

## Instructions

### Phase 1: preliminary research

**Before creating anything**:

1. Consult official documentation for:
   - AGENTS.md (https://agents.md/) - universal standard
   - MCP (https://modelcontextprotocol.io/) - connection protocol
   - Claude Code subagents, Ollama Modelfile, Continue.dev, Aider, Cursor, OpenCode, Codex

2. Research current best practices for:
   - YAML file structure for AI agents
   - Multi-platform generation
   - Inclusive writing in French
   - Persistent memory for AI agents
   - Multi-agent workflow orchestration

3. Check if there is consensus on the internet for this type of architecture

### Phase 2: questions

Ask the user these questions:

1. **Project type**: web app, API, CLI, infrastructure, data, prompt collection?
2. **Tech stack**: languages, frameworks, databases?
3. **Environment**: cloud, local, hybrid, air-gapped?
4. **AI tools used**: Claude Code, Cursor, Ollama local, OpenCode, others?
5. **Specific needs**: particular skills needed?
6. **Development paradigm**: (explain options below if user doesn't know)

### Paradigm selection guide

If the user doesn't know which paradigm to choose, recommend based on context:

| Context | Recommended paradigm | Why |
|---------|---------------------|-----|
| Rapid prototype, exploration, POC | **Vibe coding** | Fast iteration, immediate feedback |
| Production, team, maintainability | **Spec-driven** (Kiro-style) | Specs before code, traceability |
| Complex project, multi-agent, scalable | **BMAD** | Personas, orchestration, rich docs |
| Refactoring, technical debt | **TDD strict** | Tests first, non-regression |
| Documentation/content | **Doc-driven** | Documentation as source of truth |

**Preliminary research**: Before recommending, consult official docs for:
- BMAD: https://github.com/bmad-code-org/BMAD-METHOD
- Kiro (spec-driven): https://kiro.dev/
- Current agentic coding patterns (2025-2026)

### Phase 3: create the architecture

Create this structure:

```
.ai/
├── skills/                     # single source (YAML)
│   ├── _TEMPLATE.yaml          # documented template
│   └── [relevant skills].yaml
├── commands/                   # reusable prompts
│   └── quick-reference.md
├── plans/                      # execution plans
├── MEMORY.md                   # persistent project memory
├── sources.yaml                # official reference URLs
├── VERSION                     # version number
├── README.md                   # system documentation
└── generate.sh                 # multi-platform generation script

# At root (AGENTS.md standard)
AGENTS.md                       # fundamental rules
CLAUDE.md                       # pointer to AGENTS.md

# Bilingual documentation
docs/
├── en/                         # main documentation (English)
│   └── *.md
└── fr/                         # French translation (mirror)
    └── *.md

prompts/                        # prompt collection (if applicable)
├── _TEMPLATE.md
├── _metadata/
│   ├── categories.yaml
│   └── languages.yaml
└── [categories]/

tmp/                            # temporary files (gitignored)
```

### Phase 4: critical file content

#### 4.1 - AGENTS.md

Create a fundamental rules file following the AGENTS.md standard (https://agents.md/) including:

- First mandatory action (read MEMORY.md)
- Rule 0: honesty
- Rule 1: state of the art and consensus
- Rule 2: directed development
- Rule 3: security
- Rule 4: DRY and KISS
- Rule 5: todo list format
- Rule 6: file organization
- Rule 7: agent management
- Rule 8: self-improvement
- Rule 9: checklist before commit
- Rule 10: writing conventions and inclusivity
- Rule 11: self-review
- Rule 12: persistent memory
- Rule 13: language and translation
- Rule 14: communication workflows

#### 4.2 - MEMORY.md

Create a persistent memory file with sections:
- Project identity
- User preferences
- Technical decisions (table with date, decision, reason)
- Evolution history
- Lessons learned
- Current context
- Available agents

#### 4.3 - generate.sh

Bash script that:
1. Checks VERSION (idempotency)
2. Parses `.ai/skills/*.yaml`
3. Generates for each platform:
   - AGENTS.md (at root), CLAUDE.md
   - .claude/agents/*.md, .opencode/agents/*.md
   - ollama/Modelfile.*, .cursorrules
   - .continuerc.json, .aider.conf.yml
   - .codex/agents/*.md

### Phase 5: create skills

Mandatory skills for any project:
- `inclusivity-reviewer`: inclusive writing, non-ableist language, modern terminology
- `memory-keeper`: persistent memory management
- `workflow-orchestrator`: automatic agent orchestration
- `translator`: EN-FR translation, doc sync, bilingual comments

Additional skills based on project type:
- `prompt-validator`: prompt validation (if collection)
- `code-reviewer`: code review
- `sysops-assistant`: infrastructure/devops
- Others as needed

### Phase 6: execute and validate

```bash
chmod +x .ai/generate.sh
.ai/generate.sh --force
```

### Phase 7: finalization

1. README.md (EN) + README.fr.md (FR) with cross-links
2. Appropriate .gitignore
3. docs/en/ and docs/fr/ structure
4. First commit

## Constraints

- Never create files without first researching best practices
- Always ask Phase 2 questions before creating
- Mandatory inclusion of MEMORY.md and memory/orchestration/translation skills
- Use inclusive writing in all French files
- Documentation always bilingual with cross-links

## Output format

At the end, provide:
1. Summary of what was created
2. List of generated files
3. Recommended next steps
4. MEMORY.md update with decisions made

---

<!--
VERSION HISTORY:
- v2.1.0 (2026-01-31): Added detailed inclusivity rules, rule 13 language/translation, doc cross-links
- v2.0.0 (2026-01-31): Added persistent memory, workflow-orchestrator, prompts/ structure
- v1.0.0 (2026-01-31): Initial version
-->
