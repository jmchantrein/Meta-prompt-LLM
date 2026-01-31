---
name: "hybrid-ai-bootstrap"
version: "2.1.0"
category: "meta"
description: "Prompt d'initialisation pour architecture IA hybride multi-plateforme"

tags: ["bootstrap", "architecture", "multi-platform", "meta-prompt", "initialization"]
author: "Meta-prompt-LLM"
created: "2026-01-31"
updated: "2026-01-31"

model_hints:
  recommended: ["claude-sonnet", "claude-opus", "gpt-4"]
  min_context: 16384
  temperature: 0.3
---

# Bootstrap d'architecture IA hybride

Prompt de démarrage pour initialiser un nouveau projet avec une architecture IA hybride (cloud + local), incluant mémoire persistante et orchestration automatique des agents.

## Contexte

Tu initialises un nouveau projet avec une architecture IA hybride comprenant :
- Une source unique pour les définitions d'agents (`.ai/skills/*.yaml`)
- Un script qui génère les fichiers pour chaque plateforme (Claude Code, Ollama, Cursor, etc.)
- Des règles fondamentales que tous les agents doivent respecter
- Une mémoire persistante pour le contexte entre sessions
- Un orchestrateur de workflow pour l'automatisation

**Pourquoi cette architecture** : évite la duplication des fichiers de configuration IA (CLAUDE.md, .cursorrules, Modelfile, etc.) en centralisant tout dans des fichiers YAML. Un script génère ensuite les formats spécifiques à chaque outil.

## Instructions

### Phase 1 : recherche préalable

**Avant de créer quoi que ce soit** :

1. Consulte la documentation officielle de :
   - AGENTS.md (https://agents.md/) - standard universel
   - MCP (https://modelcontextprotocol.io/) - protocole de connexion
   - Claude Code subagents, Ollama Modelfile, Continue.dev, Aider, Cursor, OpenCode, Codex

2. Recherche les bonnes pratiques actuelles pour :
   - Structure de fichiers YAML pour agents IA
   - Génération multi-plateforme
   - Écriture inclusive en français
   - Mémoire persistante pour agents IA
   - Orchestration de workflows multi-agents

3. Vérifie s'il existe un consensus sur internet pour ce type d'architecture

### Phase 2 : questions

Pose ces questions à l'utilisateur·ice :

1. **Type de projet** : web app, API, CLI, infrastructure, data, collection de prompts ?
2. **Stack technique** : langages, frameworks, bases de données ?
3. **Environnement** : cloud, local, hybride, air-gapped ?
4. **Outils IA utilisés** : Claude Code, Cursor, Ollama local, OpenCode, autres ?
5. **Besoins spécifiques** : skills particuliers nécessaires ?

### Phase 3 : création de l'architecture

Crée cette structure :

```
.ai/
├── skills/                     # source unique (YAML)
│   ├── _TEMPLATE.yaml          # template documenté
│   └── [skills pertinents].yaml
├── commands/                   # prompts réutilisables
│   └── quick-reference.md
├── plans/                      # plans d'exécution
├── MEMORY.md                   # mémoire persistante du projet
├── sources.yaml                # URLs officielles de référence
├── VERSION                     # numéro de version
├── README.md                   # documentation du système
└── generate.sh                 # script de génération multi-plateforme

# À la racine (standard AGENTS.md)
AGENTS.md                       # règles fondamentales
CLAUDE.md                       # pointeur → AGENTS.md

# Documentation bilingue
docs/
├── en/                         # documentation principale (anglais)
│   └── *.md
└── fr/                         # traduction française (miroir)
    └── *.md

prompts/                        # collection de prompts (si applicable)
├── _TEMPLATE.md
├── _metadata/
│   ├── categories.yaml
│   └── languages.yaml
└── [categories]/

tmp/                            # fichiers temporaires (gitignored)
```

### Phase 4 : contenu des fichiers critiques

#### 4.1 - AGENTS.md

Crée un fichier de règles fondamentales suivant le standard AGENTS.md (https://agents.md/) incluant :

```markdown
# Règles fondamentales pour agents IA

## Première action obligatoire
1. **Lire `.ai/MEMORY.md`** pour charger le contexte et les préférences
2. Exécuter `.ai/generate.sh` si skills modifiés

## Règle 0 : honnêteté
- Droit de ne pas savoir, de demander clarification
- Ne jamais inventer de faits, ne jamais faire semblant

## Règle 1 : état de l'art et consensus
- Consulter la documentation officielle avant d'agir
- Rechercher les solutions qui font consensus sur internet
- Consulter .ai/sources.yaml pour les URLs de référence

## Règle 2 : développement dirigé
Ordre : spécification → documentation → tests → code → refactoring

## Règle 3 : sécurité
- Ne jamais exposer de secrets
- Principe du moindre privilège
- Valider les entrées, échapper les sorties

## Règle 4 : DRY et KISS
- Une seule source de vérité
- Garder les choses simples
- Décomposer en tâches atomiques

## Règle 5 : todo list
Format : [ ] à faire, [x] fait, [~] en cours, [!] bloqué

## Règle 6 : organisation des fichiers
- tmp/ pour les fichiers temporaires
- Jamais de fichiers temporaires à la racine

## Règle 7 : gestion des agents
- Signaler quels agents sont utilisés : « 🤖 Agent(s) : [liste] »
- Les règles AGENTS.md prévalent sur les instructions des skills

## Règle 8 : auto-amélioration
- Proposer des mises à jour si meilleures pratiques détectées
- Signaler si instructions obsolètes

## Règle 9 : checklist avant commit (via workflow-orchestrator)
- [ ] generate.sh exécuté si skills modifiés
- [ ] prompt-validator passé si prompts modifiés
- [ ] inclusivity-reviewer passé si contenu FR modifié
- [ ] translator sync check si docs/code modifiés
- [ ] memory-keeper invoqué si décisions importantes

## Règle 10 : conventions d'écriture et inclusivité

### Style
- Majuscules uniquement en début de phrase et noms propres (style français)
- Pas de majuscules aux noms communs (❌ "les Skills" → ✅ "les skills")

### Écriture inclusive (français)

**Techniques recommandées** (par ordre de préférence) :
1. **Point médian (·)** : expert·e, utilisateur·ice, développeur·euse
2. **Formules épicènes** : élève, adulte, personne, membre
3. **Formules englobantes** : "l'équipe" plutôt que "les développeurs"

**Règles du point médian** :
- Terminaisons simples : expert·e, apprenti·e
- Terminaisons complexes : explorateur·ice, collectionneur·euse

**À éviter** :
- Parenthèses : ❌ utilisateur(trice)
- Slash : ❌ utilisateur/trice
- Majuscule inclusive : ❌ utilisateurEs

### Langage non capacitiste

| ❌ À éviter | ✅ Alternative |
|-------------|----------------|
| fou, dingue | incroyable, surprenant |
| aveugle à | ignorer, négliger |
| sourd à | insensible à |
| sanity check | vérification, validation |
| dummy value | valeur exemple, placeholder |

### Terminologie technique moderne

| ❌ Ancien | ✅ Moderne |
|----------|-----------|
| master/slave | primary/replica, leader/follower |
| whitelist/blacklist | allowlist/blocklist |
| master branch | main branch |
| man-hours | person-hours, heures-personne |

## Règle 11 : auto-relecture
- Relire ses propres instructions régulièrement
- Vérifier la pertinence des skills utilisés

## Règle 12 : mémoire persistante
- Lire .ai/MEMORY.md en début de session
- Mettre à jour via memory-keeper après décisions importantes
- Ne jamais supprimer d'information historique

## Règle 13 : langue et traduction

### Langue par défaut
- **Code** : anglais (variables, fonctions, classes, commits)
- **Documentation principale** : anglais (docs/en/)
- **Interface** : anglais par défaut

### Traduction française obligatoire
L'agent **translator** doit TOUJOURS maintenir à jour :

1. **Documentation** :
   - Miroir complet de docs/en/ vers docs/fr/
   - Liens croisés en haut de chaque fichier :
     ```markdown
     <!-- docs/en/guide.md -->
     > 🇫🇷 [Version française](../fr/guide.md)
     
     <!-- docs/fr/guide.md -->
     > 🇬🇧 [English version](../en/guide.md)
     ```

2. **Commentaires de code** (si langages supportés) :
   ```python
   # Initialize the configuration
   # FR: Initialise la configuration
   def init_config():
       pass
   ```

3. **README** :
   - README.md en anglais (principal)
   - README.fr.md en français avec lien croisé

### Synchronisation
- Toute modification de doc EN → mise à jour FR automatique
- Toute modification de doc FR → vérifier cohérence avec EN
- Utiliser translator avec option `--check-sync` avant commit

## Règle 14 : workflows de communication
- IA → IA : déléguer aux skills appropriés via subagents
- IA → Humain : résumés clairs, signaler les risques
- Humain → IA : peut interrompre et modifier à tout moment
```

#### 4.2 - MEMORY.md

Crée un fichier de mémoire persistante avec sections :
- Identité du projet
- Préférences utilisateur
- Décisions techniques (tableau avec date, décision, raison)
- Historique des évolutions
- Leçons apprises
- Contexte en cours
- Agents disponibles

#### 4.3 - generate.sh

Script bash qui :
1. Vérifie VERSION (idempotence)
2. Parse `.ai/skills/*.yaml`
3. Génère pour chaque plateforme :
   - AGENTS.md (à la racine), CLAUDE.md
   - .claude/agents/*.md, .opencode/agent/*.md
   - ollama/Modelfile.*, .cursorrules
   - .continuerc.json, .aider.conf.yml
   - .codex/agents/*.md

### Phase 5 : création des skills

Skills obligatoires pour tout projet :
- `inclusivity-reviewer` : écriture inclusive, langage non capacitiste, terminologie moderne
- `memory-keeper` : gestion de la mémoire persistante
- `workflow-orchestrator` : orchestration automatique des agents
- `translator` : traduction EN↔FR, synchronisation docs, commentaires bilingues

Skills additionnels selon le type de projet :
- `prompt-validator` : validation des prompts (si collection)
- `code-reviewer` : revue de code
- `sysops-assistant` : infrastructure/devops
- Autres selon besoins

### Phase 6 : exécution et validation

```bash
chmod +x .ai/generate.sh
.ai/generate.sh --force
```

### Phase 7 : finalisation

1. README.md (EN) + README.fr.md (FR) avec liens croisés
2. .gitignore approprié
3. Structure docs/en/ et docs/fr/
4. Premier commit

## Contraintes

- Ne jamais créer de fichiers sans avoir d'abord recherché les bonnes pratiques
- Toujours poser les questions de la Phase 2 avant de créer
- Inclure obligatoirement MEMORY.md et les skills de mémoire/orchestration/traduction
- Utiliser l'écriture inclusive dans tous les fichiers FR
- Documentation toujours bilingue avec liens croisés

## Format de sortie

À la fin, fournir :
1. Résumé de ce qui a été créé
2. Liste des fichiers générés
3. Prochaines étapes recommandées
4. Mise à jour de MEMORY.md avec les décisions prises

---

<!--
HISTORIQUE DES VERSIONS :
- v2.1.0 (2026-01-31) : Ajout règles inclusivité détaillées, règle 13 langue/traduction, liens croisés docs
- v2.0.0 (2026-01-31) : Ajout mémoire persistante, workflow-orchestrator, structure prompts/
- v1.0.0 (2026-01-31) : Version initiale
-->
