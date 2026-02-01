# Version Check and Self-Update System

> **Status**: DRAFT - Updated with user feedback
> **Version**: 0.3.0
> **Date**: 2026-02-01

## 1. Overview

### 1.1 Problem statement

When a prompt from the Meta-prompt-LLM collection is copied and used in another project:
- It becomes disconnected from its source
- It cannot access associated rules and skills
- Users are unaware of updates and improvements

### 1.2 Objectives

1. **Deterministic retrieval**: Prompts can fetch their rules/skills via URLs
2. **Version tracking**: Each prompt has a semantic version
3. **Self-checking**: At session start, prompts verify if updates are available
4. **User control**: Updates are proposed, never forced
5. **Copy-paste friendly**: Mini-prompts for easy adoption in deployed prompts

### 1.3 Principles

- **KISS**: Keep it simple, avoid over-engineering
- **Non-intrusive**: User decides whether to update
- **Transparent**: Changelog explains what changed
- **Deterministic**: Version numbers, no ambiguity
- **Project validates**: Validation is done before distribution, not by consuming LLMs

## 2. Architecture

### 2.1 Source of truth

All data lives in `data/` within the metametaprompts folder:

```
prompts/fr/metametaprompts/data/    # Source of truth
├── manifest.yaml                   # Central index + versions + hashes
├── rules/
│   ├── rules.yaml                 # All rules
│   └── CHANGELOG.md
├── skills/
│   ├── *.yaml                     # All skills
│   └── CHANGELOG.md
└── prompts/
    ├── en/                        # English prompts
    │   └── *.md
    ├── fr/                        # French prompts
    │   └── *.md
    └── CHANGELOG.md
```

### 2.2 Data flow

```
┌─────────────────────────────────────────────────────────────────┐
│                  data/ (Source of Truth)                        │
├─────────────────────────────────────────────────────────────────┤
│  manifest.yaml                                                  │
│  rules/*.yaml                                                   │
│  skills/*.yaml                                                  │
│  prompts/**/*.md  ◄── Prompts live here directly               │
└───────────────────────────────┬─────────────────────────────────┘
                                │
                                │ data-sync agent
                                │
        ┌───────────────────────┼───────────────────────┐
        │                       │                       │
        ▼                       ▼                       ▼
┌───────────────┐     ┌─────────────────┐     ┌─────────────────┐
│ .ai/skills/   │     │   AGENTS.md     │     │   CLAUDE.md     │
│ (copies)      │     │   (generated)   │     │   (generated)   │
└───────────────┘     └─────────────────┘     └─────────────────┘
                                │
                                │ GitHub raw URL (official repo only)
                                │
                                ▼
                    ┌───────────────────────┐
                    │  External LLM         │
                    │  Fetches & uses       │
                    └───────────────────────┘
```

## 3. URL scheme

### 3.1 Official repository only

All fetches are restricted to the official repository:

```
https://raw.githubusercontent.com/jmchantrein/Meta-prompt-LLM/main/...
```

No other domains are allowed.

### 3.2 URL examples

```
# Manifest
https://raw.githubusercontent.com/jmchantrein/Meta-prompt-LLM/main/prompts/fr/metametaprompts/data/manifest.yaml

# Rules
https://raw.githubusercontent.com/jmchantrein/Meta-prompt-LLM/main/prompts/fr/metametaprompts/data/rules/rules.yaml

# Skill
https://raw.githubusercontent.com/jmchantrein/Meta-prompt-LLM/main/prompts/fr/metametaprompts/data/skills/inclusivity-reviewer.yaml

# Prompt
https://raw.githubusercontent.com/jmchantrein/Meta-prompt-LLM/main/prompts/fr/metametaprompts/data/prompts/en/hybrid-ai-bootstrap.md
```

## 4. Data structures

### 4.1 Manifest (`data/manifest.yaml`)

```yaml
# Meta-prompt-LLM Manifest
schema_version: "1.0.0"
last_updated: "2026-02-01T12:00:00Z"
repository: "https://github.com/jmchantrein/Meta-prompt-LLM"

base_url: "https://raw.githubusercontent.com/jmchantrein/Meta-prompt-LLM/main/prompts/fr/metametaprompts/data"

# Integrity hashes
integrity:
  "rules/rules.yaml":
    hash: "sha256:abc123..."
    version: "1.0.0"
  "skills/inclusivity-reviewer.yaml":
    hash: "sha256:def456..."
    version: "1.0.0"
  "prompts/en/hybrid-ai-bootstrap.md":
    hash: "sha256:ghi789..."
    version: "1.2.0"

# Rules
rules:
  version: "1.0.0"
  url: "{base_url}/rules/rules.yaml"

# Skills
skills:
  version: "1.0.0"
  items:
    - id: "inclusivity-reviewer"
      version: "1.0.0"
      url: "{base_url}/skills/inclusivity-reviewer.yaml"

# Prompts
prompts:
  items:
    - id: "hybrid-ai-bootstrap"
      version: "1.2.0"
      language: "en"
      url: "{base_url}/prompts/en/hybrid-ai-bootstrap.md"
      applicable_rules: ["rule-0", "rule-1", "rule-4"]
      applicable_skills: ["prompt-validator"]
```

### 4.2 Prompt META block

Each prompt includes a `<!-- META -->` block with:
- Version info
- Source URL
- **Mini-prompt for update** (copy-paste friendly)
- **One-liner to use this prompt** (copy-paste friendly)

```markdown
<!-- META
prompt_id: "hybrid-ai-bootstrap"
version: "1.2.0"
source_url: "https://raw.githubusercontent.com/jmchantrein/Meta-prompt-LLM/main/prompts/fr/metametaprompts/data/prompts/en/hybrid-ai-bootstrap.md"
applicable_rules: ["rule-0", "rule-1", "rule-4"]
applicable_skills: ["prompt-validator"]
last_updated: "2026-02-01"

# --- COPY-PASTE PROMPTS ---

# One-liner: Use this prompt
use_prompt: "Fetch and apply the prompt from: https://raw.githubusercontent.com/jmchantrein/Meta-prompt-LLM/main/prompts/fr/metametaprompts/data/prompts/en/hybrid-ai-bootstrap.md"

# Mini-prompt: Check for updates
update_prompt: |
  Check if my prompt is up-to-date:
  - My version: 1.2.0
  - Source: https://raw.githubusercontent.com/jmchantrein/Meta-prompt-LLM/main/prompts/fr/metametaprompts/data/prompts/en/hybrid-ai-bootstrap.md
  Fetch the source, compare versions in META block.
  If newer version exists, show me what changed and ask if I want to update.
-->

# Hybrid AI Bootstrap

[prompt content...]
```

### 4.3 Usage scenarios

#### Scenario A: User has a prompt with META block

LLM reads META, fetches source URL, compares versions, proposes update if needed.

#### Scenario B: User has an old prompt without META

User can copy-paste the `update_prompt` from a newer version to enable updates.

#### Scenario C: User wants to use a prompt from scratch

User copy-pastes the `use_prompt` one-liner into their LLM.

## 5. Version check mechanism

### 5.1 Rule-13: version check

```markdown
## Rule 13: version check

At session start, if this prompt has a META block:

1. Read `source_url` and `version` from META
2. Fetch source (if web access available)
3. Compare local version with remote version
4. If remote is newer:
   - Inform user with version diff
   - Show changelog summary
   - Propose: [Update] [Ignore]
5. If same or no web access:
   - Continue normally
```

### 5.2 Simple check flow

```
Session Start
     │
     ▼
Read META block ──► No META? ──► Continue normally
     │
     ▼
Fetch source_url
     │
     ▼
Compare versions
     │
     ├── Same ──► Continue normally
     │
     └── Different ──► Show update notification
                            │
                            ▼
                    User chooses [Update/Ignore]
```

## 6. Validation philosophy

### 6.1 Project validates, not consuming LLMs

LLMs cannot reliably perform deterministic validation tasks:
- YAML structure validation
- Prompt size checks
- Format verification
- Schema compliance

**These are the project's responsibility, not the consuming LLM's.**

### 6.2 Pre-distribution validation

Before any prompt is published to `data/`:

1. `prompt-validator` checks structure and schema
2. `inclusivity-reviewer` checks French content
3. `link-checker` validates internal links
4. Hash and version are calculated
5. Manifest is updated

**Consuming LLMs trust that fetched content is valid.**

## 7. Data-sync agent

### 7.1 Purpose

Synchronizes `data/` to project files:
- `data/skills/*.yaml` → `.ai/skills/*.yaml`
- `data/rules/rules.yaml` → `AGENTS.md` (via generate.sh)

### 7.2 Integrity check at session start

```
1. Read manifest.yaml
2. For each file in data/:
   - Calculate current hash
   - Compare with stored hash
3. If mismatch:
   - Report change
   - Bump version
   - Update manifest
   - Sync to outputs
```

### 7.3 Session start sequence

```
1. memory-keeper --load
2. data-sync --check
3. [normal session]
```

## 8. Design decisions

| Question | Decision | Rationale |
|----------|----------|-----------|
| Branch strategy | `main` only | KISS |
| Cache duration | 1 day | Balance freshness/performance |
| Check frequency | Every session | Keep users informed |
| Allowed domains | Official repo only | Security |
| Prompts location | `data/prompts/` | Single source of truth |
| Validation | Project-side only | LLMs can't do deterministic checks |

## 9. Implementation checklist

- [ ] Create `data/` structure in metametaprompts
- [ ] Move prompts to `data/prompts/`
- [ ] Create `data/manifest.yaml`
- [ ] Create `data/rules/rules.yaml`
- [ ] Copy skills to `data/skills/`
- [ ] Create `data-sync` agent
- [ ] Add rule-13 to AGENTS.md
- [ ] Add META blocks with copy-paste prompts
- [ ] Create CHANGELOGs
- [ ] Update generate.sh
- [ ] Update READMEs

## 10. Security

### 10.1 URL restriction

Only accept URLs matching:
```
https://raw.githubusercontent.com/jmchantrein/Meta-prompt-LLM/main/...
```

### 10.2 User consent

- Never auto-update without confirmation
- Show diff before replacing
- User can always ignore updates

---

*Document version: 0.3.0 - Simplified with KISS, copy-paste prompts, project-side validation*
