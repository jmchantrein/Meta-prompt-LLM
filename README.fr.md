> [English version](./README.md)

> [!WARNING]
> Ce projet est en cours de developpement. La structure et les APIs peuvent changer.

> [!NOTE]
> **Developpement LLM (IA) assiste par etre(s) humain(s)** : Ce projet a ete developpe des le depart avec l'assistance de LLM. Le codebase inclut une architecture IA hybride avec des agents specialises. Cette architecture a ete definie avec le prompt [hybrid-ai-bootstrap](./prompts/fr/metaprompts/hybrid-ai-bootstrap).

# Meta-prompt-LLM

Un framework pour creer, modifier et maintenir des collections de prompts avec support d'architecture IA hybride.

## Fonctionnalités

- **Définitions de skills centralisées** au format YAML
- **Génération multi-plateforme** pour Claude Code, Cursor, Ollama, OpenCode, Aider, Continue.dev, Codex, et plus
- **Mémoire persistante** entre les sessions IA
- **Orchestration de workflows** pour la validation automatique
- **Documentation bilingue** (anglais/français) avec références croisées
- **Écriture inclusive** obligatoire pour le contenu français
- **Système de vérification de version** : Les prompts peuvent vérifier les mises à jour via URLs GitHub raw
- **Source de vérité data/** : Toutes les règles, skills et prompts gérés dans `data/`

## Demarrage rapide

```bash
# Cloner le depot
git clone https://github.com/your-org/Meta-prompt-LLM.git
cd Meta-prompt-LLM

# Generer les configurations des plateformes
.ai/generate.sh

# Commencer a utiliser avec votre outil IA
```

## Structure du projet

```
Meta-prompt-LLM/
├── .ai/                    # Configuration IA
│   ├── skills/             # Definitions des skills (YAML)
│   ├── commands/           # Commandes reutilisables
│   ├── plans/              # Plans d'execution
│   ├── MEMORY.md           # Memoire persistante
│   ├── sources.yaml        # URLs de reference
│   └── generate.sh         # Script de generation
├── prompts/                # Collection de prompts
│   ├── _TEMPLATE.md        # Template de prompt
│   ├── _metadata/          # Categories et langues
│   └── [categories]/       # Prompts organises
├── docs/                   # Documentation
│   ├── en/                 # Anglais (principal)
│   └── fr/                 # Francais (miroir)
├── AGENTS.md               # Regles fondamentales
├── CLAUDE.md               # Config Claude Code
└── README.md               # Ce fichier
```

## Fonctionnement

### Source unique de verite

Toutes les configurations d'agents IA sont definies une seule fois dans `.ai/skills/*.yaml`. Le script `generate.sh` cree ensuite les fichiers specifiques a chaque plateforme :

| Source | Fichiers generes |
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

1. **Debut de session** : Lire `.ai/MEMORY.md`
2. **Modifier les skills** : Editer les fichiers YAML dans `.ai/skills/`
3. **Generer** : Executer `.ai/generate.sh`
4. **Valider** : Verifications pre-commit via `workflow-orchestrator`
5. **Mettre a jour la memoire** : Enregistrer les decisions via `memory-keeper`

## Utilisation

### Generer les configurations

```bash
# Generer si necessaire
.ai/generate.sh

# Forcer la regeneration
.ai/generate.sh --force

# Verifier si regeneration necessaire (CI/CD)
.ai/generate.sh --check

# Previsualiser les changements
.ai/generate.sh --dry-run --verbose
```

### Ajouter un nouveau skill

1. Copier le template :
   ```bash
   cp .ai/skills/_TEMPLATE.yaml .ai/skills/mon-skill.yaml
   ```

2. Editer le fichier YAML avec votre definition de skill

3. Generer les configurations :
   ```bash
   .ai/generate.sh
   ```

### Ajouter un nouveau prompt

1. Copier le template :
   ```bash
   cp prompts/_TEMPLATE.md prompts/[categorie]/mon-prompt.md
   ```

2. Editer avec votre contenu de prompt

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
2. Suivre les regles d'ecriture inclusive pour le contenu francais
3. Executer `generate.sh --check` avant de commiter
4. S'assurer que la documentation est bilingue

## Licence

Licence GPL-3.0 - voir [LICENSE](./LICENSE)
