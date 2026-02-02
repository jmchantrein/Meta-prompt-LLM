> [Version française](../fr/getting-started.md)

# Getting started

This guide will help you set up and use Meta-prompt-LLM.

## Prerequisites

- Bash shell (Linux, macOS, WSL)
- Git
- At least one AI tool (Claude Code, Cursor, Ollama, etc.)

## Installation

### Clone the repository

```bash
git clone https://github.com/jmchantrein/Meta-prompt-LLM.git
cd Meta-prompt-LLM
```

### Generate configurations

```bash
chmod +x .ai/generate.sh
.ai/generate.sh
```

This creates platform-specific configuration files for all supported AI tools.

## First session

### 1. Load context

At the start of each AI session, the agent should read the memory file:

```bash
cat .ai/MEMORY.md
```

### 2. Check available skills

List the skills available in the project:

```bash
# Source of truth
ls prompts/fr/metametaprompts/data/skills/*.yaml

# Or local working copy
ls .ai/skills/*.yaml
```

### 3. Use a skill

Invoke a skill by mentioning it:

```
Agent(s): prompt-validator

Please validate the prompt in prompts/meta/hybrid-ai-bootstrap.md
```

## Creating a prompt

### 1. Copy the template

```bash
cp prompts/_TEMPLATE.md prompts/[category]/my-prompt.md
```

### 2. Edit the frontmatter

```yaml
---
name: "my-prompt"
version: "1.0.0"
category: "development"
description: "Brief description"
tags: ["tag1", "tag2"]
---
```

### 3. Write the content

Follow the template structure:
- Context
- Instructions
- Constraints
- Output format
- Examples

### 4. Validate

Use the prompt-validator skill to check your prompt.

## Creating a skill

### 1. Copy the template (in source of truth)

```bash
cp prompts/fr/metametaprompts/data/skills/_TEMPLATE.yaml \
   prompts/fr/metametaprompts/data/skills/my-skill.yaml
```

### 2. Define the skill

Edit the YAML file with:
- Metadata (name, version, description)
- Triggers (patterns, keywords, commands)
- Instructions (role, guidelines, process)
- Constraints

### 3. Update manifest.yaml

Add hash and version entry in `prompts/fr/metametaprompts/data/manifest.yaml`.

### 4. Sync and generate

```bash
cp prompts/fr/metametaprompts/data/skills/my-skill.yaml .ai/skills/
.ai/generate.sh --force
```

## Next steps

- Read [AGENTS.md](../../AGENTS.md) for the complete rules
- Explore existing skills in `prompts/fr/metametaprompts/data/skills/`
- Browse the prompt collection in `prompts/`
- Read [Architecture documentation](./architecture.md) for data flow
