# Architecture et flux de données

> [English version](../en/architecture.md)

## Vue d'ensemble

Meta-prompt-LLM utilise une architecture à **source de vérité unique** où toutes les données de configuration résident en un seul endroit et sont synchronisées/générées vers des formats spécifiques à chaque plateforme.

## Schéma d'architecture

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                         SOURCE DE VÉRITÉ                                     │
│                                                                              │
│   prompts/fr/metametaprompts/data/                                          │
│   ├── manifest.yaml          # Index central (versions, hashes, URLs)       │
│   ├── rules/                                                                 │
│   │   └── rules.yaml         # Règles AGENTS.md en YAML                     │
│   ├── skills/                                                                │
│   │   └── *.yaml             # Définitions des skills (9 skills)            │
│   ├── hooks/                                                                 │
│   │   └── hooks.yaml         # Configuration des hooks de cycle de vie      │
│   └── prompts/                                                               │
│       └── */                 # Prompts versionnés (EN + FR)                 │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
                                      │
                                      │ data-sync (manuel ou automatisé)
                                      ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                         COPIE DE TRAVAIL LOCALE                              │
│                                                                              │
│   .ai/                                                                       │
│   ├── skills/*.yaml          # Skills (synchronisés depuis data/)           │
│   ├── hooks/hooks.yaml       # Hooks (synchronisés depuis data/)            │
│   ├── generate.sh            # Générateur multi-plateforme                  │
│   ├── MEMORY.md              # Mémoire persistante du projet                │
│   └── sources.yaml           # URLs de référence                            │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
                                      │
                                      │ generate.sh --force
                                      ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                         FICHIERS GÉNÉRÉS (Spécifiques aux plateformes)       │
│                                                                              │
│   ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐            │
│   │   AGENTS.md     │  │   CLAUDE.md     │  │  .cursorrules   │            │
│   │   (Standard)    │  │ (Claude Code)   │  │    (Cursor)     │            │
│   └─────────────────┘  └─────────────────┘  └─────────────────┘            │
│                                                                              │
│   ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐            │
│   │.claude/         │  │.continuerc.json │  │.aider.conf.yml  │            │
│   │├── settings.json│  │ (Continue.dev)  │  │    (Aider)      │            │
│   │└── agents/*.md  │  └─────────────────┘  └─────────────────┘            │
│   └─────────────────┘                                                        │
│                                                                              │
│   ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐            │
│   │ollama/          │  │.opencode/       │  │.codex/          │            │
│   │└── Modelfile.*  │  │└── agents/*.md  │  │└── agents/*.md  │            │
│   │    (Ollama)     │  │   (OpenCode)    │  │   (Codex CLI)   │            │
│   └─────────────────┘  └─────────────────┘  └─────────────────┘            │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
```

## Règles de flux de données

### Règle 1 : Source de vérité unique

**Toutes les modifications DOIVENT être faites dans `data/` en premier.**

```
✅ CORRECT :
   1. Modifier data/skills/translator.yaml
   2. Exécuter data-sync pour copier vers .ai/skills/
   3. Exécuter generate.sh pour mettre à jour les fichiers plateformes

❌ FAUX :
   1. Modifier .ai/skills/translator.yaml directement
   (Les changements seront écrasés par le prochain data-sync)
```

### Règle 2 : Direction de synchronisation

```
data/ ──────────────────────► .ai/ ──────────────────────► fichiers plateformes
       data-sync (copie)              generate.sh (transformation)

JAMAIS : .ai/ → data/ (la synchronisation inverse est interdite)
```

### Règle 3 : Workflow de modification

```
┌─────────────┐    ┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│  Modifier   │    │  Mettre à   │    │  data-sync  │    │ generate.sh │
│   data/     │───►│jour manifest│───►│  vers .ai/  │───►│   --force   │
│             │    │   (hash)    │    │             │    │             │
└─────────────┘    └─────────────┘    └─────────────┘    └─────────────┘
```

## Détails des composants

### Source de vérité (`data/`)

| Fichier | Objectif |
|---------|----------|
| `manifest.yaml` | Index central avec hashes SHA256 pour vérification d'intégrité |
| `rules/rules.yaml` | Règles AGENTS.md en format YAML structuré |
| `skills/*.yaml` | Définitions des skills (rôle, directives, déclencheurs, contraintes) |
| `hooks/hooks.yaml` | Hooks de cycle de vie (garde-fous, automatisation, audit) |
| `prompts/*/` | Prompts versionnés avec traductions EN/FR |

### Copie de travail (`.ai/`)

| Fichier | Objectif |
|---------|----------|
| `skills/*.yaml` | Copie locale des skills (synchronisée depuis data/) |
| `hooks/hooks.yaml` | Copie locale des hooks (synchronisée depuis data/) |
| `generate.sh` | Générateur de configuration multi-plateforme |
| `MEMORY.md` | Mémoire persistante du projet (lu au démarrage de session) |
| `sources.yaml` | URLs de référence pour la documentation |

### Fichiers générés

| Plateforme | Fichiers générés |
|------------|------------------|
| Standard | `AGENTS.md` |
| Claude Code | `CLAUDE.md`, `.claude/settings.json`, `.claude/agents/*.md` |
| Cursor | `.cursorrules` |
| Continue.dev | `.continuerc.json` |
| Aider | `.aider.conf.yml` |
| Ollama | `ollama/Modelfile.*` |
| OpenCode | `.opencode/agents/*.md` |
| Codex CLI | `.codex/agents/*.md` |

## Système de hooks

### Événements du cycle de vie

```
┌──────────────────┐
│ UserPromptSubmit │ ◄── L'utilisateur·ice envoie un message
└────────┬─────────┘
         │
         ▼
┌──────────────────┐
│   PreToolUse     │ ◄── Avant l'exécution d'un outil (peut BLOQUER)
└────────┬─────────┘
         │
         ▼
┌──────────────────┐
│ [Outil s'exécute]│
└────────┬─────────┘
         │
         ▼
┌──────────────────┐
│   PostToolUse    │ ◄── Après la fin de l'outil
└────────┬─────────┘
         │
         ▼
┌──────────────────┐
│      Stop        │ ◄── Fin de session
└──────────────────┘
```

### Types de hooks

| Type | Objectif | Exemple |
|------|----------|---------|
| `command` | Exécuter une commande shell | Vérifier si MEMORY.md existe |
| `prompt` | Demander confirmation oui/non | Confirmer avant commande `rm` |
| `agent` | Lancer un sous-agent pour validation | Exécuter inclusivity-reviewer |

### Hooks configurés

| Événement | Hook | Action |
|-----------|------|--------|
| `UserPromptSubmit` | load-memory | Rappeler de lire MEMORY.md |
| `PreToolUse` | protect-env | Confirmer avant écriture fichiers .env |
| `PreToolUse` | confirm-delete | Confirmer avant commandes `rm` |
| `PreToolUse` | confirm-force-push | Confirmer avant `git push --force` |
| `PostToolUse` | auto-generate | Exécuter generate.sh après modif skills |
| `PostToolUse` | inclusivity-reminder | Rappeler l'écriture inclusive FR |
| `Stop` | memory-reminder | Rappeler de mettre à jour MEMORY.md |

## Référence rapide

### Ajouter un nouveau skill

```bash
# 1. Créer le skill dans data/ (source de vérité)
cp data/skills/_TEMPLATE.yaml data/skills/nouveau-skill.yaml
edit data/skills/nouveau-skill.yaml

# 2. Mettre à jour manifest.yaml
sha256sum data/skills/nouveau-skill.yaml  # Obtenir le hash
edit data/manifest.yaml                    # Ajouter l'entrée

# 3. Synchroniser vers .ai/
cp data/skills/nouveau-skill.yaml .ai/skills/

# 4. Régénérer les fichiers plateformes
.ai/generate.sh --force
```

### Modifier les hooks

```bash
# 1. Modifier dans data/ (source de vérité)
edit data/hooks/hooks.yaml

# 2. Mettre à jour le hash dans manifest.yaml
sha256sum data/hooks/hooks.yaml
edit data/manifest.yaml

# 3. Synchroniser vers .ai/
cp data/hooks/hooks.yaml .ai/hooks/

# 4. Régénérer
.ai/generate.sh --force
```

### Vérifier l'état du workflow

```bash
# Vérifier si régénération nécessaire
.ai/generate.sh --check

# Forcer la régénération
.ai/generate.sh --force --verbose

# Simulation (aperçu des changements)
.ai/generate.sh --dry-run
```

## Génération des hooks avec yq

La fonction `generate_claude_hooks()` utilise `yq` (processeur YAML) pour transformer `hooks.yaml` en configuration JSON spécifique à chaque plateforme.

### Fonctionnement

```bash
# Une seule commande yq remplace 220+ lignes de machine à états bash
yq '
  def transform_hook:
    select(.enabled == true) |
    del(.name, .description, .enabled);

  {
    "_comment": "Auto-généré par generate.sh",
    "hooks": {
      "SessionStart": [.SessionStart[]? | transform_hook],
      "PreToolUse": [.PreToolUse[]? | transform_hook],
      "PostToolUse": [.PostToolUse[]? | transform_hook],
      "Stop": [.Stop[]? | transform_hook]
    }
  }
' hooks.yaml > .claude/settings.json
```

### Prérequis

```bash
pip install yq  # ou: brew install yq
```

### Structure de sortie JSON

```json
{
  "_comment": "Auto-généré par generate.sh",
  "hooks": {
    "SessionStart": [
      {
        "matcher": "pattern-optionnel",
        "hooks": [
          {
            "type": "command",
            "command": "commande shell ici",
            "timeout": 30
          }
        ]
      }
    ],
    "PreToolUse": [...],
    "PostToolUse": [...]
  }
}
```

## Voir aussi

- [AGENTS.md](../../AGENTS.md) - Règles fondamentales pour les agents IA
- [data/README.md](../../prompts/fr/metametaprompts/data/README.md) - Documentation de la source de vérité
- [hooks-manager skill](../../.ai/skills/hooks-manager.yaml) - Base de connaissances des hooks
