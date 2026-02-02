# hybrid-ai-takeover

> [English version](../../../en/metaprompts/hybrid-ai-takeover/README.md)

Prompt de migration pour convertir des projets existants vers une architecture IA hybride avec configuration centralisée et support multi-plateforme.

## Cas d'utilisation

- Migrer un projet avec des fichiers de config IA dispersés
- Consolider CLAUDE.md, .cursorrules, Modelfile, etc.
- Ajouter une mémoire persistante à un projet existant
- Établir une documentation bilingue à partir de docs existantes

## Quand l'utiliser

Utilisez ce prompt quand :

- Vous avez un **projet existant** avec une configuration IA
- Les fichiers de config IA sont devenus désynchronisés
- Vous voulez centraliser et unifier les définitions d'agents
- Vous devez ajouter une orchestration de workflows à une configuration existante

Pour les nouveaux projets, utilisez plutôt [hybrid-ai-bootstrap](../hybrid-ai-bootstrap/hybrid-ai-bootstrap.md).

## Ce qu'il fait

1. **Découverte** : scanne les fichiers IA existants (CLAUDE.md, .cursorrules, etc.)
2. **Sauvegarde** : préserve tous les fichiers legacy dans `.ai/legacy-backup/`
3. **Analyse** : génère un rapport structuré de l'état actuel
4. **Migration** : extrait les règles et skills des fichiers legacy
5. **Centralisation** : crée une structure unifiée `.ai/skills/*.yaml`
6. **Génération** : produit des configs spécifiques à chaque plateforme depuis le YAML

## Sélection du paradigme

Le prompt vous aide à choisir le bon paradigme de développement :

| Contexte | Recommandé |
|----------|------------|
| Prototype rapide, POC | Vibe coding |
| Production, équipe | Spec-driven (style Kiro) |
| Complexe, multi-agent | Méthode BMAD |
| Refactoring, dette technique | TDD strict |
| Focus documentation | Doc-driven |

## Fonctionnalités de sécurité

- **Sauvegarde obligatoire** avant toute modification
- Fichiers legacy préservés dans `.ai/legacy-backup/`
- Résolution de conflits avec règles de priorité
- Checklist de validation avant finalisation

## Prérequis

- Un·e assistant·e IA capable d'opérations sur fichiers
- Environnement bash pour les scripts
- Projet existant à migrer

## Ressources connexes

- [hybrid-ai-bootstrap](../hybrid-ai-bootstrap/hybrid-ai-bootstrap.md) - pour les nouveaux projets
- [Standard AGENTS.md](https://agents.md/)
