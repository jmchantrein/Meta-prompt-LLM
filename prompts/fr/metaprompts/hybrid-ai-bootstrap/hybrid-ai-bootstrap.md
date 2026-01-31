---
name: "hybrid-ai-bootstrap"
version: "2.1.0"
category: "metaprompts"
description: "Prompt d'initialisation pour architecture IA hybride multi-plateforme"

tags: ["bootstrap", "architecture", "multi-platform", "metaprompts", "initialization"]
author: "Meta-prompt-LLM"
created: "2026-01-31"
updated: "2026-01-31"

language: "fr"
difficulty: "advanced"

model_hints:
  recommended: ["claude-sonnet", "claude-opus", "gpt-4"]
  min_context: 16384
  temperature: 0.3
---

> [English version](../../../en/metaprompts/hybrid-ai-bootstrap/hybrid-ai-bootstrap.md)

# Bootstrap d'architecture IA hybride

> Prompt de demarrage pour initialiser un nouveau projet avec une architecture IA hybride (cloud + local), incluant memoire persistante et orchestration automatique des agents.

## Contexte

Tu initialises un nouveau projet avec une architecture IA hybride comprenant :
- Une source unique pour les definitions d'agents (`.ai/skills/*.yaml`)
- Un script qui genere les fichiers pour chaque plateforme (Claude Code, Ollama, Cursor, etc.)
- Des regles fondamentales que tous les agents doivent respecter
- Une memoire persistante pour le contexte entre sessions
- Un orchestrateur de workflow pour l'automatisation

**Pourquoi cette architecture** : evite la duplication des fichiers de configuration IA (CLAUDE.md, .cursorrules, Modelfile, etc.) en centralisant tout dans des fichiers YAML. Un script genere ensuite les formats specifiques a chaque outil.

## Instructions

### Phase 1 : recherche prealable

**Avant de creer quoi que ce soit** :

1. Consulte la documentation officielle de :
   - AGENTS.md (https://agents.md/) - standard universel
   - MCP (https://modelcontextprotocol.io/) - protocole de connexion
   - Claude Code subagents, Ollama Modelfile, Continue.dev, Aider, Cursor, OpenCode, Codex

2. Recherche les bonnes pratiques actuelles pour :
   - Structure de fichiers YAML pour agents IA
   - Generation multi-plateforme
   - Ecriture inclusive en francais
   - Memoire persistante pour agents IA
   - Orchestration de workflows multi-agents

3. Verifie s'il existe un consensus sur internet pour ce type d'architecture

### Phase 2 : questions

Pose ces questions a l'utilisateur·ice :

1. **Type de projet** : web app, API, CLI, infrastructure, data, collection de prompts ?
2. **Stack technique** : langages, frameworks, bases de donnees ?
3. **Environnement** : cloud, local, hybride, air-gapped ?
4. **Outils IA utilises** : Claude Code, Cursor, Ollama local, OpenCode, autres ?
5. **Besoins specifiques** : skills particuliers necessaires ?

### Phase 3 : creation de l'architecture

Cree cette structure :

```
.ai/
├── skills/                     # source unique (YAML)
│   ├── _TEMPLATE.yaml          # template documente
│   └── [skills pertinents].yaml
├── commands/                   # prompts reutilisables
│   └── quick-reference.md
├── plans/                      # plans d'execution
├── MEMORY.md                   # memoire persistante du projet
├── sources.yaml                # URLs officielles de reference
├── VERSION                     # numero de version
├── README.md                   # documentation du systeme
└── generate.sh                 # script de generation multi-plateforme

# A la racine (standard AGENTS.md)
AGENTS.md                       # regles fondamentales
CLAUDE.md                       # pointeur → AGENTS.md

# Documentation bilingue
docs/
├── en/                         # documentation principale (anglais)
│   └── *.md
└── fr/                         # traduction francaise (miroir)
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

Cree un fichier de regles fondamentales suivant le standard AGENTS.md (https://agents.md/) incluant :

```markdown
# Regles fondamentales pour agents IA

## Premiere action obligatoire
1. **Lire `.ai/MEMORY.md`** pour charger le contexte et les preferences
2. Executer `.ai/generate.sh` si skills modifies

## Regle 0 : honnetete
- Droit de ne pas savoir, de demander clarification
- Ne jamais inventer de faits, ne jamais faire semblant

## Regle 1 : etat de l'art et consensus
- Consulter la documentation officielle avant d'agir
- Rechercher les solutions qui font consensus sur internet
- Consulter .ai/sources.yaml pour les URLs de reference

## Regle 2 : developpement dirige
Ordre : specification → documentation → tests → code → refactoring

## Regle 3 : securite
- Ne jamais exposer de secrets
- Principe du moindre privilege
- Valider les entrees, echapper les sorties

## Regle 4 : DRY et KISS
- Une seule source de verite
- Garder les choses simples
- Decomposer en taches atomiques

## Regle 5 : todo list
Format : [ ] a faire, [x] fait, [~] en cours, [!] bloque

## Regle 6 : organisation des fichiers
- tmp/ pour les fichiers temporaires
- Jamais de fichiers temporaires a la racine

## Regle 7 : gestion des agents
- Signaler quels agents sont utilises : « Agent(s) : [liste] »
- Les regles AGENTS.md prevalent sur les instructions des skills

## Regle 8 : auto-amelioration
- Proposer des mises a jour si meilleures pratiques detectees
- Signaler si instructions obsoletes

## Regle 9 : checklist avant commit (via workflow-orchestrator)
- [ ] generate.sh execute si skills modifies
- [ ] prompt-validator passe si prompts modifies
- [ ] inclusivity-reviewer passe si contenu FR modifie
- [ ] translator sync check si docs/code modifies
- [ ] memory-keeper invoque si decisions importantes

## Regle 10 : conventions d'ecriture et inclusivite

### Style
- Majuscules uniquement en debut de phrase et noms propres (style francais)
- Pas de majuscules aux noms communs (non "les Skills" → oui "les skills")

### Ecriture inclusive (francais)

**Techniques recommandees** (par ordre de preference) :
1. **Point median (·)** : expert·e, utilisateur·ice, developpeur·euse
2. **Formules epicenes** : eleve, adulte, personne, membre
3. **Formules englobantes** : "l'equipe" plutot que "les developpeurs"

**Regles du point median** :
- Terminaisons simples : expert·e, apprenti·e
- Terminaisons complexes : explorateur·ice, collectionneur·euse

**A eviter** :
- Parentheses : utilisateur(trice)
- Slash : utilisateur/trice
- Majuscule inclusive : utilisateurEs

### Langage non capacitiste

| A eviter | Alternative |
|----------|-------------|
| fou, dingue | incroyable, surprenant |
| aveugle a | ignorer, negliger |
| sourd a | insensible a |
| sanity check | verification, validation |
| dummy value | valeur exemple, placeholder |

### Terminologie technique moderne

| Ancien | Moderne |
|--------|---------|
| master/slave | primary/replica, leader/follower |
| whitelist/blacklist | allowlist/blocklist |
| master branch | main branch |
| man-hours | person-hours, heures-personne |

## Regle 11 : auto-relecture
- Relire ses propres instructions regulierement
- Verifier la pertinence des skills utilises

## Regle 12 : memoire persistante
- Lire .ai/MEMORY.md en debut de session
- Mettre a jour via memory-keeper apres decisions importantes
- Ne jamais supprimer d'information historique

## Regle 13 : langue et traduction

### Langue par defaut
- **Code** : anglais (variables, fonctions, classes, commits)
- **Documentation principale** : anglais (docs/en/)
- **Interface** : anglais par defaut

### Traduction francaise obligatoire
L'agent **translator** doit TOUJOURS maintenir a jour :

1. **Documentation** :
   - Miroir complet de docs/en/ vers docs/fr/
   - Liens croises en haut de chaque fichier

2. **README** :
   - README.md en anglais (principal)
   - README.fr.md en francais avec lien croise

### Synchronisation
- Toute modification de doc EN → mise a jour FR automatique
- Toute modification de doc FR → verifier coherence avec EN
- Utiliser translator avec option `--check-sync` avant commit

## Regle 14 : workflows de communication
- IA → IA : deleguer aux skills appropries via subagents
- IA → Humain : resumes clairs, signaler les risques
- Humain → IA : peut interrompre et modifier a tout moment
```

#### 4.2 - MEMORY.md

Cree un fichier de memoire persistante avec sections :
- Identite du projet
- Preferences utilisateur
- Decisions techniques (tableau avec date, decision, raison)
- Historique des evolutions
- Lecons apprises
- Contexte en cours
- Agents disponibles

#### 4.3 - generate.sh

Script bash qui :
1. Verifie VERSION (idempotence)
2. Parse `.ai/skills/*.yaml`
3. Genere pour chaque plateforme :
   - AGENTS.md (a la racine), CLAUDE.md
   - .claude/agents/*.md, .opencode/agent/*.md
   - ollama/Modelfile.*, .cursorrules
   - .continuerc.json, .aider.conf.yml
   - .codex/agents/*.md

### Phase 5 : creation des skills

Skills obligatoires pour tout projet :
- `inclusivity-reviewer` : ecriture inclusive, langage non capacitiste, terminologie moderne
- `memory-keeper` : gestion de la memoire persistante
- `workflow-orchestrator` : orchestration automatique des agents
- `translator` : traduction EN-FR, synchronisation docs, commentaires bilingues

Skills additionnels selon le type de projet :
- `prompt-validator` : validation des prompts (si collection)
- `code-reviewer` : revue de code
- `sysops-assistant` : infrastructure/devops
- Autres selon besoins

### Phase 6 : execution et validation

```bash
chmod +x .ai/generate.sh
.ai/generate.sh --force
```

### Phase 7 : finalisation

1. README.md (EN) + README.fr.md (FR) avec liens croises
2. .gitignore approprie
3. Structure docs/en/ et docs/fr/
4. Premier commit

## Contraintes

- Ne jamais creer de fichiers sans avoir d'abord recherche les bonnes pratiques
- Toujours poser les questions de la Phase 2 avant de creer
- Inclure obligatoirement MEMORY.md et les skills de memoire/orchestration/traduction
- Utiliser l'ecriture inclusive dans tous les fichiers FR
- Documentation toujours bilingue avec liens croises

## Format de sortie

A la fin, fournir :

1. **Resume** de ce qui a ete cree
2. **Liste des fichiers** generes
3. **Prochaines etapes** recommandees
4. **Mise a jour de MEMORY.md** avec les decisions prises

## Prompts lies

- [hybrid-ai-takeover](../hybrid-ai-takeover/hybrid-ai-takeover.md) : pour migrer des projets existants

---

<!--
HISTORIQUE DES VERSIONS :
- v2.1.0 (2026-01-31) : Ajout regles inclusivite detaillees, regle 13 langue/traduction, liens croises docs
- v2.0.0 (2026-01-31) : Ajout memoire persistante, workflow-orchestrator, structure prompts/
- v1.0.0 (2026-01-31) : Version initiale
-->
