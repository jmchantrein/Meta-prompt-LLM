# Quick reference

> Common commands and workflows

## Daily workflow

```bash
# Start of session
cat .ai/MEMORY.md

# If skills modified
.ai/generate.sh

# Before commit
.ai/generate.sh --check
```

## Skill management

```bash
# List skills
ls .ai/skills/*.yaml

# Add new skill
cp .ai/skills/_TEMPLATE.yaml .ai/skills/new-skill.yaml
# Edit new-skill.yaml
.ai/generate.sh
```

## Validation

```bash
# Check if generation needed
.ai/generate.sh --check

# Preview changes
.ai/generate.sh --dry-run --verbose

# Force regeneration
.ai/generate.sh --force
```

## Agent invocation

```
Agent(s): [skill-name]
```

Example:
```
Agent(s): inclusivity-reviewer, translator
```

## Todo format

```
[ ] To do
[x] Done
[~] In progress
[!] Blocked
```

## Commit checklist

- [ ] generate.sh executed if skills modified
- [ ] prompt-validator passed if prompts modified
- [ ] inclusivity-reviewer passed if FR content modified
- [ ] translator sync check if docs modified
- [ ] memory-keeper invoked if important decisions
