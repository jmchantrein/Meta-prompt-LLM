# Metametaprompts

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
| [rules-index.yaml](../../fr/metametaprompts/data/rules-index.yaml) | AGENTS.md rules index |
| [skills-index.yaml](../../fr/metametaprompts/data/skills-index.yaml) | Skills index |
| [prompts-index.yaml](../../fr/metametaprompts/data/prompts-index.yaml) | Prompts index |
| [dependencies.yaml](../../fr/metametaprompts/data/dependencies.yaml) | Dependencies mapping |
| [pending-reviews.yaml](../../fr/metametaprompts/data/pending-reviews.yaml) | Pending reviews |

## Usage

The `self-improver` skill uses this data to:

1. Detect rule changes (via hash)
2. Calculate impact scope (via dependencies)
3. Propose verifications to user
4. Update impacted prompts

## See Also

- [AGENTS.md](../../../AGENTS.md) - Project rules
- [self-improver skill](../../../.ai/skills/self-improver.yaml) - Self-improvement skill
