# hybrid-ai-takeover

> [English version](../../../en/metaprompts/hybrid-ai-takeover/README.md)

Prompt de migration pour convertir des projets existants vers une architecture IA hybride avec configuration centralisee et support multi-plateforme.

## Cas d'utilisation

- Migrer un projet avec des fichiers de config IA disperses
- Consolider CLAUDE.md, .cursorrules, Modelfile, etc.
- Ajouter une memoire persistante a un projet existant
- Etablir une documentation bilingue a partir de docs existantes

## Quand l'utiliser

Utilisez ce prompt quand :

- Vous avez un **projet existant** avec une configuration IA
- Les fichiers de config IA sont devenus desynchronises
- Vous voulez centraliser et unifier les definitions d'agents
- Vous devez ajouter une orchestration de workflows a une configuration existante

Pour les nouveaux projets, utilisez plutot [hybrid-ai-bootstrap](../../hybrid-ai-bootstrap/hybrid-ai-bootstrap.md).

## Ce qu'il fait

1. **Decouverte** : scanne les fichiers IA existants (CLAUDE.md, .cursorrules, etc.)
2. **Sauvegarde** : preserve tous les fichiers legacy dans `.ai/legacy-backup/`
3. **Analyse** : genere un rapport structure de l'etat actuel
4. **Migration** : extrait les regles et skills des fichiers legacy
5. **Centralisation** : cree une structure unifiee `.ai/skills/*.yaml`
6. **Generation** : produit des configs specifiques a chaque plateforme depuis le YAML

## Selection du paradigme

Le prompt vous aide a choisir le bon paradigme de developpement :

| Contexte | Recommande |
|----------|------------|
| Prototype rapide, POC | Vibe coding |
| Production, equipe | Spec-driven (style Kiro) |
| Complexe, multi-agent | Methode BMAD |
| Refactoring, dette technique | TDD strict |
| Focus documentation | Doc-driven |

## Fonctionnalites de securite

- **Sauvegarde obligatoire** avant toute modification
- Fichiers legacy preserves dans `.ai/legacy-backup/`
- Resolution de conflits avec regles de priorite
- Checklist de validation avant finalisation

## Prerequis

- Un·e assistant·e IA capable d'operations sur fichiers
- Environnement bash pour les scripts
- Projet existant a migrer

## Ressources connexes

- [hybrid-ai-bootstrap](../../hybrid-ai-bootstrap/hybrid-ai-bootstrap.md) - pour les nouveaux projets
- [Standard AGENTS.md](https://agents.md/)
