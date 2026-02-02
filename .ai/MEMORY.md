# Project memory

> Persistent memory for AI agents. Read at session start, update via `memory-keeper`.

## Project identity

| Property | Value |
|----------|-------|
| Name | Meta-prompt-LLM |
| Type | Prompt framework and collection |
| Created | 2026-01-31 |
| Main language | English (with French translation) |
| Paradigm | Doc-driven + Spec-driven hybrid |

## Description

A framework for creating, modifying, and maintaining prompt collections with:
- Centralized skill definitions in YAML
- Multi-platform generation (Claude Code, Cursor, Ollama, OpenCode, Aider, Continue.dev, Codex, etc.)
- Persistent memory between sessions
- Workflow orchestration for validation
- Bilingual documentation (EN/FR)

## User preferences

| Preference | Value |
|------------|-------|
| Language (interface) | French |
| Language (code/docs) | English |
| Inclusive writing | Yes (French content) |
| Shell standard | Bash (shellcheck-valid) |
| AI tools coverage | Maximum (all platforms) |
| End-of-response summary | Yes (skills, hooks, commands) |

## Technical decisions

| Date | Decision | Reason |
|------|----------|--------|
| 2026-01-31 | Doc-driven + Spec-driven paradigm | Meta-project about prompts; docs ARE the product |
| 2026-01-31 | YAML as single source for skills | DRY principle; generate platform-specific files |
| 2026-01-31 | Bash-only for generate.sh | Maximize portability, LLM-only stack |
| 2026-01-31 | AGENTS.md standard adopted | Industry consensus, Linux Foundation backing |
| 2026-01-31 | Bilingual EN/FR documentation | User preference, inclusivity |
| 2026-02-01 | Meta-Meta-prompt-LLM system | Self-reference for coherent project evolution |
| 2026-02-01 | Data in FR as source of truth | YAML data in prompts/fr/metametaprompts/data/ |
| 2026-02-01 | GitHub Pages for data access | YAML served directly, no duplication |
| 2026-02-01 | Rule 15: mandatory post-review | Ensures memory update and self-improver run |
| 2026-02-02 | KISS for data/ structure | Simplified from nested to flat structure (2994926) |
| 2026-02-02 | Hooks in source of truth | hooks.yaml in data/ generates platform configs |
| 2026-02-02 | SessionStart hook needed | Initialize session BEFORE user input |
| 2026-02-02 | Stop hook for consistency | Agent-based check after each Claude response |
| 2026-02-02 | Visual feedback for agents | Show agent hierarchy/nesting during session |
| 2026-02-02 | Multi-platform hook generation | generate.sh creates configs for all supported LLMs |
| 2026-02-02 | Platform detection at SessionStart | Show LLM capabilities/limitations automatically |
| 2026-02-02 | Maximize LLM support rule | Always implement for ALL platforms, not just Claude |

## Evolution history

> **Note**: Ces versions sont sémantiques pour le projet. Le fichier `.ai/VERSION` (format `1.0.0-hash`) est différent : c'est un hash de détection de changements pour generate.sh.

| Version | Date | Changes |
|---------|------|---------|
| 0.1.0 | 2026-01-31 | Initial architecture bootstrap |
| 0.2.0 | 2026-02-01 | Meta-Meta-prompt-LLM system for self-improvement |
| 0.3.0 | 2026-02-02 | Hooks system, workflow-documenter, architecture docs |

## Session history

| Date | Session | Key commits | Summary |
|------|---------|-------------|---------|
| 2026-01-31 | PR #1 | a93cd40→d08129a | Initial bootstrap: prompt structure, link-checker, hybrid-ai-takeover |
| 2026-02-01 | PR #2 | 6853193→95d71e9 | Rule 15, README notices for LLM contribution |
| 2026-02-01 | PR #3 | 268b72e→a91ec36 | Self-improver, orchestrator workflows |
| 2026-02-01 | - | 616c005→8beaafb | Version check system (spec→impl) |
| 2026-02-01 | - | 15bd248→0fa9ba7 | Socratic-tutor prompt, audit fixes |
| 2026-02-02 | PR #4 | 2994926→d1876f9 | KISS refactor, hooks-manager skill |
| 2026-02-02 | PR #5 | fc1c3db→c1e0b88 | Workflow-documenter, architecture docs |
| 2026-02-02 | PR #6 (bq507) | 5c703b4→a5cfb24 | Complete hooks lifecycle, multi-platform generation, platform detection (branche nommée "french-support" par erreur) |
| 2026-02-02 | 4fPY2 | 5b04efe→825b6b5 | Clarified 6 inconsistencies, session-status skill, coherence-check hook, visual-feedback hooks |
| 2026-02-02 | 3jXvo | 8c8da0b→ | Research missing skills, license audit, package-manager skill, internal/external structure |

## Lessons learned

| Date | Lesson | Context |
|------|--------|---------|
| 2026-01-31 | Research before implementation | BMAD, Kiro, AGENTS.md standards inform architecture |
| 2026-02-01 | Semi-automatic propagation | Always propose, never modify without validation |
| 2026-02-01 | @future-self convention | Use commit messages to communicate between sessions |
| 2026-02-02 | KISS principle for data/ | Flat structure better than nested (2994926) |
| 2026-02-02 | Source of truth = data/ | .ai/ is generated, never edit directly |
| 2026-02-02 | SessionStart exists | Hook event runs BEFORE user input, not just UserPromptSubmit |
| 2026-02-02 | Stop hook for consistency | Agent-type hook can validate and continue if needed |
| 2026-02-02 | MEMORY.md not auto-updated | ~~Sessions without memory-keeper invocation lose context~~ **OBSOLÈTE**: Stop hook consistency-check vérifie maintenant automatiquement |
| 2026-02-02 | Maximize LLM support always | Never implement for one platform only; always all supported LLMs |
| 2026-02-02 | Platform detection proactive | Detect LLM at session start, show limitations without asking |
| 2026-02-02 | Skill vs Agent terminology | Skill = YAML source file, Agent = Claude Code runtime. Interchangeable. |
| 2026-02-02 | VERSION file ≠ project version | .ai/VERSION is hash for generate.sh change detection, not semver |
| 2026-02-02 | User hooks can extend project hooks | ~/.claude/ hooks (like git-check) add to project .claude/settings.json |
| 2026-02-02 | Visual feedback via PostToolUse | Hooks can show context (🧠/📦/🔧) based on file patterns |
| 2026-02-02 | MEMORY.md inconsistent | .ai/MEMORY.md violates "source of truth = data/" rule - needs refactor |
| 2026-02-02 | External skills need installer | Cannot manually maintain 626+ skills - need package-manager agent |
| 2026-02-02 | License audit before install | MIT collections OK (fetch), Anthropic Commercial (reference only) |

## Current context

### Active work

- **[DONE]** Complete hooks lifecycle (SessionStart, Stop, SessionEnd)
- **[DONE]** Visual feedback system for agent hierarchy
- **[DONE]** Multi-platform hook generation (Cursor, OpenCode, Codex)
- **[DONE]** Platform detection at SessionStart with capabilities/limitations
- **[DONE]** Self-improver skill functional with dependencies.yaml
- GitHub Pages setup for data access
- **[TODO]** Move MEMORY.md to data/ source of truth (deferred)
- **[DONE]** Create package-manager skill for external installs
- **[DONE]** Create registries.yaml with license audit
- **[DONE]** Restructure data/ with internal/external split

### Pending decisions

- **[IMPLEMENTED]** package-manager architecture (registries.yaml + internal/external split)
- **[IMPLEMENTED]** License audit completed - MIT collections OK, Anthropic reference-only

### Blockers

- None currently

## Available skills (aka agents)

> **Terminologie** :
> - **Skill** = fichier YAML de définition (`.ai/skills/*.yaml`)
> - **Agent** = sous-agent Claude Code généré à partir du skill
>
> Les termes sont interchangeables dans ce projet. "Skill" est le terme source, "agent" est le terme runtime.

| Skill | Purpose | Status |
|-------|---------|--------|
| data-sync | Syncs data/ to .ai/ and validates integrity | Active |
| hooks-manager | Multi-platform hook generation from YAML | Active |
| inclusivity-reviewer | Inclusive writing, non-ableist language | Active |
| link-checker | Internal link validation in markdown | Active |
| memory-keeper | Persistent memory management | Active |
| package-manager | External skills/hooks/commands from registries | Active |
| prompt-validator | Prompt validation against schema | Active |
| self-improver | Project self-improvement and rule propagation | Active |
| session-status | End-of-response visual summary via Stop hook | Active |
| translator | EN/FR translation, sync | Active |
| workflow-documenter | Generates workflow documentation | Active |
| workflow-orchestrator | Multi-agent orchestration | Active |

## Missing recognized skills roadmap

> Identified 2026-02-02 via research on Vercel, Antigravity, VoltAgent, GitHub collections.

### Priority 1 (industry consensus)

| Skill | Category | Sources |
|-------|----------|---------|
| security-auditor | Security | Snyk, OWASP, all collections |
| test-generator | Testing | Qodo, TDD patterns, Superpowers |
| code-reviewer | Quality | CodeRabbit, Qodo Merge, all collections |

### Priority 2 (high demand)

| Skill | Category | Sources |
|-------|----------|---------|
| api-documenter | Documentation | OpenAPI/Swagger ecosystem |
| debugger | Troubleshooting | JetBrains, all IDEs |
| react-best-practices | Framework | Vercel official (40+ rules) |

### Priority 3 (nice to have)

| Skill | Category | Sources |
|-------|----------|---------|
| changelog-generator | Documentation | Conventional Commits |
| dependency-checker | Security | npm audit, Snyk |
| migration-assistant | Refactoring | AWS Transform, ModLogix |
| tdd-workflow | Testing | Superpowers, Builder.io |

### Reference collections

- [vercel-labs/agent-skills](https://github.com/vercel-labs/agent-skills) - Official Vercel skills
- [antigravity-awesome-skills](https://github.com/sickn33/antigravity-awesome-skills) - 626+ skills
- [VoltAgent/awesome-agent-skills](https://github.com/VoltAgent/awesome-agent-skills) - Community skills

### License audit (2026-02-02)

| Collection | License | Redistribution | Install method |
|------------|---------|----------------|----------------|
| vercel-labs/agent-skills | MIT | OK with attribution | fetch |
| antigravity-awesome-skills | MIT | OK with attribution | fetch |
| VoltAgent/awesome-agent-skills | MIT | OK with attribution | fetch |
| obra/superpowers | MIT | OK with attribution | fetch |
| anthropics/claude-code | Commercial | Reference only | link |

> **Conclusion**: 4/5 collections can be freely installed (MIT). Anthropic skills must be referenced via URL only, not redistributed.

## Architectural inconsistencies discovered

> Identified 2026-02-02 session 3jXvo. Requires refactoring.

| Issue | Current state | Target state | Priority |
|-------|---------------|--------------|----------|
| MEMORY.md not in data/ | `.ai/MEMORY.md` edited directly | `data/memory/MEMORY.yaml` as source | HIGH |
| No external skill install | Manual copy of external skills | `package-manager` skill with registries | HIGH |
| No external hook install | N/A | Same system as skills | MEDIUM |
| No command management | N/A | Same system as skills/hooks | MEDIUM |

### Proposed architecture

```
data/
├── memory/
│   └── MEMORY.yaml           # Source of truth (structured YAML)
├── skills/
│   ├── internal/             # Project skills
│   └── external/             # Installed from registries
├── hooks/
│   ├── internal/
│   └── external/
├── commands/                 # NEW
│   ├── internal/
│   └── external/
├── registries.yaml           # External sources (Vercel, Antigravity, etc.)
└── manifest.yaml             # Central index with versions
```

### New skill needed: package-manager

- `@package-manager install vercel/react-best-practices`
- `@package-manager update` (check all registries)
- `@package-manager list` (installed skills/hooks/commands)
- `@package-manager remove <id>`

## Notes

- All prompts must follow `prompts/_TEMPLATE.md`
- Run `generate.sh` after any skill modification
- French content must use inclusive writing
- **Source of truth**: `prompts/fr/metametaprompts/data/`
- **Generated files**: `.ai/` (never edit directly)
- Use `@future-self` in commits to leave notes for future sessions

## Hook Lifecycle (implemented 2026-02-02)

```
┌─ SessionStart ─────────────────────────────────────────────┐
│  📋 [platform-detect] Détecte LLM et affiche limitations  │
│  🔧 [data-sync] Vérifie synchronisation data/ → .ai/      │
│  🔧 [generate] Vérifie si régénération nécessaire         │
│  🧠 [memory-keeper] Charge .ai/MEMORY.md dans le contexte │
│  🔄 [self-improver] Vérifie les changements de règles     │
│  🔍 [coherence-check] Détecte orphelins et boucles        │
└────────────────────────────────────────────────────────────┘
                            ↓
┌─ UserPromptSubmit ─────────────────────────────────────────┐
│  📋 Feedback discret: "Session active | Mémoire: ..."     │
└────────────────────────────────────────────────────────────┘
                            ↓
┌─ PreToolUse ───────────────────────────────────────────────┐
│  Guardrails: .env, credentials, destructive ops, .ai/     │
└────────────────────────────────────────────────────────────┘
                            ↓
┌─ PostToolUse ──────────────────────────────────────────────┐
│  📦 [generate] Auto-régénère si skill modifié             │
│  🔧 [data-sync] Auto-sync si data/ modifié                │
│  🔍 [inclusivity] Rappel si contenu FR modifié            │
│  🌍 [translator] Rappel si doc EN modifié                 │
└────────────────────────────────────────────────────────────┘
                            ↓
┌─ Stop ─────────────────────────────────────────────────────┐
│  ✅ [consistency-check] Agent vérifie si MEMORY.md        │
│     doit être mis à jour. Si oui, continue la session.    │
│  📊 [session-status] Affiche synthèse skills/hooks/cmds   │
│  Note: hooks utilisateur (~/.claude/) peuvent s'ajouter   │
└────────────────────────────────────────────────────────────┘
                            ↓
┌─ SessionEnd ───────────────────────────────────────────────┐
│  📝 Rappel final de mise à jour mémoire                   │
└────────────────────────────────────────────────────────────┘
```

## Platform Support Matrix

| Platform | Rating | Limitations |
|----------|--------|-------------|
| Claude Code | ★★★★★ | None - all 6 events + agent hooks |
| Cursor | ★★★★☆ | No SessionStart, no agent hooks |
| OpenCode | ★★★☆☆ | Requires oh-my-opencode plugin |
| Codex CLI | ★★☆☆☆ | Only notify on agent-turn-complete |
| Aider | ★☆☆☆☆ | No hooks, only auto_lint/test_cmd |
| Continue.dev | ★☆☆☆☆ | Data events only, no command hooks |

## Visual Feedback Convention

| Emoji | Agent | Purpose |
|-------|-------|---------|
| 🔧 | [data-sync] | Synchronisation data/ → .ai/ |
| 🔧 | [generate] | Génération de fichiers |
| 🧠 | [memory-keeper] | Gestion mémoire |
| 🔄 | [self-improver] | Auto-amélioration |
| ✅ | [consistency-check] | Vérification post-réponse |
| 🔍 | [inclusivity] | Écriture inclusive |
| 🌍 | [translator] | Synchronisation EN/FR |
| 📦 | - | Skill/règle modifié |
| 📋 | - | Information générale |
| ⚠️ | - | Attention requise |
| ❌ | - | Échec |

---

*Last updated: 2026-02-02 by memory-keeper (session 3jXvo: package-manager skill, registries.yaml, internal/external structure)*
