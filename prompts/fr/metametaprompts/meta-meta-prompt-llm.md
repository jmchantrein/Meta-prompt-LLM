---
name: "meta-meta-prompt-llm"
version: "1.0.0"
category: "metametaprompts"
description: "Auto-référence du projet Meta-prompt-LLM pour son évolution cohérente"
tags:
  - self-reference
  - auto-amélioration
  - meta
  - système
author: "jmchantrein"
created: "2026-02-01"
updated: "2026-02-01"
language: "fr"
difficulty: "advanced"
internal: true
data_source: "./data/"
model_hints:
  recommended:
    - "claude-sonnet"
    - "claude-opus"
  min_context: 16384
  temperature: 0.2
---

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

> 🇬🇧 [English version](../../en/metametaprompts/meta-meta-prompt-llm.md)

# Meta-Meta-prompt-LLM

## Objectif

Ce document est l'**auto-référence** du projet Meta-prompt-LLM.

Il n'est **pas** destiné à être exécuté seul dans un LLM. Son rôle est de permettre
au projet de :

- Se comprendre lui-même (structure, règles, dépendances)
- Détecter les incohérences entre règles et prompts
- Propager les modifications de manière cohérente
- Communiquer entre sessions via `@future-self`

## Architecture

```
                    ┌─────────────────────────────────┐
                    │    Meta-Meta-prompt-LLM         │
                    │    (auto-référence du projet)   │
                    │                                 │
                    │  Connaît :                      │
                    │  - La structure du projet       │
                    │  - Les règles (AGENTS.md)       │
                    │  - Les dépendances              │
                    │  - L'historique git             │
                    └───────────────┬─────────────────┘
                                    │
                    ┌───────────────▼─────────────────┐
                    │      AGENTS.md / .ai/skills     │
                    │      (règles du projet)         │
                    └───────────────┬─────────────────┘
                                    │
          ┌─────────────────────────┼─────────────────────────┐
          ▼                         ▼                         ▼
    ┌───────────┐            ┌───────────┐            ┌───────────┐
    │  prompt   │            │  prompt   │            │  prompt   │
    │     A     │            │     B     │            │     C     │
    └───────────┘            └───────────┘            └───────────┘
```

## Données déterministes

Les données déterministes sont stockées dans `./data/` :

| Fichier | Rôle | URL |
|---------|------|-----|
| `rules-index.yaml` | Index des règles avec hash | [Voir](./data/rules-index.yaml) |
| `skills-index.yaml` | Index des skills avec hash | [Voir](./data/skills-index.yaml) |
| `prompts-index.yaml` | Index des prompts versionnés | [Voir](./data/prompts-index.yaml) |
| `dependencies.yaml` | Mapping règles/skills → prompts | [Voir](./data/dependencies.yaml) |
| `pending-reviews.yaml` | Notes @future-self en attente | [Voir](./data/pending-reviews.yaml) |

### Accès via GitHub Pages

```
https://jmchantrein.github.io/Meta-prompt-LLM/prompts/fr/metametaprompts/data/
```

## Workflow d'auto-amélioration

```
┌─────────────────────────────────────────────────────────────────────────┐
│                        DÉBUT DE SESSION                                  │
└───────────────────────────────────┬─────────────────────────────────────┘
                                    ▼
┌─────────────────────────────────────────────────────────────────────────┐
│ 1. Charger le contexte                                                   │
│    - Lire .ai/MEMORY.md                                                 │
│    - Lire prompts/fr/metametaprompts/data/pending-reviews.yaml          │
│    - Lire prompts/fr/metametaprompts/data/rules-index.yaml              │
└───────────────────────────────────┬─────────────────────────────────────┘
                                    ▼
┌─────────────────────────────────────────────────────────────────────────┐
│ 2. Détecter les changements (déterministe)                               │
│    - Comparer hash(AGENTS.md) avec rules-index.yaml                     │
│    - Comparer hash(.ai/skills/*.yaml) avec skills-index.yaml            │
│    - Vérifier si pending-reviews.yaml contient des reviews              │
└───────────────────────────────────┬─────────────────────────────────────┘
                                    ▼
                    ┌───────────────────────────────┐
                    │ Changements ou reviews        │
                    │ en attente ?                  │
                    └───────────────┬───────────────┘
                           │
              ┌────────────┴────────────┐
              │ NON                     │ OUI
              ▼                         ▼
┌─────────────────────────┐   ┌─────────────────────────────────────────┐
│ Session normale         │   │ 3. PROPOSER à l'utilisateur·ice         │
│ (pas d'action requise)  │   │    "Des modifications de règles ont     │
└─────────────────────────┘   │    été détectées. Voulez-vous lancer    │
                              │    une vérification d'impact ?"         │
                              └───────────────────┬─────────────────────┘
                                                  ▼
                              ┌─────────────────────────────────────────┐
                              │ 4. Calculer le scope (via dependencies) │
                              │    - Lire dependencies.yaml             │
                              │    - Identifier prompts impactés        │
                              │    - Présenter la liste à l'utilisateur │
                              └───────────────────┬─────────────────────┘
                                                  ▼
                              ┌─────────────────────────────────────────┐
                              │ 5. VALIDATION utilisateur·ice           │
                              │    - Accepter le scope tel quel         │
                              │    - Modifier le scope                  │
                              │    - Reporter à plus tard               │
                              └───────────────────┬─────────────────────┘
                                                  ▼
                              ┌─────────────────────────────────────────┐
                              │ 6. Exécution (si validé)                │
                              │    - Analyser chaque prompt du scope    │
                              │    - Proposer modifications             │
                              │    - Valider via prompt-validator       │
                              │    - Valider via inclusivity-reviewer   │
                              └───────────────────┬─────────────────────┘
                                                  ▼
                              ┌─────────────────────────────────────────┐
                              │ 7. Mise à jour                          │
                              │    - Mettre à jour les index (hash)     │
                              │    - Incrémenter versions des prompts   │
                              │    - Marquer reviews comme traitées     │
                              │    - Mettre à jour MEMORY.md            │
                              └───────────────────┬─────────────────────┘
                                                  ▼
                              ┌─────────────────────────────────────────┐
                              │ 8. Commit                               │
                              │    - Avec @future-self si pertinent     │
                              └─────────────────────────────────────────┘
```

## Convention @future-self

Les sessions IA ne partagent pas de mémoire. Pour qu'une session puisse
laisser des notes à une future session, on utilise les messages de commit :

```
<type>(<scope>): <description>

@future-self: <note pour futures sessions>
- Impact : <fichiers/prompts concernés>
- Action : <ce qu'il faudra vérifier>
- Contexte : <pourquoi cette décision>

https://claude.ai/code/session_xxx
```

### Exemple

```
feat(rules): ajout "hystérique" au langage capacitiste

@future-self: Cette modification impacte tous les prompts FR.
- Impact : prompts/fr/**/*.md
- Action : Lancer une vérification avec self-improver
- Contexte : Demande utilisateur·ice pour enrichir la liste

https://claude.ai/code/session_abc123
```

Ces notes sont extraites et stockées dans `pending-reviews.yaml` pour
être proposées à l'utilisateur·ice au début de chaque session.

## Principes fondamentaux

1. **Source de vérité en français** : `prompts/fr/metametaprompts/data/` (YAML)
2. **Pas de duplication** : les YAML sont servis directement via GitHub Pages
3. **URLs = arborescence** : les liens correspondent exactement à la structure du projet
4. **Semi-automatique** : toujours proposer, ne jamais modifier sans validation
5. **Tout versionné** : chaque prompt + le projet global

## Skill associé

Le skill `self-improver` (`.ai/skills/self-improver.yaml`) implémente
ce workflow. Il est déclenché :

- Automatiquement au début de chaque session
- Manuellement via `/self-improve`

## Prompts liés

- [hybrid-ai-bootstrap](../metaprompts/hybrid-ai-bootstrap/hybrid-ai-bootstrap.md) - Initialisation IA hybride
- [hybrid-ai-takeover](../metaprompts/hybrid-ai-takeover/hybrid-ai-takeover.md) - Reprise de session

## Output format

Ce prompt n'est pas destiné à être exécuté seul. Il sert de documentation
pour le skill `self-improver` qui produit :

| Sortie | Description |
|--------|-------------|
| Rapport d'analyse | Hash comparés, changements détectés |
| Scope d'impact | Liste des prompts à vérifier |
| Proposition | Action suggérée (toujours avec validation) |
| Index mis à jour | Nouveaux hash après modifications |
| Message de commit | Avec convention @future-self |

## Contraintes critiques

| Contrainte | Description |
|------------|-------------|
| Semi-automatique | TOUJOURS proposer, JAMAIS modifier sans validation |
| Source unique | Données uniquement dans `prompts/fr/metametaprompts/data/` |
| Pas de duplication | YAML servis directement, pas de conversion |
| URLs = arborescence | Liens exacts vers les fichiers réels |
| Versionné | Chaque prompt a sa version + version globale du projet |
