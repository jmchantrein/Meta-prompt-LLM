# hybrid-ai-bootstrap

> [English version](../../../en/metaprompts/hybrid-ai-bootstrap/README.md)

Prompt d'initialisation pour creer de nouveaux projets avec une architecture IA hybride supportant plusieurs plateformes (Claude Code, Cursor, Ollama, etc.).

## Cas d'utilisation

- Demarrer un nouveau projet logiciel avec assistance IA
- Creer un framework de collection de prompts
- Configurer des agents IA multi-plateformes
- Etablir une structure de documentation bilingue (EN/FR)

## Quand l'utiliser

Utilisez ce prompt quand :

- Vous demarrez un **nouveau projet** a partir de zero
- Vous voulez centraliser les definitions d'agents en YAML
- Vous avez besoin d'un support multi-plateforme (cloud + IA locale)
- Vous voulez une memoire persistante entre les sessions
- Vous avez besoin d'une orchestration automatique des workflows

Pour les projets existants, utilisez plutot [hybrid-ai-takeover](../hybrid-ai-takeover/hybrid-ai-takeover.md).

## Prerequis

- Un·e assistant·e IA capable de creer des fichiers (Claude Code, Cursor, etc.)
- Environnement bash pour le script generate.sh
- Comprehension basique de la syntaxe YAML

## Ce qui est cree

```
.ai/
├── skills/*.yaml          # Definitions d'agents centralisees
├── MEMORY.md              # Memoire persistante du projet
├── generate.sh            # Generateur multi-plateforme
└── sources.yaml           # URLs de reference

AGENTS.md                  # Regles fondamentales
CLAUDE.md                  # Pointeur vers AGENTS.md
docs/en/ + docs/fr/        # Documentation bilingue
```

## Skills obligatoires

Le prompt cree ces skills fondamentaux :

| Skill | Objectif |
|-------|----------|
| inclusivity-reviewer | Ecriture inclusive et terminologie moderne |
| memory-keeper | Gestion de la memoire persistante |
| workflow-orchestrator | Orchestration automatique des agents |
| translator | Traduction EN/FR et synchronisation |

## Ressources connexes

- [Standard AGENTS.md](https://agents.md/)
- [Protocole MCP](https://modelcontextprotocol.io/)
- [Methode BMAD](https://github.com/bmad-code-org/BMAD-METHOD)
- [Kiro spec-driven](https://kiro.dev/)
