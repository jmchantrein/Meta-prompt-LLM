# Data - Source de Vérité

> [English version](#english-version-below)

Ce dossier contient la source de vérité pour le système de version check et la maintenance interne du projet.

## Structure

```
data/
├── manifest.yaml          # Index central pour distribution externe
├── rules/                 # Règles extraites de AGENTS.md
│   ├── rules.yaml
│   └── CHANGELOG.md
├── skills/                # Copie des skills pour version check
│   ├── *.yaml
│   └── CHANGELOG.md
├── prompts/               # Prompts versionnés
│   ├── CHANGELOG.md
│   └── [prompt-name]/
│       ├── prompt.en.md
│       └── prompt.fr.md
└── Fichiers d'index (maintenance interne)
    ├── rules-index.yaml
    ├── skills-index.yaml
    ├── dependencies.yaml
    └── pending-reviews.yaml
```

## Deux Systèmes Complémentaires

### 1. Système de Version Check (`manifest.yaml`)

**Objectif** : Permettre aux prompts distribués de se mettre à jour automatiquement.

**Utilisé par** : Les LLM qui exécutent des prompts de cette collection ailleurs.

**Contenu** :
- URLs des fichiers sources (raw GitHub)
- Hashes SHA256 pour vérification d'intégrité
- Versions sémantiques
- Métadonnées des prompts (règles applicables, skills requis)

### 2. Système d'Index (`*-index.yaml`)

**Objectif** : Maintenance interne du projet par le skill `self-improver`.

**Utilisé par** : Le self-improver pour détecter les changements et calculer les impacts.

**Contenu** :
- `rules-index.yaml` : Index des règles AGENTS.md avec numéros de ligne
- `skills-index.yaml` : Index des skills avec hashes et impacts
- `dependencies.yaml` : Matrice de dépendances entre règles/skills et fichiers
- `pending-reviews.yaml` : Reviews en attente

## Pourquoi deux systèmes ?

| Aspect | manifest.yaml | *-index.yaml |
|--------|---------------|--------------|
| **Public cible** | Utilisateur·ice·s externes | Maintenance interne |
| **Objectif** | Distribution / mise à jour | Détection changements |
| **Données** | URLs, versions, hashes | Numéros de ligne, mots-clés, impacts |
| **Utilisé par** | LLM exécutant un prompt | self-improver skill |

Les deux systèmes coexistent car ils servent des objectifs différents et complémentaires.

## Maintenance

Lors d'une modification :

1. **Modification AGENTS.md** → Mettre à jour `rules-index.yaml` et `rules/rules.yaml`
2. **Modification skill** → Mettre à jour `skills-index.yaml` et `skills/*.yaml`
3. **Nouveau prompt** → Ajouter dans `prompts/`, `manifest.yaml`, et CHANGELOGs

Le skill `data-sync` peut être utilisé pour vérifier la synchronisation.

---

# English Version Below

# Data - Source of Truth

This folder contains the source of truth for the version check system and internal project maintenance.

## Structure

```
data/
├── manifest.yaml          # Central index for external distribution
├── rules/                 # Rules extracted from AGENTS.md
├── skills/                # Skills copy for version check
├── prompts/               # Versioned prompts
└── Index files (internal maintenance)
    ├── rules-index.yaml
    ├── skills-index.yaml
    ├── dependencies.yaml
    └── pending-reviews.yaml
```

## Two Complementary Systems

### 1. Version Check System (`manifest.yaml`)

**Purpose**: Allow distributed prompts to self-update.

**Used by**: LLMs executing prompts from this collection elsewhere.

### 2. Index System (`*-index.yaml`)

**Purpose**: Internal project maintenance by `self-improver` skill.

**Used by**: self-improver to detect changes and calculate impact scope.

## Why Two Systems?

| Aspect | manifest.yaml | *-index.yaml |
|--------|---------------|--------------|
| **Target** | External users | Internal maintenance |
| **Purpose** | Distribution / updates | Change detection |
| **Data** | URLs, versions, hashes | Line numbers, keywords, impacts |
| **Used by** | LLM executing prompt | self-improver skill |

Both systems coexist because they serve different, complementary objectives.
