> [English version](./README.md)

> [!WARNING]
> Ce projet est en cours de développement. La structure et les APIs peuvent changer.

> [!NOTE]
> **Développement LLM (IA) assisté par être(s) humain(s)** : Ce projet a été développé dès le départ avec l'assistance de LLM. Le codebase inclut une architecture IA hybride avec des agents spécialisés. Cette architecture a été définie avec le prompt [hybrid-ai-bootstrap](./prompts/fr/metaprompts/hybrid-ai-bootstrap).

# Meta-prompt-LLM

Un framework pour créer, modifier et maintenir des collections de prompts avec support d'architecture IA hybride.

## Fonctionnalités

- **Définitions de skills centralisées** au format YAML
- **Génération multi-plateforme** pour Claude Code, Cursor, Ollama, OpenCode, Aider, Continue.dev, Codex, et plus
- **Mémoire persistante** entre les sessions IA
- **Orchestration de workflows** pour la validation automatique
- **Documentation bilingue** (anglais/français) avec références croisées
- **Écriture inclusive** obligatoire pour le contenu français
- **Système de vérification de version** : Les prompts peuvent vérifier les mises à jour via URLs GitHub raw
- **Source de vérité data/** : Toutes les règles, skills et prompts gérés dans `data/`

## Démarrage rapide

```bash
# Cloner le dépôt
git clone https://github.com/jmchantrein/Meta-prompt-LLM.git
cd Meta-prompt-LLM

# Générer les configurations des plateformes
.ai/generate.sh

# Commencer à utiliser avec votre outil IA
```

## Structure du projet

```
Meta-prompt-LLM/
├── .ai/                    # Configuration IA
│   ├── skills/             # Définitions des skills (YAML)
│   ├── commands/           # Commandes réutilisables
│   ├── plans/              # Plans d'exécution
│   ├── MEMORY.md           # Mémoire persistante
│   ├── sources.yaml        # URLs de référence
│   └── generate.sh         # Script de génération
├── prompts/                # Collection de prompts
│   ├── _TEMPLATE.md        # Template de prompt
│   ├── _metadata/          # Catégories et langues
│   └── [catégories]/       # Prompts organisés
├── docs/                   # Documentation
│   ├── en/                 # Anglais (principal)
│   └── fr/                 # Français (miroir)
├── AGENTS.md               # Règles fondamentales
├── CLAUDE.md               # Config Claude Code
└── README.md               # Ce fichier
```

## Fonctionnement

### Source unique de vérité

Toutes les configurations d'agents IA sont définies une seule fois dans `.ai/skills/*.yaml`. Le script `generate.sh` crée ensuite les fichiers spécifiques à chaque plateforme :

| Source | Fichiers générés |
|--------|------------------|
| `.ai/skills/*.yaml` | `AGENTS.md`, `CLAUDE.md`, `.cursorrules`, etc. |

### Skills disponibles

| Skill | Objectif |
|-------|----------|
| `data-sync` | Synchronise data/ vers les fichiers projet et valide l'intégrité |
| `inclusivity-reviewer` | Validation de l'écriture inclusive |
| `link-checker` | Validation des liens internes dans les markdown |
| `memory-keeper` | Gestion de la mémoire persistante |
| `prompt-validator` | Validation du schéma des prompts |
| `self-improver` | Agent d'auto-amélioration du projet |
| `translator` | Traduction et synchronisation EN/FR |
| `workflow-orchestrator` | Orchestration multi-agents |

### Workflow

1. **Début de session** : Lire `.ai/MEMORY.md`
2. **Modifier les skills** : Éditer les fichiers YAML dans `.ai/skills/`
3. **Générer** : Exécuter `.ai/generate.sh`
4. **Valider** : Vérifications pré-commit via `workflow-orchestrator`
5. **Mettre à jour la mémoire** : Enregistrer les décisions via `memory-keeper`

## Utilisation

### Générer les configurations

```bash
# Générer si nécessaire
.ai/generate.sh

# Forcer la régénération
.ai/generate.sh --force

# Vérifier si régénération nécessaire (CI/CD)
.ai/generate.sh --check

# Prévisualiser les changements
.ai/generate.sh --dry-run --verbose
```

### Ajouter un nouveau skill

1. Copier le template :
   ```bash
   cp .ai/skills/_TEMPLATE.yaml .ai/skills/mon-skill.yaml
   ```

2. Éditer le fichier YAML avec votre définition de skill

3. Générer les configurations :
   ```bash
   .ai/generate.sh
   ```

### Ajouter un nouveau prompt

1. Copier le template :
   ```bash
   cp prompts/_TEMPLATE.md prompts/[catégorie]/mon-prompt.md
   ```

2. Éditer avec votre contenu de prompt

3. Valider :
   ```bash
   # Utiliser le skill prompt-validator
   ```

## Système de vérification de version

Les prompts de cette collection incluent un bloc `<!-- META -->` qui permet :

- **Auto-vérification** : Les prompts vérifient si des mises à jour sont disponibles au démarrage de session
- **Copier-coller friendly** : Mini-prompts pour la vérification de mise à jour dans les prompts déployés
- **Contrôle utilisateur·ice** : Les mises à jour sont proposées, jamais forcées

### Comment ça marche

Chaque prompt contient des métadonnées pointant vers sa source :

```markdown
<!-- META
prompt_id: "mon-prompt"
version: "1.0.0"
source_url: "https://raw.githubusercontent.com/jmchantrein/Meta-prompt-LLM/main/..."
-->
```

Au démarrage de session, le LLM peut récupérer la source et comparer les versions.

Pour plus de détails, voir [Spécification du système de vérification de version](./docs/fr/specs/version-check-system.md).

## Documentation

- [Documentation anglaise](./docs/en/)
- [Documentation française](./docs/fr/)

## Contribuer

1. Lire `AGENTS.md` pour les directives de contribution
2. Suivre les règles d'écriture inclusive pour le contenu français
3. Exécuter `generate.sh --check` avant de commiter
4. S'assurer que la documentation est bilingue

## Licence

Licence GPL-3.0 - voir [LICENSE](./LICENSE)
