> [English version](./README.md)

> [!WARNING]
> Ce projet est en cours de developpement. La structure et les APIs peuvent changer.

> [!NOTE]
> Ce projet a ete developpe des le depart avec des LLM.

# Meta-prompt-LLM

Un framework pour creer, modifier et maintenir des collections de prompts avec support d'architecture IA hybride.

## Fonctionnalites

- **Definitions de skills centralisees** au format YAML
- **Generation multi-plateforme** pour Claude Code, Cursor, Ollama, OpenCode, Aider, Continue.dev, Codex, et plus
- **Memoire persistante** entre les sessions IA
- **Orchestration de workflows** pour la validation automatique
- **Documentation bilingue** (anglais/francais) avec references croisees
- **Ecriture inclusive** obligatoire pour le contenu francais

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
| `inclusivity-reviewer` | Validation de l'ecriture inclusive |
| `memory-keeper` | Gestion de la memoire persistante |
| `workflow-orchestrator` | Orchestration multi-agents |
| `translator` | Traduction et synchronisation EN/FR |
| `prompt-validator` | Validation du schema des prompts |

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

## Documentation

- [Documentation anglaise](./docs/en/)
- [Documentation francaise](./docs/fr/)

## Contribuer

1. Lire `AGENTS.md` pour les directives de contribution
2. Suivre les regles d'ecriture inclusive pour le contenu francais
3. Executer `generate.sh --check` avant de commiter
4. S'assurer que la documentation est bilingue

## Licence

Licence GPL-3.0 - voir [LICENSE](./LICENSE)
