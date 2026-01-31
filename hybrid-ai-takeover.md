---
name: "hybrid-ai-takeover"
version: "2.1.0"
category: "meta"
description: "Prompt de reprise d'un projet existant vers architecture IA hybride multi-plateforme"

tags: ["takeover", "migration", "architecture", "multi-platform", "meta-prompt"]
author: "Meta-prompt-LLM"
created: "2026-01-31"
updated: "2026-01-31"

model_hints:
  recommended: ["claude-sonnet", "claude-opus", "gpt-4"]
  min_context: 16384
  temperature: 0.3
---

# Reprise de projet vers architecture IA hybride

Prompt de démarrage pour migrer un projet existant vers une architecture IA hybride (cloud + local), incluant mémoire persistante et orchestration automatique des agents.

## Contexte

Tu reprends un projet existant et tu dois le migrer vers une architecture IA hybride comprenant :
- Une source unique pour les définitions d'agents (`.ai/skills/*.yaml`)
- Un script qui génère les fichiers pour chaque plateforme (Claude Code, Ollama, Cursor, etc.)
- Des règles fondamentales que tous les agents doivent respecter
- Une mémoire persistante pour le contexte entre sessions
- Un orchestrateur de workflow pour l'automatisation

**Pourquoi cette migration** : les projets accumulent souvent des fichiers de configuration IA disparates (CLAUDE.md, .cursorrules, Modelfile, etc.) qui se désynchronisent. Cette architecture centralise tout et génère automatiquement les formats spécifiques.

## Instructions

### Phase 1 : recherche préalable

**Avant de faire quoi que ce soit** :

1. Consulte la documentation officielle de :
   - AGENTS.md (https://agents.md/) - standard universel
   - MCP (https://modelcontextprotocol.io/) - protocole de connexion
   - Claude Code subagents, Ollama Modelfile, Continue.dev, Aider, Cursor, OpenCode, Codex

2. Recherche les bonnes pratiques actuelles pour :
   - Migration de configurations IA existantes
   - Structure de fichiers YAML pour agents IA
   - Écriture inclusive en français
   - Mémoire persistante pour agents IA

3. Vérifie s'il existe un consensus sur ce type de migration

### Phase 2 : découverte du projet

Explore le projet et réponds à ces questions :

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

# Structure générale
ls -la
```

Pose ces questions à l'utilisateur·ice :

1. **Historique** : depuis combien de temps ce projet existe-t-il ? Décisions importantes passées ?
2. **Stack technique** : confirmer langages, frameworks, bases de données détectés
3. **Environnement** : cloud, local, hybride, air-gapped ?
4. **Outils IA utilisés** : lesquels actuellement ? lesquels souhaités ?
5. **Paradigme actuel** : comment le développement est-il organisé actuellement ?
6. **Paradigme souhaité** : (expliquer les options si besoin)

### Aide au choix du paradigme

| Contexte | Paradigme recommandé | Pourquoi |
|----------|---------------------|----------|
| Prototype rapide, exploration, POC | **Vibe coding** | Itération rapide, feedback immédiat |
| Production, équipe, maintenabilité | **Spec-driven** (Kiro-style) | Spécifications avant code, traçabilité |
| Projet complexe, multi-agents, évolutif | **BMAD** | Personas, orchestration, documentation riche |
| Refactoring, dette technique | **TDD strict** | Tests d'abord, non-régression |
| Documentation/contenu | **Doc-driven** | Documentation comme source de vérité |

**Recherche préalable** : avant de recommander, consulte :
- BMAD : https://github.com/bmad-code-org/BMAD-METHOD
- Kiro (spec-driven) : https://kiro.dev/

### Phase 3 : rapport d'analyse

Génère un rapport structuré :

```markdown
## Rapport d'analyse - [Nom du projet]

### Fichiers IA existants
| Fichier | Présent | Contenu principal |
|---------|---------|-------------------|
| CLAUDE.md | ✅/❌ | [résumé] |
| AGENTS.md | ✅/❌ | [résumé] |
| RULES.md | ✅/❌ | [résumé] |
| .cursorrules | ✅/❌ | [résumé] |
| Modelfile | ✅/❌ | [résumé] |
| .aider.conf.yml | ✅/❌ | [résumé] |
| .continuerc.json | ✅/❌ | [résumé] |

### Documentation existante
| Élément | Présent | Langue(s) |
|---------|---------|-----------|
| README.md | ✅/❌ | EN/FR |
| docs/ | ✅/❌ | structure |

### Stack détectée
- Langages : ...
- Frameworks : ...
- Tests : ...

### Conventions existantes identifiées
- ...

### Conflits potentiels
- ...

### Paradigme actuel détecté
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

### Phase 5 : création de l'architecture centralisée

Crée la structure `.ai/` :

```
.ai/
├── skills/                     # source unique (YAML)
│   ├── _TEMPLATE.yaml
│   └── [skills extraits et nouveaux].yaml
├── commands/
│   └── quick-reference.md
├── plans/
├── legacy-backup/              # fichiers originaux (créé en phase 4)
├── MEMORY.md                   # mémoire persistante (pré-remplie)
├── sources.yaml
├── VERSION                     # 1.0.0
├── README.md
└── generate.sh

# À la racine (standard AGENTS.md)
AGENTS.md                       # règles fondamentales (fusionne tout)
CLAUDE.md                       # pointeur → AGENTS.md

# Documentation bilingue
docs/
├── en/                         # documentation principale (anglais)
└── fr/                         # traduction française (miroir)

README.md                       # anglais (principal)
README.fr.md                    # français (lien croisé)
```

### Phase 6 : extraction et fusion des contenus legacy

Pour chaque fichier legacy trouvé :

1. **Extrais les instructions** (personas, règles, conventions)
2. **Identifie les skills implicites** (rôles définis)
3. **Fusionne dans AGENTS.md** (règles) et `.ai/skills/*.yaml` (agents)
4. **Résous les conflits** (priorité au plus récent/détaillé)

**Important** : l'ancien RULES.md (s'il existe) doit être fusionné dans AGENTS.md à la racine.

Exemple de fusion :

```yaml
# .ai/skills/project-assistant.yaml
# Fusionné depuis : CLAUDE.md (backup), .cursorrules (backup)

name: "project-assistant"
version: "1.0.0"
description: "Assistant principal - fusionné depuis configs legacy"

persona: |
  [Contenu harmonisé depuis les fichiers legacy]

security:
  never:
    - [Règles extraites]
  always:
    - [Règles extraites]
  ask_before:
    - [Actions nécessitant confirmation]
```

### Phase 7 : migration de la documentation

1. **Si docs/ existe mais pas bilingue** :
   - Déplacer vers docs/en/ ou docs/fr/ selon la langue
   - Créer le miroir dans l'autre langue
   - Ajouter liens croisés

2. **Si README existe mais pas bilingue** :
   - README.md devient la version anglaise
   - Créer README.fr.md (traduction)
   - Ajouter liens croisés en haut :
     ```markdown
     <!-- README.md -->
     > 🇫🇷 [Version française](README.fr.md)
     
     <!-- README.fr.md -->
     > 🇬🇧 [English version](README.md)
     ```

3. **Si déjà bilingue** :
   - Vérifier la synchronisation
   - Ajouter liens croisés si absents

### Phase 8 : création de AGENTS.md

Crée AGENTS.md à la racine avec toutes les règles fusionnées :

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

### Phase 9 : création de MEMORY.md (pré-rempli)

Crée `.ai/MEMORY.md` avec l'historique du projet :

```markdown
# Mémoire du projet

> Dernière mise à jour : [DATE]
> Agent : memory-keeper

## Identité du projet

- **Nom** : [extrait du projet]
- **Description** : [extrait du README ou demandé]
- **Date de création originale** : [si connue]
- **Date de migration** : [DATE]

## Préférences utilisateur·ice

- **Langue principale** : [EN/FR]
- **Paradigme** : [choisi en phase 2]
- **Outils IA** : [listés]

## Décisions techniques

| Date | Décision | Raison | Décideur |
|------|----------|--------|----------|
| [DATE] | Migration vers architecture IA hybride | Centralisation, éviter duplication | [user] |
| [anciennes décisions si connues] | | | |

## Historique des évolutions

- **[DATE]** : migration vers architecture IA hybride v2.1.0
- [historique existant si trouvé]

## Leçons apprises

- [À remplir au fil du projet]

## Contexte en cours

- **Tâche actuelle** : migration initiale
- **État** : en cours

## Agents disponibles

| Agent | Description | Statut |
|-------|-------------|--------|
| inclusivity-reviewer | Écriture inclusive, accessibilité | ✅ |
| memory-keeper | Gestion mémoire persistante | ✅ |
| workflow-orchestrator | Orchestration agents | ✅ |
| translator | Traduction EN↔FR | ✅ |
| [skills migrés] | | |
```

### Phase 10 : création des skills obligatoires

Skills à créer obligatoirement :
- `inclusivity-reviewer` : écriture inclusive, langage non capacitiste, terminologie moderne
- `memory-keeper` : gestion de la mémoire persistante
- `workflow-orchestrator` : orchestration automatique des agents
- `translator` : traduction EN↔FR, synchronisation docs, commentaires bilingues

Plus les skills extraits des fichiers legacy.

### Phase 11 : création du script generate.sh

Script bash idempotent qui :
1. Vérifie VERSION (ne régénère que si changée, sauf `--force`)
2. Parse `.ai/skills/*.yaml`
3. Génère pour chaque plateforme :
   - AGENTS.md (à la racine), CLAUDE.md
   - .claude/agents/*.md, .opencode/agent/*.md
   - ollama/Modelfile.*, ollama/create-all.sh
   - .continuerc.json, .aider.conf.yml, .cursorrules
   - .codex/agents/*.md

### Phase 12 : exécution et validation

```bash
chmod +x .ai/generate.sh
.ai/generate.sh --force
```

Checklist de validation :
- [ ] generate.sh s'exécute sans erreur
- [ ] AGENTS.md contient toutes les règles (y compris celles de l'ancien RULES.md)
- [ ] Les skills extraits sont complets
- [ ] Documentation bilingue avec liens croisés
- [ ] translator --check-sync passe
- [ ] Les tests existants passent toujours
- [ ] Le projet fonctionne normalement

### Phase 13 : documentation de la migration

Mettre à jour README.md et README.fr.md :

```markdown
## Architecture IA

Ce projet utilise une architecture IA centralisée.

### Source unique
Toutes les définitions d'agents : `.ai/skills/*.yaml`

### Régénération
```bash
.ai/generate.sh
```

### Migration
Migré le [DATE] depuis :
- [Liste des fichiers legacy]
Backups conservés dans `.ai/legacy-backup/`
```

### Phase 14 : finalisation

1. Vérifier que le projet fonctionne (build, tests)
2. Mettre à jour MEMORY.md avec les décisions prises
3. Résumer ce qui a été migré
4. Lister les prochaines étapes recommandées

## Contraintes

- Ne jamais modifier sans avoir d'abord fait le backup (Phase 4)
- Ne jamais supprimer les fichiers legacy (garder dans .ai/legacy-backup/)
- Toujours poser les questions de la Phase 2
- Fusionner RULES.md existant dans AGENTS.md (pas de fichier RULES.md séparé)
- Inclure obligatoirement MEMORY.md et les skills de mémoire/orchestration/traduction
- Utiliser l'écriture inclusive dans tous les fichiers FR
- Documentation toujours bilingue avec liens croisés

## Format de sortie

À la fin, fournir :
1. Résumé de ce qui a été migré
2. Liste des fichiers créés/modifiés
3. Différences avec la configuration legacy
4. Prochaines étapes recommandées
5. MEMORY.md mis à jour avec les décisions prises

---

<!--
HISTORIQUE DES VERSIONS :
- v2.1.0 (2026-01-31) : Harmonisation avec hybrid-ai-bootstrap, ajout MEMORY.md, règles 12-14, suppression RULES.md (fusionné dans AGENTS.md), paradigmes, traduction
- v1.0.0 (2026-01-31) : Version initiale
-->
