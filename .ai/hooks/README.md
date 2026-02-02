# Hooks - Source of Truth

> [Version française](#version-française)

This directory contains the **single source of truth** for LLM lifecycle hooks.

## Structure

```
hooks/
├── hooks.yaml      # All hooks defined here
└── README.md       # This file
```

## Usage

Hooks are defined in `hooks.yaml` and converted to platform-specific formats by `generate.sh`:

| Source | Generated |
|--------|-----------|
| `hooks.yaml` | `.claude/settings.json` (Claude Code) |
| `hooks.yaml` | `.cursor/hooks/` (Cursor, if supported) |

## Hook Categories

| Category | Purpose |
|----------|---------|
| `session` | Initialize context at session start |
| `guardrails` | Protect sensitive files and confirm destructive ops |
| `automation` | Auto-run tasks after changes |
| `audit` | Log operations for review |
| `validation` | Agent-based quality checks |
| `session_end` | Cleanup and reminders at session end |

## Enabling/Disabling Hooks

Each hook has an `enabled` field. Set to `false` to disable without removing.

```yaml
- name: "my-hook"
  enabled: false  # Disabled
```

## Adding New Hooks

1. Choose the appropriate category and lifecycle event
2. Add the hook definition in `hooks.yaml`
3. Run `.ai/generate.sh` to update platform configs
4. Test the hook manually

---

# Version française

Ce répertoire contient la **source unique de vérité** pour les hooks de cycle de vie LLM.

## Structure

```
hooks/
├── hooks.yaml      # Tous les hooks définis ici
└── README.md       # Ce fichier
```

## Utilisation

Les hooks sont définis dans `hooks.yaml` et convertis en formats spécifiques par `generate.sh`.

## Catégories de hooks

| Catégorie | Objectif |
|-----------|----------|
| `session` | Initialiser le contexte au démarrage |
| `guardrails` | Protéger les fichiers sensibles |
| `automation` | Exécuter des tâches automatiquement |
| `audit` | Journaliser les opérations |
| `validation` | Vérifications par agents |
| `session_end` | Nettoyage et rappels en fin de session |

## Activer/Désactiver

Chaque hook a un champ `enabled`. Mettre à `false` pour désactiver.
