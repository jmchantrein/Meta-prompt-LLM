> [English version](../en/getting-started.md)

# Demarrage

Ce guide vous aidera a configurer et utiliser Meta-prompt-LLM.

## Prerequis

- Shell Bash (Linux, macOS, WSL)
- Git
- Au moins un outil IA (Claude Code, Cursor, Ollama, etc.)

## Installation

### Cloner le depot

```bash
git clone https://github.com/your-org/Meta-prompt-LLM.git
cd Meta-prompt-LLM
```

### Generer les configurations

```bash
chmod +x .ai/generate.sh
.ai/generate.sh
```

Cela cree les fichiers de configuration specifiques a chaque plateforme pour tous les outils IA supportes.

## Premiere session

### 1. Charger le contexte

Au debut de chaque session IA, l'agent doit lire le fichier memoire :

```bash
cat .ai/MEMORY.md
```

### 2. Verifier les skills disponibles

Lister les skills disponibles dans le projet :

```bash
ls .ai/skills/*.yaml
```

### 3. Utiliser un skill

Invoquer un skill en le mentionnant :

```
Agent(s): prompt-validator

Veuillez valider le prompt dans prompts/meta/hybrid-ai-bootstrap.md
```

## Creer un prompt

### 1. Copier le template

```bash
cp prompts/_TEMPLATE.md prompts/[categorie]/mon-prompt.md
```

### 2. Editer le frontmatter

```yaml
---
name: "mon-prompt"
version: "1.0.0"
category: "development"
description: "Breve description"
tags: ["tag1", "tag2"]
---
```

### 3. Ecrire le contenu

Suivre la structure du template :
- Contexte
- Instructions
- Contraintes
- Format de sortie
- Exemples

### 4. Valider

Utiliser le skill prompt-validator pour verifier votre prompt.

## Creer un skill

### 1. Copier le template

```bash
cp .ai/skills/_TEMPLATE.yaml .ai/skills/mon-skill.yaml
```

### 2. Definir le skill

Editer le fichier YAML avec :
- Metadonnees (name, version, description)
- Declencheurs (patterns, keywords, commands)
- Instructions (role, guidelines, process)
- Contraintes

### 3. Generer

```bash
.ai/generate.sh
```

## Prochaines etapes

- Lire [AGENTS.md](../../AGENTS.md) pour les regles completes
- Explorer les skills existants dans `.ai/skills/`
- Parcourir la collection de prompts dans `prompts/`
- Consulter le [guide d'architecture](./architecture.md)
