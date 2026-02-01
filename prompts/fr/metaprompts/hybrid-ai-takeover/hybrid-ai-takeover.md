---
name: "hybrid-ai-takeover"
version: "2.1.0"
category: "metaprompts"
description: "Prompt de reprise d'un projet existant vers architecture IA hybride multi-plateforme"

tags: ["takeover", "migration", "architecture", "multi-platform", "metaprompts"]
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

<!-- META
prompt_id: "hybrid-ai-takeover"
version: "2.1.0"
source_url: "https://raw.githubusercontent.com/jmchantrein/Meta-prompt-LLM/main/prompts/fr/metaprompts/hybrid-ai-takeover/hybrid-ai-takeover.md"
applicable_rules: ["rule-0", "rule-1", "rule-2", "rule-4", "rule-8", "rule-10"]
applicable_skills: ["prompt-validator", "inclusivity-reviewer", "translator"]

# --- PROMPTS COPIER-COLLER ---
use_prompt: "Récupère et applique le prompt depuis : https://raw.githubusercontent.com/jmchantrein/Meta-prompt-LLM/main/prompts/fr/metaprompts/hybrid-ai-takeover/hybrid-ai-takeover.md"
update_prompt: |
  Vérifie si mon prompt est à jour :
  - Ma version : 2.1.0
  - Source : https://raw.githubusercontent.com/jmchantrein/Meta-prompt-LLM/main/prompts/fr/metaprompts/hybrid-ai-takeover/hybrid-ai-takeover.md
  Compare les versions et informe-moi des changements.
-->

> [English version](../../../en/metaprompts/hybrid-ai-takeover/hybrid-ai-takeover.md)

# Reprise de projet vers architecture IA hybride

> Prompt de demarrage pour migrer un projet existant vers une architecture IA hybride (cloud + local), incluant memoire persistante et orchestration automatique des agents.

## Contexte

Tu reprends un projet existant et tu dois le migrer vers une architecture IA hybride comprenant :
- Une source unique pour les definitions d'agents (`.ai/skills/*.yaml`)
- Un script qui genere les fichiers pour chaque plateforme (Claude Code, Ollama, Cursor, etc.)
- Des regles fondamentales que tous les agents doivent respecter
- Une memoire persistante pour le contexte entre sessions
- Un orchestrateur de workflow pour l'automatisation

**Pourquoi cette migration** : les projets accumulent souvent des fichiers de configuration IA disparates (CLAUDE.md, .cursorrules, Modelfile, etc.) qui se desynchronisent. Cette architecture centralise tout et genere automatiquement les formats specifiques.

## Instructions

### Phase 1 : recherche prealable

**Avant de faire quoi que ce soit** :

1. Consulte la documentation officielle de :
   - AGENTS.md (https://agents.md/) - standard universel
   - MCP (https://modelcontextprotocol.io/) - protocole de connexion
   - Claude Code subagents, Ollama Modelfile, Continue.dev, Aider, Cursor, OpenCode, Codex

2. Recherche les bonnes pratiques actuelles pour :
   - Migration de configurations IA existantes
   - Structure de fichiers YAML pour agents IA
   - Ecriture inclusive en francais
   - Memoire persistante pour agents IA

3. Verifie s'il existe un consensus sur ce type de migration

### Phase 2 : decouverte du projet

Explore le projet et reponds a ces questions :

```bash
# Fichiers IA existants
find . -name "CLAUDE.md" -o -name "AGENTS.md" -o -name ".cursorrules" \
       -o -name ".windsurfrules" -o -name "Modelfile*" \
       -o -name ".aider*" -o -name ".continuerc*" -o -name "RULES.md" 2>/dev/null

# Structure documentation existante
ls -la docs/ 2>/dev/null
ls -la README*.md 2>/dev/null

# Stack technique
cat package.json 2>/dev/null || cat Cargo.toml 2>/dev/null || \
cat go.mod 2>/dev/null || cat requirements.txt 2>/dev/null

# Structure generale
ls -la
```

Pose ces questions a l'utilisateur·ice :

1. **Historique** : depuis combien de temps ce projet existe-t-il ? Decisions importantes passees ?
2. **Stack technique** : confirmer langages, frameworks, bases de donnees detectes
3. **Environnement** : cloud, local, hybride, air-gapped ?
4. **Outils IA utilises** : lesquels actuellement ? lesquels souhaites ?
5. **Paradigme actuel** : comment le developpement est-il organise actuellement ?
6. **Paradigme souhaite** : (expliquer les options si besoin)

### Aide au choix du paradigme

| Contexte | Paradigme recommande | Pourquoi |
|----------|---------------------|----------|
| Prototype rapide, exploration, POC | **Vibe coding** | Iteration rapide, feedback immediat |
| Production, equipe, maintenabilite | **Spec-driven** (Kiro-style) | Specifications avant code, tracabilite |
| Projet complexe, multi-agents, evolutif | **BMAD** | Personas, orchestration, documentation riche |
| Refactoring, dette technique | **TDD strict** | Tests d'abord, non-regression |
| Documentation/contenu | **Doc-driven** | Documentation comme source de verite |

**Recherche prealable** : avant de recommander, consulte :
- BMAD : https://github.com/bmad-code-org/BMAD-METHOD
- Kiro (spec-driven) : https://kiro.dev/

### Phase 3 : rapport d'analyse

Genere un rapport structure :

```markdown
## Rapport d'analyse - [Nom du projet]

### Fichiers IA existants
| Fichier | Present | Contenu principal |
|---------|---------|-------------------|
| CLAUDE.md | oui/non | [resume] |
| AGENTS.md | oui/non | [resume] |
| RULES.md | oui/non | [resume] |
| .cursorrules | oui/non | [resume] |
| Modelfile | oui/non | [resume] |
| .aider.conf.yml | oui/non | [resume] |
| .continuerc.json | oui/non | [resume] |

### Documentation existante
| Element | Present | Langue(s) |
|---------|---------|-----------|
| README.md | oui/non | EN/FR |
| docs/ | oui/non | structure |

### Stack detectee
- Langages : ...
- Frameworks : ...
- Tests : ...

### Conventions existantes identifiees
- ...

### Conflits potentiels
- ...

### Paradigme actuel detecte
- ...
```

### Phase 4 : backup des fichiers legacy

**Obligatoire avant toute modification** :

```bash
mkdir -p .ai/legacy-backup

# Backup fichiers IA existants
for file in CLAUDE.md AGENTS.md RULES.md .cursorrules .windsurfrules \
            .aider.conf.yml .continuerc.json; do
    [ -f "$file" ] && cp "$file" ".ai/legacy-backup/${file}.backup"
done

# Backup dossiers
[ -d ".claude" ] && cp -r .claude .ai/legacy-backup/
[ -d ".cursor" ] && cp -r .cursor .ai/legacy-backup/
[ -d "ollama" ] && cp -r ollama .ai/legacy-backup/

# Backup documentation existante
[ -d "docs" ] && cp -r docs .ai/legacy-backup/
[ -f "README.md" ] && cp README.md .ai/legacy-backup/
[ -f "README.fr.md" ] && cp README.fr.md .ai/legacy-backup/
```

### Phase 5 : creation de l'architecture centralisee

Cree la structure `.ai/` :

```
.ai/
├── skills/                     # source unique (YAML)
│   ├── _TEMPLATE.yaml
│   └── [skills extraits et nouveaux].yaml
├── commands/
│   └── quick-reference.md
├── plans/
├── legacy-backup/              # fichiers originaux (cree en phase 4)
├── MEMORY.md                   # memoire persistante (pre-remplie)
├── sources.yaml
├── VERSION                     # 1.0.0
├── README.md
└── generate.sh

# A la racine (standard AGENTS.md)
AGENTS.md                       # regles fondamentales (fusionne tout)
CLAUDE.md                       # pointeur -> AGENTS.md

# Documentation bilingue
docs/
├── en/                         # documentation principale (anglais)
└── fr/                         # traduction francaise (miroir)

README.md                       # anglais (principal)
README.fr.md                    # francais (lien croise)
```

### Phase 6 : extraction et fusion des contenus legacy

Pour chaque fichier legacy trouve :

1. **Extrais les instructions** (personas, regles, conventions)
2. **Identifie les skills implicites** (roles definis)
3. **Fusionne dans AGENTS.md** (regles) et `.ai/skills/*.yaml` (agents)
4. **Resous les conflits** (priorite au plus recent/detaille)

**Important** : l'ancien RULES.md (s'il existe) doit etre fusionne dans AGENTS.md a la racine.

Exemple de fusion :

```yaml
# .ai/skills/project-assistant.yaml
# Fusionne depuis : CLAUDE.md (backup), .cursorrules (backup)

name: "project-assistant"
version: "1.0.0"
description: "Assistant principal - fusionne depuis configs legacy"

persona: |
  [Contenu harmonise depuis les fichiers legacy]

security:
  never:
    - [Regles extraites]
  always:
    - [Regles extraites]
  ask_before:
    - [Actions necessitant confirmation]
```

### Phase 7 : migration de la documentation

1. **Si docs/ existe mais pas bilingue** :
   - Deplacer vers docs/en/ ou docs/fr/ selon la langue
   - Creer le miroir dans l'autre langue
   - Ajouter liens croises

2. **Si README existe mais pas bilingue** :
   - README.md devient la version anglaise
   - Creer README.fr.md (traduction)
   - Ajouter liens croises en haut

3. **Si deja bilingue** :
   - Verifier la synchronisation
   - Ajouter liens croises si absents

4. **Notices obligatoires en haut des README** (apres le lien de version) :
   ```markdown
   > [!WARNING]
   > Ce projet est en cours de developpement. La structure et les APIs peuvent changer.

   > [!NOTE]
   > **Developpement LLM (IA) assiste par etre(s) humain(s)** : Ce projet a ete developpe des le depart avec l'assistance de LLM. Le codebase inclut une architecture IA hybride avec des agents specialises. Cette architecture a ete definie avec le prompt [hybrid-ai-takeover](https://github.com/jmchantrein/Meta-prompt-LLM/tree/main/prompts/fr/metaprompts/hybrid-ai-takeover).
   ```

### Phase 8 : creation de AGENTS.md

Cree AGENTS.md a la racine avec toutes les regles fusionnees, incluant :

- Premiere action obligatoire (lire MEMORY.md)
- Regle 0 : honnetete
- Regle 1 : etat de l'art et consensus
- Regle 2 : developpement dirige
- Regle 3 : securite
- Regle 4 : DRY et KISS
- Regle 5 : todo list
- Regle 6 : organisation des fichiers
- Regle 7 : gestion des agents
- Regle 8 : auto-amelioration
- Regle 9 : checklist avant commit
- Regle 10 : conventions d'ecriture et inclusivite
- Regle 11 : auto-relecture
- Regle 12 : memoire persistante
- Regle 13 : langue et traduction
- Regle 14 : workflows de communication
- Regle 15 : actions post-revue (OBLIGATOIRE)

### Phase 9 : creation de MEMORY.md (pre-rempli)

Cree `.ai/MEMORY.md` avec l'historique du projet incluant :
- Identite du projet
- Preferences utilisateur·ice
- Decisions techniques (tableau avec date, decision, raison)
- Historique des evolutions
- Lecons apprises
- Contexte en cours
- Agents disponibles

### Phase 10 : creation des skills obligatoires

Skills a creer obligatoirement :
- `inclusivity-reviewer` : ecriture inclusive, langage non capacitiste, terminologie moderne
- `memory-keeper` : gestion de la memoire persistante
- `workflow-orchestrator` : orchestration automatique des agents
- `translator` : traduction EN-FR, synchronisation docs, commentaires bilingues

Plus les skills extraits des fichiers legacy.

### Phase 11 : creation du script generate.sh

Script bash idempotent qui :
1. Verifie VERSION (ne regenere que si changee, sauf `--force`)
2. Parse `.ai/skills/*.yaml`
3. Genere pour chaque plateforme :
   - AGENTS.md (a la racine), CLAUDE.md
   - .claude/agents/*.md, .opencode/agent/*.md
   - ollama/Modelfile.*, ollama/create-all.sh
   - .continuerc.json, .aider.conf.yml, .cursorrules
   - .codex/agents/*.md

### Phase 12 : execution et validation

```bash
chmod +x .ai/generate.sh
.ai/generate.sh --force
```

Checklist de validation :
- [ ] generate.sh s'execute sans erreur
- [ ] AGENTS.md contient toutes les regles (y compris celles de l'ancien RULES.md)
- [ ] Les skills extraits sont complets
- [ ] Documentation bilingue avec liens croises
- [ ] translator --check-sync passe
- [ ] Les tests existants passent toujours
- [ ] Le projet fonctionne normalement

### Phase 13 : documentation de la migration

Mettre a jour README.md et README.fr.md avec section "Architecture IA".

### Phase 14 : finalisation

1. Verifier que le projet fonctionne (build, tests)
2. Mettre a jour MEMORY.md avec les decisions prises
3. Resumer ce qui a ete migre
4. Lister les prochaines etapes recommandees

## Contraintes

- Ne jamais modifier sans avoir d'abord fait le backup (Phase 4)
- Ne jamais supprimer les fichiers legacy (garder dans .ai/legacy-backup/)
- Toujours poser les questions de la Phase 2
- Fusionner RULES.md existant dans AGENTS.md (pas de fichier RULES.md separe)
- Inclure obligatoirement MEMORY.md et les skills de memoire/orchestration/traduction
- Utiliser l'ecriture inclusive dans tous les fichiers FR
- Documentation toujours bilingue avec liens croises

## Format de sortie

A la fin, fournir :

1. **Resume** de ce qui a ete migre
2. **Liste des fichiers** crees/modifies
3. **Differences** avec la configuration legacy
4. **Prochaines etapes** recommandees
5. **MEMORY.md** mis a jour avec les decisions prises

## Prompts lies

- [hybrid-ai-bootstrap](../hybrid-ai-bootstrap/hybrid-ai-bootstrap.md) : pour les nouveaux projets

---

<!--
HISTORIQUE DES VERSIONS :
- v2.1.0 (2026-01-31) : Harmonisation avec hybrid-ai-bootstrap, ajout MEMORY.md, regles 12-14, suppression RULES.md (fusionne dans AGENTS.md), paradigmes, traduction
- v1.0.0 (2026-01-31) : Version initiale
-->
