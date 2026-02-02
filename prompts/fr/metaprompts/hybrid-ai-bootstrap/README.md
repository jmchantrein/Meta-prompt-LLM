# hybrid-ai-bootstrap

> [English version](../../../en/metaprompts/hybrid-ai-bootstrap/README.md)

Prompt d'initialisation pour créer de nouveaux projets avec une architecture IA hybride supportant plusieurs plateformes (Claude Code, Cursor, Ollama, etc.).

## Cas d'utilisation

- Démarrer un nouveau projet logiciel avec assistance IA
- Créer un framework de collection de prompts
- Configurer des agents IA multi-plateformes
- Établir une structure de documentation bilingue (EN/FR)

## Quand l'utiliser

Utilisez ce prompt quand :

- Vous démarrez un **nouveau projet** à partir de zéro
- Vous voulez centraliser les définitions d'agents en YAML
- Vous avez besoin d'un support multi-plateforme (cloud + IA locale)
- Vous voulez une mémoire persistante entre les sessions
- Vous avez besoin d'une orchestration automatique des workflows

Pour les projets existants, utilisez plutôt [hybrid-ai-takeover](../hybrid-ai-takeover/hybrid-ai-takeover.md).

## Prérequis

- Un·e assistant·e IA capable de créer des fichiers (Claude Code, Cursor, etc.)
- Environnement bash pour le script generate.sh
- Compréhension basique de la syntaxe YAML

## Ce qui est créé

```
.ai/
├── skills/*.yaml          # Définitions d'agents centralisées
├── MEMORY.md              # Mémoire persistante du projet
├── generate.sh            # Générateur multi-plateforme
└── sources.yaml           # URLs de référence

AGENTS.md                  # Règles fondamentales
CLAUDE.md                  # Pointeur vers AGENTS.md
docs/en/ + docs/fr/        # Documentation bilingue
```

## Skills obligatoires

Le prompt crée ces skills fondamentaux :

| Skill | Objectif |
|-------|----------|
| inclusivity-reviewer | Écriture inclusive et terminologie moderne |
| memory-keeper | Gestion de la mémoire persistante |
| workflow-orchestrator | Orchestration automatique des agents |
| translator | Traduction EN/FR et synchronisation |

## Ressources connexes

- [Standard AGENTS.md](https://agents.md/)
- [Protocole MCP](https://modelcontextprotocol.io/)
- [Méthode BMAD](https://github.com/bmad-code-org/BMAD-METHOD)
- [Kiro spec-driven](https://kiro.dev/)
