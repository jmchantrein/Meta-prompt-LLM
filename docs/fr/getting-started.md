> [English version](../en/getting-started.md)

# Démarrage

Ce guide vous aidera à configurer et utiliser Meta-prompt-LLM.

## Prérequis

- Shell Bash (Linux, macOS, WSL)
- Git
- Au moins un outil IA (Claude Code, Cursor, Ollama, etc.)

## Installation

### Cloner le dépôt

```bash
git clone https://github.com/jmchantrein/Meta-prompt-LLM.git
cd Meta-prompt-LLM
```

### Générer les configurations

```bash
chmod +x .ai/generate.sh
.ai/generate.sh
```

Cela crée les fichiers de configuration spécifiques à chaque plateforme pour tous les outils IA supportés.

## Première session

### 1. Charger le contexte

Au début de chaque session IA, l'agent doit lire le fichier mémoire :

```bash
cat .ai/MEMORY.md
```

### 2. Vérifier les skills disponibles

Lister les skills disponibles dans le projet :

```bash
# Source de vérité
ls prompts/fr/metametaprompts/data/skills/*.yaml

# Ou copie de travail locale
ls .ai/skills/*.yaml
```

### 3. Utiliser un skill

Invoquer un skill en le mentionnant :

```
Agent(s): prompt-validator

Veuillez valider le prompt dans prompts/meta/hybrid-ai-bootstrap.md
```

## Créer un prompt

### 1. Copier le template

```bash
cp prompts/_TEMPLATE.md prompts/[catégorie]/mon-prompt.md
```

### 2. Éditer le frontmatter

```yaml
---
name: "mon-prompt"
version: "1.0.0"
category: "development"
description: "Brève description"
tags: ["tag1", "tag2"]
---
```

### 3. Écrire le contenu

Suivre la structure du template :
- Contexte
- Instructions
- Contraintes
- Format de sortie
- Exemples

### 4. Valider

Utiliser le skill prompt-validator pour vérifier votre prompt.

## Créer un skill

### 1. Copier le template (dans la source de vérité)

```bash
cp prompts/fr/metametaprompts/data/skills/_TEMPLATE.yaml \
   prompts/fr/metametaprompts/data/skills/mon-skill.yaml
```

### 2. Définir le skill

Éditer le fichier YAML avec :
- Métadonnées (name, version, description)
- Déclencheurs (patterns, keywords, commands)
- Instructions (role, guidelines, process)
- Contraintes

### 3. Mettre à jour manifest.yaml

Ajouter l'entrée hash et version dans `prompts/fr/metametaprompts/data/manifest.yaml`.

### 4. Synchroniser et générer

```bash
cp prompts/fr/metametaprompts/data/skills/mon-skill.yaml .ai/skills/
.ai/generate.sh --force
```

## Prochaines étapes

- Lire [AGENTS.md](../../AGENTS.md) pour les règles complètes
- Explorer les skills existants dans `prompts/fr/metametaprompts/data/skills/`
- Parcourir la collection de prompts dans `prompts/`
- Lire [Documentation de l'architecture](./architecture.md) pour le flux de données
