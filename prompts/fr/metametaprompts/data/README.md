# Data - Source de Vérité

> [English version](#english-version-below)

Ce dossier contient la **source de vérité unique** pour le système de version check.

## Structure simplifiée (KISS)

```
data/
├── manifest.yaml          # Index central unique
├── rules/
│   └── rules.yaml         # Règles extraites de AGENTS.md
├── skills/
│   └── *.yaml             # Copie des skills
└── prompts/
    └── [prompt-name]/     # Prompts versionnés
        ├── prompt.en.md
        └── prompt.fr.md
```

## manifest.yaml

Seul fichier d'index. Contient :
- URLs des fichiers sources (raw GitHub)
- Hashes SHA256 pour vérification d'intégrité
- Versions sémantiques
- Métadonnées des prompts

## Usage

Les prompts incluent un bloc `<!-- META -->` qui pointe vers leur source dans ce dossier. Au démarrage de session, un LLM peut vérifier si une mise à jour est disponible.

---

# English Version Below

# Data - Source of Truth

This folder contains the **single source of truth** for the version check system.

## Simplified structure (KISS)

```
data/
├── manifest.yaml          # Single central index
├── rules/
│   └── rules.yaml         # Rules extracted from AGENTS.md
├── skills/
│   └── *.yaml             # Skills copy
└── prompts/
    └── [prompt-name]/     # Versioned prompts
```

## manifest.yaml

Single index file containing URLs, SHA256 hashes, versions, and prompt metadata.
