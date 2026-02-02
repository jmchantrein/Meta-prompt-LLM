# Data - Source de Vérité Unique

> [English version](#english-version-below)

Ce dossier est la **SOURCE DE VÉRITÉ UNIQUE** pour tout le projet.

## Flux de données

```
data/ (SOURCE) ──────────────────────► .ai/ (CIBLE)
                    data-sync ou
                    copie manuelle
```

**RÈGLE IMPORTANTE** : Toute modification doit être faite dans `data/`, puis synchronisée vers `.ai/`.

## Structure

```
data/
├── manifest.yaml          # Index central (versions, hashes, URLs)
├── rules/
│   ├── rules.yaml         # Règles extraites de AGENTS.md
│   └── CHANGELOG.md
├── skills/
│   ├── *.yaml             # Définitions des skills
│   └── CHANGELOG.md
├── hooks/
│   ├── hooks.yaml         # Configuration des hooks
│   └── CHANGELOG.md
└── prompts/
    └── [prompt-name]/     # Prompts versionnés (EN + FR)
```

## Correspondance data/ → .ai/

| Source (data/) | Cible (.ai/) |
|----------------|--------------|
| `skills/*.yaml` | `.ai/skills/*.yaml` |
| `hooks/hooks.yaml` | `.ai/hooks/hooks.yaml` |
| `rules/rules.yaml` | Utilisé par self-improver |

## manifest.yaml

Index central unique contenant :
- URLs des fichiers sources (raw GitHub)
- Hashes SHA256 pour vérification d'intégrité
- Versions sémantiques
- Métadonnées des prompts

## Procédure de modification

1. Modifier le fichier dans `data/`
2. Mettre à jour le CHANGELOG correspondant
3. Recalculer le hash si nécessaire : `sha256sum fichier.yaml`
4. Mettre à jour `manifest.yaml` (hash, version, date)
5. Synchroniser vers `.ai/` via `data-sync` ou copie manuelle

---

# English Version Below

# Data - Single Source of Truth

This folder is the **SINGLE SOURCE OF TRUTH** for the entire project.

## Data Flow

```
data/ (SOURCE) ──────────────────────► .ai/ (TARGET)
                    data-sync or
                    manual copy
```

**IMPORTANT RULE**: All modifications must be made in `data/`, then synchronized to `.ai/`.

## Structure

```
data/
├── manifest.yaml          # Central index (versions, hashes, URLs)
├── rules/
│   ├── rules.yaml         # Rules extracted from AGENTS.md
│   └── CHANGELOG.md
├── skills/
│   ├── *.yaml             # Skill definitions
│   └── CHANGELOG.md
├── hooks/
│   ├── hooks.yaml         # Hooks configuration
│   └── CHANGELOG.md
└── prompts/
    └── [prompt-name]/     # Versioned prompts (EN + FR)
```

## Mapping data/ → .ai/

| Source (data/) | Target (.ai/) |
|----------------|---------------|
| `skills/*.yaml` | `.ai/skills/*.yaml` |
| `hooks/hooks.yaml` | `.ai/hooks/hooks.yaml` |
| `rules/rules.yaml` | Used by self-improver |

## Modification procedure

1. Modify the file in `data/`
2. Update the corresponding CHANGELOG
3. Recalculate hash if needed: `sha256sum file.yaml`
4. Update `manifest.yaml` (hash, version, date)
5. Sync to `.ai/` via `data-sync` or manual copy
