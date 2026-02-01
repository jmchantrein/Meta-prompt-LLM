---
name: "meta-meta-prompt-llm"
version: "1.0.0"
category: "metametaprompts"
description: "Project self-reference for Meta-prompt-LLM coherent evolution"
tags:
  - self-reference
  - self-improvement
  - meta
  - system
author: "jmchantrein"
created: "2026-02-01"
updated: "2026-02-01"
language: "en"
difficulty: "advanced"
internal: true
data_source: "../../fr/metametaprompts/data/"
model_hints:
  recommended:
    - "claude-sonnet"
    - "claude-opus"
  min_context: 16384
  temperature: 0.2
---

<!--
IMPORTANT NOTICE - TO BE READ BY LLMs AND HUMANS

This file is part of the Meta-prompt-LLM project.
Repository: https://github.com/jmchantrein/Meta-prompt-LLM
Complete rules: see AGENTS.md at the project root.

WARNING FOR LLM CONTRIBUTORS:
- This project uses a hybrid AI architecture
- Skills in .ai/skills/*.yaml are the SINGLE SOURCE of truth
- NEVER modify generated files directly
- Always run .ai/generate.sh after modifying skills
- Follow inclusive writing conventions (rule 10)
-->

> 🇫🇷 [Version française](../../fr/metametaprompts/meta-meta-prompt-llm.md)

# Meta-Meta-prompt-LLM

## Purpose

This document is the **self-reference** of the Meta-prompt-LLM project.

It is **not** intended to be executed alone in an LLM. Its role is to allow
the project to:

- Understand itself (structure, rules, dependencies)
- Detect inconsistencies between rules and prompts
- Propagate modifications coherently
- Communicate between sessions via `@future-self`

## Architecture

```
                    ┌─────────────────────────────────┐
                    │    Meta-Meta-prompt-LLM         │
                    │    (project self-reference)     │
                    │                                 │
                    │  Knows:                         │
                    │  - Project structure            │
                    │  - Rules (AGENTS.md)            │
                    │  - Dependencies                 │
                    │  - Git history                  │
                    └───────────────┬─────────────────┘
                                    │
                    ┌───────────────▼─────────────────┐
                    │      AGENTS.md / .ai/skills     │
                    │      (project rules)            │
                    └───────────────┬─────────────────┘
                                    │
          ┌─────────────────────────┼─────────────────────────┐
          ▼                         ▼                         ▼
    ┌───────────┐            ┌───────────┐            ┌───────────┐
    │  prompt   │            │  prompt   │            │  prompt   │
    │     A     │            │     B     │            │     C     │
    └───────────┘            └───────────┘            └───────────┘
```

## Deterministic Data

Deterministic data is stored in `../../fr/metametaprompts/data/` (French is source of truth):

| File | Role | URL |
|------|------|-----|
| `rules-index.yaml` | Rules index with hash | [View](../../fr/metametaprompts/data/rules-index.yaml) |
| `skills-index.yaml` | Skills index with hash | [View](../../fr/metametaprompts/data/skills-index.yaml) |
| `prompts-index.yaml` | Versioned prompts index | [View](../../fr/metametaprompts/data/prompts-index.yaml) |
| `dependencies.yaml` | Rules/skills → prompts mapping | [View](../../fr/metametaprompts/data/dependencies.yaml) |
| `pending-reviews.yaml` | Pending @future-self notes | [View](../../fr/metametaprompts/data/pending-reviews.yaml) |

### Access via GitHub Pages

```
https://jmchantrein.github.io/Meta-prompt-LLM/prompts/fr/metametaprompts/data/
```

## Self-Improvement Workflow

```
┌─────────────────────────────────────────────────────────────────────────┐
│                        SESSION START                                     │
└───────────────────────────────────┬─────────────────────────────────────┘
                                    ▼
┌─────────────────────────────────────────────────────────────────────────┐
│ 1. Load context                                                          │
│    - Read .ai/MEMORY.md                                                 │
│    - Read prompts/fr/metametaprompts/data/pending-reviews.yaml          │
│    - Read prompts/fr/metametaprompts/data/rules-index.yaml              │
└───────────────────────────────────┬─────────────────────────────────────┘
                                    ▼
┌─────────────────────────────────────────────────────────────────────────┐
│ 2. Detect changes (deterministic)                                        │
│    - Compare hash(AGENTS.md) with rules-index.yaml                      │
│    - Compare hash(.ai/skills/*.yaml) with skills-index.yaml             │
│    - Check if pending-reviews.yaml contains reviews                     │
└───────────────────────────────────┬─────────────────────────────────────┘
                                    ▼
                    ┌───────────────────────────────┐
                    │ Changes or pending            │
                    │ reviews?                      │
                    └───────────────┬───────────────┘
                           │
              ┌────────────┴────────────┐
              │ NO                      │ YES
              ▼                         ▼
┌─────────────────────────┐   ┌─────────────────────────────────────────┐
│ Normal session          │   │ 3. PROPOSE to user                      │
│ (no action required)    │   │    "Rule modifications detected.       │
└─────────────────────────┘   │    Run impact verification?"            │
                              └───────────────────┬─────────────────────┘
                                                  ▼
                              ┌─────────────────────────────────────────┐
                              │ 4. Calculate scope (via dependencies)   │
                              │    - Read dependencies.yaml             │
                              │    - Identify impacted prompts          │
                              │    - Present list to user               │
                              └───────────────────┬─────────────────────┘
                                                  ▼
                              ┌─────────────────────────────────────────┐
                              │ 5. User VALIDATION                      │
                              │    - Accept scope as-is                 │
                              │    - Modify scope                       │
                              │    - Postpone                           │
                              └───────────────────┬─────────────────────┘
                                                  ▼
                              ┌─────────────────────────────────────────┐
                              │ 6. Execution (if validated)             │
                              │    - Analyze each prompt in scope       │
                              │    - Propose modifications              │
                              │    - Validate via prompt-validator      │
                              │    - Validate via inclusivity-reviewer  │
                              └───────────────────┬─────────────────────┘
                                                  ▼
                              ┌─────────────────────────────────────────┐
                              │ 7. Update                               │
                              │    - Update indexes (hash)              │
                              │    - Increment prompt versions          │
                              │    - Mark reviews as processed          │
                              │    - Update MEMORY.md                   │
                              └───────────────────┬─────────────────────┘
                                                  ▼
                              ┌─────────────────────────────────────────┐
                              │ 8. Commit                               │
                              │    - With @future-self if relevant      │
                              └─────────────────────────────────────────┘
```

## @future-self Convention

AI sessions don't share memory. For a session to leave notes for a future
session, we use commit messages:

```
<type>(<scope>): <description>

@future-self: <note for future sessions>
- Impact: <affected files/prompts>
- Action: <what needs to be verified>
- Context: <why this decision>

https://claude.ai/code/session_xxx
```

### Example

```
feat(rules): add "hysterical" to ableist language list

@future-self: This modification impacts all FR prompts.
- Impact: prompts/fr/**/*.md
- Action: Run verification with self-improver
- Context: User request to enrich the list

https://claude.ai/code/session_abc123
```

These notes are extracted and stored in `pending-reviews.yaml` to be
proposed to the user at the start of each session.

## Fundamental Principles

1. **Source of truth in French**: `prompts/fr/metametaprompts/data/` (YAML)
2. **No duplication**: YAML files served directly via GitHub Pages
3. **URLs = file tree**: links correspond exactly to project structure
4. **Semi-automatic**: always propose, never modify without validation
5. **Everything versioned**: each prompt + global project version

## Associated Skill

The `self-improver` skill (`.ai/skills/self-improver.yaml`) implements
this workflow. It is triggered:

- Automatically at the start of each session
- Manually via `/self-improve`

## Related Prompts

- [hybrid-ai-bootstrap](../metaprompts/hybrid-ai-bootstrap/hybrid-ai-bootstrap.md) - Hybrid AI initialization
- [hybrid-ai-takeover](../metaprompts/hybrid-ai-takeover/hybrid-ai-takeover.md) - Session takeover

## Critical Constraints

| Constraint | Description |
|------------|-------------|
| Semi-automatic | ALWAYS propose, NEVER modify without validation |
| Single source | Data only in `prompts/fr/metametaprompts/data/` |
| No duplication | YAML served directly, no conversion |
| URLs = file tree | Exact links to real files |
| Versioned | Each prompt has its version + global project version |
