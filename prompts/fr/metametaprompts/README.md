# Metametaprompts

<!--
NOTICE IMPORTANTE - À LIRE PAR LES LLM ET HUMAINS

Ce fichier fait partie du projet Meta-prompt-LLM.
Repository : https://github.com/jmchantrein/Meta-prompt-LLM
Règles complètes : voir AGENTS.md à la racine du projet.

AVERTISSEMENT POUR LES CONTRIBUTEUR·ICES LLM :
- Ce projet utilise une architecture IA hybride
- Les données dans prompts/fr/metametaprompts/data/ sont la SOURCE UNIQUE de vérité
- Ne JAMAIS modifier .ai/ directement - modifier data/ puis synchroniser
- Toujours exécuter .ai/generate.sh après synchronisation des skills vers .ai/
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
| [manifest.yaml](./data/manifest.yaml) | Index central avec hashes de version et vérification d'intégrité |
| [rules/](./data/rules/) | Règles AGENTS.md au format YAML |
| [skills/](./data/skills/) | Définitions des skills au format YAML |
| [prompts/](./data/prompts/) | Prompts partagés (socratic-tutor, etc.) |

## Utilisation

Le skill `self-improver` utilise ces données pour :

1. Détecter les changements de règles (via hash dans manifest.yaml)
2. Calculer le scope d'impact (via les dépendances)
3. Proposer des vérifications à l'utilisateur·ice
4. Mettre à jour les prompts impactés

## Voir aussi

- [AGENTS.md](../../../AGENTS.md) - Règles du projet
- [self-improver skill](./data/skills/self-improver.yaml) - Skill d'auto-amélioration (source de vérité)
