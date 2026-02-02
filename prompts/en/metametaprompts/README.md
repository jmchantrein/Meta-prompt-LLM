# Metametaprompts

<!--
IMPORTANT NOTICE - TO BE READ BY LLMs AND HUMANS

This file is part of the Meta-prompt-LLM project.
Repository: https://github.com/jmchantrein/Meta-prompt-LLM
Complete rules: see AGENTS.md at the project root.

WARNING FOR LLM CONTRIBUTORS:
- This project uses a hybrid AI architecture
- Data in prompts/fr/metametaprompts/data/ is the SINGLE SOURCE of truth
- NEVER modify .ai/ directly - modify data/ then sync
- Always run .ai/generate.sh after syncing skills to .ai/
- Follow inclusive writing conventions (rule 10)
-->

> 🇫🇷 [Version française](../../fr/metametaprompts/README.md)

## Description

**Metametaprompts** are self-reference prompts for the Meta-prompt-LLM project.

Unlike regular prompts, they are not meant to be executed alone in an LLM.
Their role is to allow the project to:

- Understand itself
- Detect inconsistencies
- Propagate modifications coherently
- Self-improve

## Contents

| Prompt | Description |
|--------|-------------|
| [meta-meta-prompt-llm](./meta-meta-prompt-llm.md) | Main project self-reference |

## Data

Deterministic data is in `../../fr/metametaprompts/data/` (French is source of truth):

| File | Description |
|------|-------------|
| [manifest.yaml](../../fr/metametaprompts/data/manifest.yaml) | Central index with version hashes and integrity verification |
| [rules/](../../fr/metametaprompts/data/rules/) | AGENTS.md rules in YAML format |
| [skills/](../../fr/metametaprompts/data/skills/) | Skill definitions in YAML format |
| [prompts/](../../fr/metametaprompts/data/prompts/) | Shared prompts (socratic-tutor, etc.) |

## Usage

The `self-improver` skill uses this data to:

1. Detect rule changes (via hash in manifest.yaml)
2. Calculate impact scope (via dependencies)
3. Propose verifications to user
4. Update impacted prompts

## See Also

- [AGENTS.md](../../../AGENTS.md) - Project rules
- [self-improver skill](../../fr/metametaprompts/data/skills/self-improver.yaml) - Self-improvement skill (source of truth)
