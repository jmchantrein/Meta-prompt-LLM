# Version Check and Self-Update System

> **Status**: DRAFT - Updated with decisions
> **Version**: 0.2.0
> **Date**: 2026-02-01

## 1. Overview

### 1.1 Problem statement

When a prompt from the Meta-prompt-LLM collection is copied and used in another project:
- It becomes disconnected from its source
- It cannot access associated rules and skills
- Users are unaware of updates and improvements

### 1.2 Objectives

1. **Deterministic retrieval**: Prompts can fetch their associated rules/skills via URLs
2. **Version tracking**: Each prompt has a semantic version
3. **Self-checking**: At session start, prompts verify if updates are available
4. **User control**: Updates are proposed, never forced

### 1.3 Principles

- **Non-intrusive**: User decides whether to update
- **Transparent**: Changelog explains what changed
- **Deterministic**: Version numbers, no ambiguity
- **Autonomous**: Prompts know how to check themselves

## 2. Architecture

### 2.1 Current vs proposed

```
CURRENT:
.ai/skills/*.yaml  ──► generate.sh ──► AGENTS.md
                                         │
prompts/**/*.md ◄────────────────────────┘ (manual sync)

PROPOSED:
data/
├── manifest.yaml        ──► GitHub raw URL ──► LLM fetches
├── rules/
├── skills/
└── prompts/

prompts/**/*.md
└── <!-- META --> block  ──► Contains URLs + version
         │
         └──► At session start: fetch manifest, compare versions
```

### 2.2 Data flow

```
┌─────────────────────────────────────────────────────────────────┐
│                        Meta-prompt-LLM repo                     │
├─────────────────────────────────────────────────────────────────┤
│  data/manifest.yaml ◄──────────────────────────────┐            │
│       │                                            │            │
│       ▼                                            │            │
│  GitHub raw URL                                    │            │
│  https://raw.githubusercontent.com/.../manifest.yaml            │
└───────────────────────────────┬─────────────────────────────────┘
                                │
                                ▼
┌─────────────────────────────────────────────────────────────────┐
│                     User's project (elsewhere)                  │
├─────────────────────────────────────────────────────────────────┤
│  prompt-copy.md                                                 │
│  ├── <!-- META                                                  │
│  │   prompt_id: "hybrid-ai-bootstrap"                           │
│  │   version: "1.1.0"                                           │
│  │   manifest_url: "https://raw.githubusercontent.com/..."      │
│  │   -->                                                        │
│  │                                                              │
│  └── LLM reads META ──► fetches manifest ──► compares versions  │
│                                │                                │
│                                ▼                                │
│                    "Update available: 1.1.0 → 1.2.0"            │
│                    [Update] [Ignore] [Details]                  │
└─────────────────────────────────────────────────────────────────┘
```

## 3. Data structures

### 3.1 Manifest (`data/manifest.yaml`)

The central index served via GitHub raw URL.

```yaml
# Meta-prompt-LLM Manifest
# Source of truth for versions and URLs

schema_version: "1.0.0"
last_updated: "2026-02-01T12:00:00Z"
repository: "https://github.com/jmchantrein/Meta-prompt-LLM"

base_urls:
  raw: "https://raw.githubusercontent.com/jmchantrein/Meta-prompt-LLM/main"
  pages: "https://jmchantrein.github.io/Meta-prompt-LLM"

# Rules from AGENTS.md
rules:
  version: "1.0.0"
  source_url: "{base_urls.raw}/data/rules/rules.yaml"
  changelog_url: "{base_urls.raw}/data/rules/CHANGELOG.md"

# Skills definitions
skills:
  version: "1.0.0"
  index_url: "{base_urls.raw}/data/skills/index.yaml"
  changelog_url: "{base_urls.raw}/data/skills/CHANGELOG.md"
  items:
    - id: "inclusivity-reviewer"
      version: "1.0.0"
      url: "{base_urls.raw}/data/skills/inclusivity-reviewer.yaml"
    - id: "prompt-validator"
      version: "1.0.0"
      url: "{base_urls.raw}/data/skills/prompt-validator.yaml"
    # ... other skills

# Prompts collection
prompts:
  index_url: "{base_urls.raw}/data/prompts/index.yaml"
  changelog_url: "{base_urls.raw}/data/prompts/CHANGELOG.md"
  items:
    - id: "hybrid-ai-bootstrap"
      version: "1.2.0"
      category: "metaprompts"
      language: "en"
      url: "{base_urls.raw}/prompts/en/metaprompts/hybrid-ai-bootstrap/hybrid-ai-bootstrap.md"
      applicable_rules: ["rule-0", "rule-1", "rule-2", "rule-4"]
      applicable_skills: ["prompt-validator"]
    # ... other prompts
```

### 3.2 Prompt metadata block

Each prompt includes a `<!-- META -->` block (HTML comment for compatibility).

```markdown
<!-- META
prompt_id: "hybrid-ai-bootstrap"
version: "1.2.0"
manifest_url: "https://raw.githubusercontent.com/jmchantrein/Meta-prompt-LLM/main/data/manifest.yaml"
source_url: "https://raw.githubusercontent.com/jmchantrein/Meta-prompt-LLM/main/prompts/en/metaprompts/hybrid-ai-bootstrap/hybrid-ai-bootstrap.md"
applicable_rules:
  - rule-0
  - rule-1
  - rule-2
  - rule-4
applicable_skills:
  - prompt-validator
last_updated: "2026-02-01"
-->

# Hybrid AI Bootstrap

[prompt content...]
```

### 3.3 Rules data (`data/rules/rules.yaml`)

```yaml
# Rules extracted from AGENTS.md for remote access

schema_version: "1.0.0"
source_file: "AGENTS.md"
version: "1.0.0"

rules:
  - id: "rule-0"
    name: "honesty"
    description: "Right to not know, to ask for clarification"
    instruction: |
      - Never invent facts, never pretend
      - Acknowledge uncertainty when present

  - id: "rule-1"
    name: "state of the art and consensus"
    description: "Consult official documentation before acting"
    instruction: |
      - Search for solutions that have consensus
      - Prefer established patterns over novel approaches

  # ... other rules
```

### 3.4 Changelog format (`data/prompts/CHANGELOG.md`)

```markdown
# Prompts Changelog

## [1.2.0] - 2026-02-01

### hybrid-ai-bootstrap
- **Added**: Persistent memory support (rule-11)
- **Changed**: Updated inclusive writing section
- **Fixed**: Schema validation edge case

### hybrid-ai-takeover
- **Added**: Version check instruction

## [1.1.0] - 2026-01-30

### hybrid-ai-bootstrap
- **Added**: Initial release with core functionality
```

## 4. Version check mechanism

### 4.1 New rule: rule-13 (version check)

To be added to AGENTS.md:

```markdown
## Rule 13: version check

At session start, if this prompt originates from Meta-prompt-LLM:

1. Read the `<!-- META -->` block
2. Extract `manifest_url` and `version`
3. Fetch the manifest (if web access available)
4. Compare local version with remote version
5. If different:
   - Inform the user
   - Show changelog summary
   - Propose: [Update] [Ignore] [View details]
6. If same or no web access:
   - Continue normally
```

### 4.2 Check algorithm (pseudocode)

```
function checkVersion():
    meta = parseMetaBlock(prompt)
    if meta is null:
        return  // Not a Meta-prompt-LLM prompt

    try:
        manifest = fetch(meta.manifest_url)
    catch NetworkError:
        log("Version check skipped: no network access")
        return

    remote_prompt = manifest.prompts.find(id == meta.prompt_id)
    if remote_prompt is null:
        warn("Prompt not found in manifest")
        return

    if semver.gt(remote_prompt.version, meta.version):
        displayUpdateNotification(
            local: meta.version,
            remote: remote_prompt.version,
            changelog: fetch(manifest.prompts.changelog_url)
        )
```

### 4.3 User interaction flow

```
┌────────────────────────────────────────────────────────────┐
│  🔄 Version check...                                       │
├────────────────────────────────────────────────────────────┤
│                                                            │
│  ⚠️  Update available!                                     │
│                                                            │
│  Prompt: hybrid-ai-bootstrap                               │
│  Local version:  1.1.0                                     │
│  Remote version: 1.2.0                                     │
│                                                            │
│  Changes in 1.2.0:                                         │
│  • Added: Persistent memory support (rule-11)              │
│  • Changed: Updated inclusive writing section              │
│  • Fixed: Schema validation edge case                      │
│                                                            │
│  ┌──────────┐  ┌──────────┐  ┌──────────────┐              │
│  │  Update  │  │  Ignore  │  │ View details │              │
│  └──────────┘  └──────────┘  └──────────────┘              │
│                                                            │
└────────────────────────────────────────────────────────────┘
```

## 5. Update workflow

### 5.1 Update options

| Option | Action |
|--------|--------|
| **Update** | Fetch new version, show diff, replace content |
| **Ignore** | Skip this version (optionally remember choice) |
| **View details** | Show full changelog and diff |

### 5.2 Update process

1. Fetch new prompt content from `source_url`
2. Show diff between local and remote
3. User confirms replacement
4. Update `<!-- META -->` block with new version
5. Log update in session

### 5.3 Partial updates

For prompts with local modifications:

```
⚠️  Your prompt has local modifications.

Options:
1. [Replace all] - Overwrite with new version (lose local changes)
2. [Show diff]   - Compare local vs remote
3. [Merge]       - Attempt automatic merge (may require manual resolution)
4. [Keep local]  - Keep your version, update META only
```

## 6. Directory structure

### 6.1 New `data/` structure

```
data/
├── manifest.yaml              # Central index
├── rules/
│   ├── rules.yaml            # All rules in YAML
│   ├── CHANGELOG.md          # Rules changelog
│   └── schema.json           # Validation schema (optional)
├── skills/
│   ├── index.yaml            # Skills index
│   ├── CHANGELOG.md          # Skills changelog
│   ├── inclusivity-reviewer.yaml
│   ├── prompt-validator.yaml
│   └── ... (other skills)
└── prompts/
    ├── index.yaml            # Prompts index with versions
    └── CHANGELOG.md          # Prompts changelog
```

### 6.2 Relationship with existing structure

| Existing | New (data/) | Relationship |
|----------|-------------|--------------|
| `AGENTS.md` | `data/rules/rules.yaml` | Rules extracted to YAML |
| `.ai/skills/*.yaml` | `data/skills/*.yaml` | Copy or symlink |
| `prompts/**/*.md` | `data/prompts/index.yaml` | Index only, prompts stay in place |

### 6.3 Generation flow

```
data/rules/rules.yaml  ─────┐
                            ├──► generate.sh ──► AGENTS.md
data/skills/*.yaml     ─────┘

data/prompts/index.yaml ◄─── generate.sh reads prompts/**/*.md
```

## 7. URL scheme

### 7.1 Base URLs

| Type | URL pattern |
|------|-------------|
| Raw content | `https://raw.githubusercontent.com/jmchantrein/Meta-prompt-LLM/main/...` |
| GitHub Pages | `https://jmchantrein.github.io/Meta-prompt-LLM/...` |

### 7.2 Recommended: Raw URLs

Raw URLs are preferred because:
- Direct content access (no HTML wrapper)
- Always in sync with repository
- No GitHub Pages configuration required
- Easier for LLMs to parse

### 7.3 URL examples

```
# Manifest
https://raw.githubusercontent.com/jmchantrein/Meta-prompt-LLM/main/data/manifest.yaml

# Rules
https://raw.githubusercontent.com/jmchantrein/Meta-prompt-LLM/main/data/rules/rules.yaml

# Specific skill
https://raw.githubusercontent.com/jmchantrein/Meta-prompt-LLM/main/data/skills/inclusivity-reviewer.yaml

# Specific prompt
https://raw.githubusercontent.com/jmchantrein/Meta-prompt-LLM/main/prompts/en/metaprompts/hybrid-ai-bootstrap/hybrid-ai-bootstrap.md
```

## 8. Backward compatibility

### 8.1 Prompts without META block

- Continue to work normally
- No version check performed
- No update notifications

### 8.2 Migration path

1. Add `<!-- META -->` block to existing prompts
2. Initialize all versions at `1.0.0`
3. Increment on subsequent changes

### 8.3 Graceful degradation

| Scenario | Behavior |
|----------|----------|
| No META block | Normal execution, no check |
| No network access | Log message, continue normally |
| Manifest unavailable | Warning, continue normally |
| Invalid version | Warning, continue normally |

## 9. Security considerations

### 9.1 URL validation

- Only accept URLs from known domains (github.com, githubusercontent.com)
- Validate URL format before fetching
- Timeout on slow responses

### 9.2 Content validation

- Verify YAML/Markdown structure
- Reject malformed content
- Size limits on fetched content

### 9.3 User consent

- Never auto-update without user confirmation
- Show full diff before replacing
- Option to ignore specific versions

## 10. Implementation checklist

- [ ] Create `data/` directory structure
- [ ] Create `data/manifest.yaml`
- [ ] Create `data/rules/rules.yaml` from AGENTS.md
- [ ] Copy/adapt skills to `data/skills/`
- [ ] Create `data/prompts/index.yaml`
- [ ] Add rule-13 to AGENTS.md
- [ ] Update `generate.sh` to maintain data/ sync
- [ ] Add `<!-- META -->` to prompt template
- [ ] Inject META blocks into existing prompts
- [ ] Create CHANGELOGs
- [ ] Update README.md with new architecture
- [ ] Update README.fr.md (translation)
- [ ] Test version check with sample prompt

## 11. Design decisions

| Question | Decision | Rationale |
|----------|----------|-----------|
| Branch strategy | `main` only | Simplicity, single source of truth |
| Cache duration | 1 day | Balance between freshness and performance |
| Check frequency | Every session | Ensure users are always informed |
| Skills copying | Duplication + sync agent | data/ is source of truth, sync to .ai/skills/ |

## 12. Data-sync agent

### 12.1 Purpose

New agent responsible for:
1. Synchronizing `data/` → `.ai/skills/`, `AGENTS.md`, etc.
2. At session start: verifying hash integrity
3. If hash mismatch: recalculate hash, bump version

### 12.2 Agent specification

```yaml
name: "data-sync"
version: "1.0.0"
description: "Synchronizes data/ to project files and validates integrity"
category: "core"

triggers:
  automatic: true  # Runs at session start
  patterns:
    - "data/**/*.yaml"
    - "data/**/*.md"
  commands:
    - "/data-sync"
    - "/sync"
    - "/integrity-check"

context:
  files:
    - "data/manifest.yaml"
    - "data/rules/rules.yaml"
    - "data/skills/*.yaml"
    - "data/prompts/index.yaml"
  outputs:
    - ".ai/skills/*.yaml"
    - "AGENTS.md"
    - "prompts/**/*.md"  # META blocks

instructions:
  role: |
    Tu es l'agent responsable de la synchronisation des données
    et de l'intégrité du projet Meta-prompt-LLM.

    ## Source de vérité

    `data/` est la source unique de vérité pour :
    - Règles (data/rules/rules.yaml)
    - Skills (data/skills/*.yaml)
    - Index des prompts (data/prompts/index.yaml)

    ## Fichiers générés (outputs)

    - `.ai/skills/*.yaml` : Copie depuis data/skills/
    - `AGENTS.md` : Généré depuis data/rules/ et data/skills/
    - `prompts/**/*.md` : Bloc META injecté/mis à jour

  process: |
    ## Processus au début de session

    ### 1. Vérification d'intégrité

    Pour chaque fichier dans data/ :
    ```
    current_hash = sha256(file_content)
    stored_hash = manifest.items[file_id].hash

    if current_hash != stored_hash:
        # Fichier modifié manuellement
        report_change(file_id, stored_hash, current_hash)
    ```

    ### 2. Si changements détectés

    ```
    🔄 Changements détectés dans data/

    | Fichier | Action requise |
    |---------|----------------|
    | data/skills/new-skill.yaml | Nouveau fichier |
    | data/rules/rules.yaml | Hash modifié |

    Actions proposées :
    1. Recalculer les hash dans manifest.yaml
    2. Incrémenter les versions concernées
    3. Synchroniser vers .ai/skills/ et AGENTS.md
    4. Mettre à jour les blocs META des prompts

    Procéder ? [Oui / Non / Détails]
    ```

    ### 3. Synchronisation (si validé)

    1. **Skills** : data/skills/*.yaml → .ai/skills/*.yaml
    2. **Rules** : data/rules/rules.yaml → AGENTS.md (via generate.sh)
    3. **Prompts** : Mettre à jour les blocs META avec nouvelles versions
    4. **Manifest** : Mettre à jour hash et timestamps

    ### 4. Versioning automatique

    Règles de bump de version :
    - Nouveau fichier : 1.0.0
    - Hash changé (contenu modifié) : bump patch (1.0.0 → 1.0.1)
    - Structure changée : bump minor (1.0.0 → 1.1.0)
    - Breaking change : bump major (1.0.0 → 2.0.0, manuel)

  output_format: |
    ## Rapport de synchronisation

    ```
    ✅ Synchronisation data-sync terminée

    ### Fichiers vérifiés
    - data/rules/rules.yaml: ✅ Intègre
    - data/skills/inclusivity-reviewer.yaml: ⚠️ Modifié
    - data/skills/new-skill.yaml: 🆕 Nouveau

    ### Actions effectuées
    - [x] Hash recalculé pour inclusivity-reviewer
    - [x] Version bump: 1.0.0 → 1.0.1
    - [x] Copié vers .ai/skills/inclusivity-reviewer.yaml
    - [x] new-skill.yaml ajouté (v1.0.0)
    - [x] AGENTS.md régénéré
    - [x] manifest.yaml mis à jour

    ### Commit suggéré
    feat(data): sync data changes to project

    @future-self: data-sync completed, all hashes verified.
    ```

constraints:
  must:
    - "TOUJOURS vérifier l'intégrité avant synchronisation"
    - "TOUJOURS proposer avant de synchroniser"
    - "TOUJOURS mettre à jour le manifest après modification"
    - "TOUJOURS utiliser le versioning sémantique"
  must_not:
    - "JAMAIS modifier data/ sans validation utilisateur"
    - "JAMAIS écraser des modifications locales sans confirmation"
    - "JAMAIS synchroniser si les hash ne sont pas vérifiés"
```

### 12.3 Integrity verification flow

```
┌─────────────────────────────────────────────────────────────┐
│                    Session Start                            │
└─────────────────────────────┬───────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│  data-sync: Read manifest.yaml                              │
│  Extract stored hashes for all files                        │
└─────────────────────────────┬───────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│  For each file in data/:                                    │
│    current_hash = sha256(file)                              │
│    if current_hash != stored_hash:                          │
│      mark as MODIFIED                                       │
└─────────────────────────────┬───────────────────────────────┘
                              │
              ┌───────────────┴───────────────┐
              │                               │
              ▼                               ▼
┌─────────────────────────┐     ┌─────────────────────────────┐
│  No changes detected    │     │  Changes detected           │
│  ✅ Continue normally   │     │  Propose sync actions       │
└─────────────────────────┘     └──────────────┬──────────────┘
                                               │
                                               ▼
                                ┌─────────────────────────────┐
                                │  User validates?            │
                                │  [Yes] → Execute sync       │
                                │  [No]  → Skip, warn         │
                                └─────────────────────────────┘
```

### 12.4 Manifest with hashes

Updated manifest structure to include content hashes:

```yaml
# data/manifest.yaml

schema_version: "1.0.0"
last_updated: "2026-02-01T12:00:00Z"
last_sync: "2026-02-01T12:00:00Z"

# Integrity hashes for all data files
integrity:
  "data/rules/rules.yaml":
    hash: "sha256:abc123..."
    version: "1.0.0"
    last_modified: "2026-02-01T12:00:00Z"

  "data/skills/inclusivity-reviewer.yaml":
    hash: "sha256:def456..."
    version: "1.0.0"
    last_modified: "2026-02-01T12:00:00Z"

  "data/skills/prompt-validator.yaml":
    hash: "sha256:ghi789..."
    version: "1.0.0"
    last_modified: "2026-02-01T12:00:00Z"

# ... rest of manifest (rules, skills, prompts sections)
```

## 13. Updated architecture

### 13.1 Complete data flow

```
┌─────────────────────────────────────────────────────────────────────┐
│                         data/ (Source of Truth)                     │
├─────────────────────────────────────────────────────────────────────┤
│  manifest.yaml ◄─── Contains hashes + versions                      │
│  rules/rules.yaml                                                   │
│  skills/*.yaml                                                      │
│  prompts/index.yaml                                                 │
└───────────────────────────────┬─────────────────────────────────────┘
                                │
                                │ data-sync agent
                                │ (verifies hashes, syncs)
                                │
        ┌───────────────────────┼───────────────────────┐
        │                       │                       │
        ▼                       ▼                       ▼
┌───────────────┐     ┌─────────────────┐     ┌─────────────────────┐
│ .ai/skills/   │     │   AGENTS.md     │     │  prompts/**/*.md    │
│ *.yaml        │     │   (generated)   │     │  (META blocks)      │
│ (copies)      │     │                 │     │                     │
└───────────────┘     └─────────────────┘     └─────────────────────┘
                                │
                                │ GitHub raw URL
                                │
                                ▼
                    ┌───────────────────────┐
                    │  External LLM         │
                    │  Fetches manifest     │
                    │  Checks versions      │
                    └───────────────────────┘
```

### 13.2 Agent responsibilities

| Agent | Responsibility |
|-------|---------------|
| **data-sync** | Integrity check, sync data/ → outputs |
| **self-improver** | Detect rule/skill changes, propose propagation |
| **generate.sh** | Generate AGENTS.md from data/ |

### 13.3 Session start sequence

```
1. memory-keeper --load     # Load context
2. data-sync --check        # Verify integrity, sync if needed
3. self-improver --check    # Check for rule/skill propagation
4. [normal session]
```

## 14. Updated implementation checklist

- [ ] Create `data/` directory structure
- [ ] Create `data/manifest.yaml` with integrity hashes
- [ ] Create `data/rules/rules.yaml` from AGENTS.md
- [ ] Copy skills to `data/skills/`
- [ ] Create `data/prompts/index.yaml`
- [ ] **Create `data-sync` skill in `.ai/skills/data-sync.yaml`**
- [ ] **Update `workflow-orchestrator` to include data-sync**
- [ ] Add rule-13 to AGENTS.md (version check)
- [ ] Update `generate.sh` to read from data/
- [ ] Add `<!-- META -->` to prompt template
- [ ] Inject META blocks into existing prompts
- [ ] Create CHANGELOGs
- [ ] Update README.md with new architecture
- [ ] Update README.fr.md (translation)
- [ ] Test integrity check with modified file
- [ ] Test version check with sample prompt

---

*Document version: 0.2.0 - Updated with design decisions and data-sync agent*
