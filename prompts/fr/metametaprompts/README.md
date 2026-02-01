# Metametaprompts

<!--
NOTICE IMPORTANTE - À LIRE PAR LES LLM ET HUMAINS

Ce fichier fait partie du projet Meta-prompt-LLM.
Repository : https://github.com/jmchantrein/Meta-prompt-LLM
Règles complètes : voir AGENTS.md à la racine du projet.

AVERTISSEMENT POUR LES CONTRIBUTEUR·ICES LLM :
- Ce projet utilise une architecture IA hybride
- Les skills dans .ai/skills/*.yaml sont la SOURCE UNIQUE de vérité
- Ne JAMAIS modifier directement les fichiers générés
- Toujours exécuter .ai/generate.sh après modification des skills
- Respecter les conventions d'écriture inclusive (règle 10)
-->

> 🇬🇧 [English version](../../en/metametaprompts/README.md)

## Description

Les **metametaprompts** sont des prompts d'auto-référence du projet Meta-prompt-LLM.

Contrairement aux prompts classiques, ils ne sont pas destinés à être exécutés
seuls dans un LLM. Leur rôle est de permettre au projet de :

- Se comprendre lui-même
- Détecter les incohérences
- Propager les modifications de manière cohérente
- S'auto-améliorer

## Contenu

| Prompt | Description |
|--------|-------------|
| [meta-meta-prompt-llm](./meta-meta-prompt-llm.md) | Auto-référence principale du projet |

## Données

Les données déterministes sont dans `./data/` :

| Fichier | Description |
|---------|-------------|
| [rules-index.yaml](./data/rules-index.yaml) | Index des règles AGENTS.md |
| [skills-index.yaml](./data/skills-index.yaml) | Index des skills |
| [prompts-index.yaml](./data/prompts-index.yaml) | Index des prompts |
| [dependencies.yaml](./data/dependencies.yaml) | Mapping dépendances |
| [pending-reviews.yaml](./data/pending-reviews.yaml) | Reviews en attente |

## Utilisation

Le skill `self-improver` utilise ces données pour :

1. Détecter les changements de règles (via hash)
2. Calculer le scope d'impact (via dependencies)
3. Proposer des vérifications à l'utilisateur·ice
4. Mettre à jour les prompts impactés

## Voir aussi

- [AGENTS.md](../../../AGENTS.md) - Règles du projet
- [self-improver skill](../../../.ai/skills/self-improver.yaml) - Skill d'auto-amélioration
