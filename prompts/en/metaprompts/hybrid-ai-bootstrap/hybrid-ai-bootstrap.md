---
name: "hybrid-ai-bootstrap"
version: "2.1.0"
category: "metaprompts"
description: "Initialization prompt for hybrid AI architecture with multi-platform support"

tags: ["bootstrap", "architecture", "multi-platform", "metaprompts", "initialization"]
author: "Meta-prompt-LLM"
created: "2026-01-31"
updated: "2026-01-31"

language: "en"
difficulty: "advanced"

model_hints:
  recommended: ["claude-sonnet", "claude-opus", "gpt-4"]
  min_context: 16384
  temperature: 0.3
---

> [Version francaise](../../../fr/metaprompts/hybrid-ai-bootstrap/hybrid-ai-bootstrap.md)

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

```markdown
# Fundamental rules for AI agents

## First mandatory action
1. **Read `.ai/MEMORY.md`** to load context and preferences
2. Run `.ai/generate.sh` if skills modified

## Rule 0: honesty
- Right to not know, to ask for clarification
- Never invent facts, never pretend

## Rule 1: state of the art and consensus
- Consult official documentation before acting
- Search for solutions that have consensus on the internet
- Consult .ai/sources.yaml for reference URLs

## Rule 2: directed development
Order: specification -> documentation -> tests -> code -> refactoring

## Rule 3: security
- Never expose secrets
- Principle of least privilege
- Validate inputs, escape outputs

## Rule 4: DRY and KISS
- Single source of truth
- Keep things simple
- Decompose into atomic tasks

## Rule 5: todo list
Format: [ ] to do, [x] done, [~] in progress, [!] blocked

## Rule 6: file organization
- tmp/ for temporary files
- Never temporary files at root

## Rule 7: agent management
- Signal which agents are used: "Agent(s): [list]"
- AGENTS.md rules prevail over skill instructions

## Rule 8: self-improvement
- Propose updates if better practices detected
- Signal if instructions are obsolete

## Rule 9: checklist before commit (via workflow-orchestrator)
- [ ] generate.sh executed if skills modified
- [ ] prompt-validator passed if prompts modified
- [ ] inclusivity-reviewer passed if FR content modified
- [ ] translator sync check if docs/code modified
- [ ] memory-keeper invoked if important decisions

## Rule 10: writing conventions and inclusivity

### Style
- Capitals only at beginning of sentences and proper nouns (French style)
- No capitals for common nouns (not "the Skills" -> yes "the skills")

### Inclusive writing (French)

**Recommended techniques** (in order of preference):
1. **Middle dot (·)**: expert·e, utilisateur·ice, developpeur·euse
2. **Epicene forms**: eleve, adulte, personne, membre
3. **Encompassing forms**: "l'equipe" rather than "les developpeurs"

**Middle dot rules**:
- Simple endings: expert·e, apprenti·e
- Complex endings: explorateur·ice, collectionneur·euse

**To avoid**:
- Parentheses: utilisateur(trice)
- Slash: utilisateur/trice
- Inclusive capital: utilisateurEs

### Non-ableist language

| To avoid | Alternative |
|----------|-------------|
| crazy, insane | incredible, surprising |
| blind to | ignore, overlook |
| deaf to | insensitive to |
| sanity check | verification, validation |
| dummy value | example value, placeholder |

### Modern technical terminology

| Legacy | Modern |
|--------|--------|
| master/slave | primary/replica, leader/follower |
| whitelist/blacklist | allowlist/blocklist |
| master branch | main branch |
| man-hours | person-hours |

## Rule 11: self-review
- Reread own instructions regularly
- Verify relevance of skills used

## Rule 12: persistent memory
- Read .ai/MEMORY.md at session start
- Update via memory-keeper after important decisions
- Never delete historical information

## Rule 13: language and translation

### Default language
- **Code**: English (variables, functions, classes, commits)
- **Main documentation**: English (docs/en/)
- **Interface**: English by default

### Mandatory French translation
The **translator** agent must ALWAYS keep up to date:

1. **Documentation**:
   - Complete mirror of docs/en/ to docs/fr/
   - Cross-links at top of each file

2. **README**:
   - README.md in English (main)
   - README.fr.md in French with cross-link

### Synchronization
- Any EN doc modification -> automatic FR update
- Any FR doc modification -> verify coherence with EN
- Use translator with `--check-sync` option before commit

## Rule 14: communication workflows
- AI -> AI: delegate to appropriate skills via subagents
- AI -> Human: clear summaries, signal risks
- Human -> AI: can interrupt and modify at any time
```

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

1. **Summary** of what was created
2. **List of files** generated
3. **Recommended next steps**
4. **MEMORY.md update** with decisions made

## Related prompts

- [hybrid-ai-takeover](../hybrid-ai-takeover/hybrid-ai-takeover.md): for migrating existing projects

---

<!--
VERSION HISTORY:
- v2.1.0 (2026-01-31): Added detailed inclusivity rules, rule 13 language/translation, doc cross-links
- v2.0.0 (2026-01-31): Added persistent memory, workflow-orchestrator, prompts/ structure
- v1.0.0 (2026-01-31): Initial version
-->
