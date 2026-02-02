# Prompt template

> Template for creating new prompts in the collection.

## Folder structure

Each prompt must be in its own folder with the same name as the prompt:

```
prompts/
├── [lang]/                          # en, fr, etc.
│   └── [category]/                  # metaprompts, development, etc.
│       └── [prompt-name]/           # folder = prompt name (unique)
│           ├── [prompt-name].md     # main prompt file (required)
│           ├── README.md            # context/documentation (optional)
│           └── [related].md         # related prompts (optional)
```

**Example:**
```
prompts/
├── en/
│   └── metaprompts/
│       └── hybrid-ai-bootstrap/
│           ├── hybrid-ai-bootstrap.md
│           └── README.md
└── fr/
    └── metaprompts/
        └── hybrid-ai-bootstrap/
            ├── hybrid-ai-bootstrap.md
            └── README.md
```

## Creating a new prompt

1. Choose a unique `prompt-name` (kebab-case)
2. Create folder: `prompts/en/[category]/[prompt-name]/`
3. Create main file: `[prompt-name].md` using template below
4. Create FR translation in `prompts/fr/[category]/[prompt-name]/`
5. Add cross-reference links between EN and FR versions

## Prompt file template

```markdown
---
name: "prompt-name"
version: "1.0.0"
category: "category-name"
description: "Brief description of what this prompt does (max 200 chars)"

tags: ["tag1", "tag2", "tag3"]
author: "author-name"
created: "YYYY-MM-DD"
updated: "YYYY-MM-DD"

# Optional fields
language: "en"
difficulty: "beginner|intermediate|advanced"

model_hints:
  recommended: ["claude-sonnet", "gpt-4"]
  min_context: 8192
  temperature: 0.3
---

> [Version française](../../../fr/[category]/[prompt-name]/[prompt-name].md)

# Prompt name

> Brief description or tagline

## Context

Describe the context in which this prompt should be used:
- What problem does it solve?
- When should it be used?
- Who is the target audience?

## Instructions

Provide clear, actionable instructions for the AI:

1. **First step**: Description of what to do first
2. **Second step**: Description of what to do next
3. **Third step**: Continue as needed

### Sub-section (if needed)

Additional instructions or variations.

## Constraints

List any constraints or limitations:

- Constraint 1: Explanation
- Constraint 2: Explanation
- Must not: Things to avoid

## Output format

Describe the expected output format:

| Field | Description |
|-------|-------------|
| field1 | What this field contains |
| field2 | What this field contains |

## Examples

### Example 1: [Brief description]

**Input:**
[Example input]

**Output:**
[Expected output]

## Related prompts

- [related-prompt](../category/related-prompt/related-prompt.md): Brief description

---

<!--
VERSION HISTORY:
- v1.0.0 (YYYY-MM-DD): Initial version
-->
```

## Optional README.md

Each prompt folder can include a README.md for additional context:

```markdown
# [Prompt name]

Additional documentation, context, or usage examples for this prompt.

## Use cases

- Use case 1
- Use case 2

## Related resources

- Link to relevant documentation
- External references
```

**Note:** README.md files must also be synchronized EN/FR via translator.

## Validation

Before committing a new prompt:
- [ ] Unique name (not existing in collection)
- [ ] Folder structure correct
- [ ] Main file named same as folder
- [ ] EN and FR versions created
- [ ] Cross-reference links added
- [ ] prompt-validator passed
- [ ] inclusivity-reviewer passed (FR content)
