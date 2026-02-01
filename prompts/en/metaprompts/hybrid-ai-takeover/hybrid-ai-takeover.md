---
name: "hybrid-ai-takeover"
version: "2.1.0"
category: "metaprompts"
description: "Prompt for migrating an existing project to hybrid AI architecture"

tags: ["takeover", "migration", "architecture", "multi-platform", "metaprompts"]
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

> [Version francaise](../../../fr/metaprompts/hybrid-ai-takeover/hybrid-ai-takeover.md)

# Project takeover to hybrid AI architecture

> Startup prompt to migrate an existing project to a hybrid AI architecture (cloud + local), including persistent memory and automatic agent orchestration.

## Context

You are taking over an existing project and must migrate it to a hybrid AI architecture comprising:
- A single source for agent definitions (`.ai/skills/*.yaml`)
- A script that generates files for each platform (Claude Code, Ollama, Cursor, etc.)
- Fundamental rules that all agents must respect
- Persistent memory for context between sessions
- A workflow orchestrator for automation

**Why this migration**: projects often accumulate disparate AI configuration files (CLAUDE.md, .cursorrules, Modelfile, etc.) that become desynchronized. This architecture centralizes everything and automatically generates platform-specific formats.

## Instructions

### Phase 1: preliminary research

**Before doing anything**:

1. Consult official documentation for:
   - AGENTS.md (https://agents.md/) - universal standard
   - MCP (https://modelcontextprotocol.io/) - connection protocol
   - Claude Code subagents, Ollama Modelfile, Continue.dev, Aider, Cursor, OpenCode, Codex

2. Research current best practices for:
   - Migration of existing AI configurations
   - YAML file structure for AI agents
   - Inclusive writing in French
   - Persistent memory for AI agents

3. Check if there is consensus on this type of migration

### Phase 2: project discovery

Explore the project and answer these questions:

```bash
# Existing AI files
find . -name "CLAUDE.md" -o -name "AGENTS.md" -o -name ".cursorrules" \
       -o -name ".windsurfrules" -o -name "Modelfile*" \
       -o -name ".aider*" -o -name ".continuerc*" -o -name "RULES.md" 2>/dev/null

# Existing documentation structure
ls -la docs/ 2>/dev/null
ls -la README*.md 2>/dev/null

# Tech stack
cat package.json 2>/dev/null || cat Cargo.toml 2>/dev/null || \
cat go.mod 2>/dev/null || cat requirements.txt 2>/dev/null

# General structure
ls -la
```

Ask the user these questions:

1. **History**: how long has this project existed? Important past decisions?
2. **Tech stack**: confirm detected languages, frameworks, databases
3. **Environment**: cloud, local, hybrid, air-gapped?
4. **AI tools used**: which ones currently? which ones desired?
5. **Current paradigm**: how is development currently organized?
6. **Desired paradigm**: (explain options if needed)

### Paradigm selection guide

| Context | Recommended paradigm | Why |
|---------|---------------------|-----|
| Rapid prototype, exploration, POC | **Vibe coding** | Fast iteration, immediate feedback |
| Production, team, maintainability | **Spec-driven** (Kiro-style) | Specs before code, traceability |
| Complex project, multi-agent, scalable | **BMAD** | Personas, orchestration, rich docs |
| Refactoring, technical debt | **TDD strict** | Tests first, non-regression |
| Documentation/content | **Doc-driven** | Documentation as source of truth |

**Preliminary research**: before recommending, consult:
- BMAD: https://github.com/bmad-code-org/BMAD-METHOD
- Kiro (spec-driven): https://kiro.dev/

### Phase 3: analysis report

Generate a structured report:

```markdown
## Analysis report - [Project name]

### Existing AI files
| File | Present | Main content |
|------|---------|--------------|
| CLAUDE.md | yes/no | [summary] |
| AGENTS.md | yes/no | [summary] |
| RULES.md | yes/no | [summary] |
| .cursorrules | yes/no | [summary] |
| Modelfile | yes/no | [summary] |
| .aider.conf.yml | yes/no | [summary] |
| .continuerc.json | yes/no | [summary] |

### Existing documentation
| Element | Present | Language(s) |
|---------|---------|-------------|
| README.md | yes/no | EN/FR |
| docs/ | yes/no | structure |

### Detected stack
- Languages: ...
- Frameworks: ...
- Tests: ...

### Identified existing conventions
- ...

### Potential conflicts
- ...

### Detected current paradigm
- ...
```

### Phase 4: legacy file backup

**Mandatory before any modification**:

```bash
mkdir -p .ai/legacy-backup

# Backup existing AI files
for file in CLAUDE.md AGENTS.md RULES.md .cursorrules .windsurfrules \
            .aider.conf.yml .continuerc.json; do
    [ -f "$file" ] && cp "$file" ".ai/legacy-backup/${file}.backup"
done

# Backup directories
[ -d ".claude" ] && cp -r .claude .ai/legacy-backup/
[ -d ".cursor" ] && cp -r .cursor .ai/legacy-backup/
[ -d "ollama" ] && cp -r ollama .ai/legacy-backup/

# Backup existing documentation
[ -d "docs" ] && cp -r docs .ai/legacy-backup/
[ -f "README.md" ] && cp README.md .ai/legacy-backup/
[ -f "README.fr.md" ] && cp README.fr.md .ai/legacy-backup/
```

### Phase 5: create centralized architecture

Create the `.ai/` structure:

```
.ai/
├── skills/                     # single source (YAML)
│   ├── _TEMPLATE.yaml
│   └── [extracted and new skills].yaml
├── commands/
│   └── quick-reference.md
├── plans/
├── legacy-backup/              # original files (created in phase 4)
├── MEMORY.md                   # persistent memory (pre-filled)
├── sources.yaml
├── VERSION                     # 1.0.0
├── README.md
└── generate.sh

# At root (AGENTS.md standard)
AGENTS.md                       # fundamental rules (merges all)
CLAUDE.md                       # pointer to AGENTS.md

# Bilingual documentation
docs/
├── en/                         # main documentation (English)
└── fr/                         # French translation (mirror)

README.md                       # English (main)
README.fr.md                    # French (cross-link)
```

### Phase 6: extract and merge legacy content

For each legacy file found:

1. **Extract instructions** (personas, rules, conventions)
2. **Identify implicit skills** (defined roles)
3. **Merge into AGENTS.md** (rules) and `.ai/skills/*.yaml` (agents)
4. **Resolve conflicts** (priority to most recent/detailed)

**Important**: existing RULES.md (if present) must be merged into AGENTS.md at root.

Merge example:

```yaml
# .ai/skills/project-assistant.yaml
# Merged from: CLAUDE.md (backup), .cursorrules (backup)

name: "project-assistant"
version: "1.0.0"
description: "Main assistant - merged from legacy configs"

persona: |
  [Harmonized content from legacy files]

security:
  never:
    - [Extracted rules]
  always:
    - [Extracted rules]
  ask_before:
    - [Actions requiring confirmation]
```

### Phase 7: documentation migration

1. **If docs/ exists but not bilingual**:
   - Move to docs/en/ or docs/fr/ depending on language
   - Create mirror in other language
   - Add cross-links

2. **If README exists but not bilingual**:
   - README.md becomes English version
   - Create README.fr.md (translation)
   - Add cross-links at top

3. **If already bilingual**:
   - Verify synchronization
   - Add cross-links if missing

### Phase 8: create AGENTS.md

Create AGENTS.md at root with all merged rules, including:

- First mandatory action (read MEMORY.md)
- Rule 0: honesty
- Rule 1: state of the art and consensus
- Rule 2: directed development
- Rule 3: security
- Rule 4: DRY and KISS
- Rule 5: todo list
- Rule 6: file organization
- Rule 7: agent management
- Rule 8: self-improvement
- Rule 9: checklist before commit
- Rule 10: writing conventions and inclusivity
- Rule 11: self-review
- Rule 12: persistent memory
- Rule 13: language and translation
- Rule 14: communication workflows
- Rule 15: post-review actions (MANDATORY)

### Phase 9: create MEMORY.md (pre-filled)

Create `.ai/MEMORY.md` with project history including:
- Project identity
- User preferences
- Technical decisions (table with date, decision, reason)
- Evolution history
- Lessons learned
- Current context
- Available agents

### Phase 10: create mandatory skills

Skills to create mandatorily:
- `inclusivity-reviewer`: inclusive writing, non-ableist language, modern terminology
- `memory-keeper`: persistent memory management
- `workflow-orchestrator`: automatic agent orchestration
- `translator`: EN-FR translation, doc sync, bilingual comments

Plus skills extracted from legacy files.

### Phase 11: create generate.sh script

Idempotent bash script that:
1. Checks VERSION (only regenerates if changed, except `--force`)
2. Parses `.ai/skills/*.yaml`
3. Generates for each platform:
   - AGENTS.md (at root), CLAUDE.md
   - .claude/agents/*.md, .opencode/agents/*.md
   - ollama/Modelfile.*, ollama/create-all.sh
   - .continuerc.json, .aider.conf.yml, .cursorrules
   - .codex/agents/*.md

### Phase 12: execute and validate

```bash
chmod +x .ai/generate.sh
.ai/generate.sh --force
```

Validation checklist:
- [ ] generate.sh executes without error
- [ ] AGENTS.md contains all rules (including those from old RULES.md)
- [ ] Extracted skills are complete
- [ ] Bilingual documentation with cross-links
- [ ] translator --check-sync passes
- [ ] Existing tests still pass
- [ ] Project works normally

### Phase 13: document the migration

Update README.md and README.fr.md with "AI Architecture" section.

### Phase 14: finalization

1. Verify project works (build, tests)
2. Update MEMORY.md with decisions made
3. Summarize what was migrated
4. List recommended next steps

## Constraints

- Never modify without first doing backup (Phase 4)
- Never delete legacy files (keep in .ai/legacy-backup/)
- Always ask Phase 2 questions
- Merge existing RULES.md into AGENTS.md (no separate RULES.md file)
- Mandatory inclusion of MEMORY.md and memory/orchestration/translation skills
- Use inclusive writing in all French files
- Documentation always bilingual with cross-links

## Output format

At the end, provide:

1. **Summary** of what was migrated
2. **List of files** created/modified
3. **Differences** with legacy configuration
4. **Recommended next steps**
5. **MEMORY.md** updated with decisions made

## Related prompts

- [hybrid-ai-bootstrap](../hybrid-ai-bootstrap/hybrid-ai-bootstrap.md): for new projects

---

<!--
VERSION HISTORY:
- v2.1.0 (2026-01-31): Harmonization with hybrid-ai-bootstrap, added MEMORY.md, rules 12-14, removed RULES.md (merged into AGENTS.md), paradigms, translation
- v1.0.0 (2026-01-31): Initial version
-->
