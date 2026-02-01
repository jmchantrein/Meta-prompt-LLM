# Système de vérification de version et mise à jour automatique

> **Statut** : BROUILLON - Mis à jour avec décisions
> **Version** : 0.2.0
> **Date** : 2026-02-01

## 1. Vue d'ensemble

### 1.1 Problématique

Quand un prompt de la collection Meta-prompt-LLM est copié et utilisé dans un autre projet :
- Il devient déconnecté de sa source
- Il ne peut pas accéder aux règles et skills associés
- Les utilisateur·ices ne sont pas informé·es des mises à jour

### 1.2 Objectifs

1. **Récupération déterministe** : Les prompts peuvent récupérer leurs règles/skills via URLs
2. **Suivi de version** : Chaque prompt a une version sémantique
3. **Auto-vérification** : Au démarrage de session, les prompts vérifient si des mises à jour sont disponibles
4. **Contrôle utilisateur·ice** : Les mises à jour sont proposées, jamais forcées

### 1.3 Principes

- **Non-intrusif** : L'utilisateur·ice décide de mettre à jour ou non
- **Transparent** : Le changelog explique ce qui a changé
- **Déterministe** : Numéros de version, pas d'ambiguïté
- **Autonome** : Les prompts savent se vérifier eux-mêmes

## 2. Architecture

### 2.1 Actuelle vs proposée

```
ACTUELLE :
.ai/skills/*.yaml  ──► generate.sh ──► AGENTS.md
                                         │
prompts/**/*.md ◄────────────────────────┘ (sync manuel)

PROPOSÉE :
data/
├── manifest.yaml        ──► GitHub raw URL ──► LLM récupère
├── rules/
├── skills/
└── prompts/

prompts/**/*.md
└── bloc <!-- META -->   ──► Contient URLs + version
         │
         └──► Au démarrage : fetch manifest, compare versions
```

### 2.2 Flux de données

```
┌─────────────────────────────────────────────────────────────────┐
│                        Repo Meta-prompt-LLM                     │
├─────────────────────────────────────────────────────────────────┤
│  data/manifest.yaml ◄──────────────────────────────┐            │
│       │                                            │            │
│       ▼                                            │            │
│  GitHub raw URL                                    │            │
│  https://raw.githubusercontent.com/.../manifest.yaml            │
└───────────────────────────────┬─────────────────────────────────┘
                                │
                                ▼
┌─────────────────────────────────────────────────────────────────┐
│                     Projet utilisateur·ice (ailleurs)           │
├─────────────────────────────────────────────────────────────────┤
│  prompt-copie.md                                                │
│  ├── <!-- META                                                  │
│  │   prompt_id: "hybrid-ai-bootstrap"                           │
│  │   version: "1.1.0"                                           │
│  │   manifest_url: "https://raw.githubusercontent.com/..."      │
│  │   -->                                                        │
│  │                                                              │
│  └── LLM lit META ──► fetch manifest ──► compare versions       │
│                                │                                │
│                                ▼                                │
│                    "Mise à jour disponible : 1.1.0 → 1.2.0"     │
│                    [Mettre à jour] [Ignorer] [Détails]          │
└─────────────────────────────────────────────────────────────────┘
```

## 3. Structures de données

### 3.1 Manifest (`data/manifest.yaml`)

L'index central servi via GitHub raw URL.

```yaml
# Manifest Meta-prompt-LLM
# Source de vérité pour versions et URLs

schema_version: "1.0.0"
last_updated: "2026-02-01T12:00:00Z"
repository: "https://github.com/jmchantrein/Meta-prompt-LLM"

base_urls:
  raw: "https://raw.githubusercontent.com/jmchantrein/Meta-prompt-LLM/main"
  pages: "https://jmchantrein.github.io/Meta-prompt-LLM"

# Règles depuis AGENTS.md
rules:
  version: "1.0.0"
  source_url: "{base_urls.raw}/data/rules/rules.yaml"
  changelog_url: "{base_urls.raw}/data/rules/CHANGELOG.md"

# Définitions des skills
skills:
  version: "1.0.0"
  index_url: "{base_urls.raw}/data/skills/index.yaml"
  changelog_url: "{base_urls.raw}/data/skills/CHANGELOG.md"
  items:
    - id: "inclusivity-reviewer"
      version: "1.0.0"
      url: "{base_urls.raw}/data/skills/inclusivity-reviewer.yaml"
    - id: "prompt-validator"
      version: "1.0.0"
      url: "{base_urls.raw}/data/skills/prompt-validator.yaml"
    # ... autres skills

# Collection de prompts
prompts:
  index_url: "{base_urls.raw}/data/prompts/index.yaml"
  changelog_url: "{base_urls.raw}/data/prompts/CHANGELOG.md"
  items:
    - id: "hybrid-ai-bootstrap"
      version: "1.2.0"
      category: "metaprompts"
      language: "en"
      url: "{base_urls.raw}/prompts/en/metaprompts/hybrid-ai-bootstrap/hybrid-ai-bootstrap.md"
      applicable_rules: ["rule-0", "rule-1", "rule-2", "rule-4"]
      applicable_skills: ["prompt-validator"]
    # ... autres prompts
```

### 3.2 Bloc de métadonnées des prompts

Chaque prompt inclut un bloc `<!-- META -->` (commentaire HTML pour compatibilité).

```markdown
<!-- META
prompt_id: "hybrid-ai-bootstrap"
version: "1.2.0"
manifest_url: "https://raw.githubusercontent.com/jmchantrein/Meta-prompt-LLM/main/data/manifest.yaml"
source_url: "https://raw.githubusercontent.com/jmchantrein/Meta-prompt-LLM/main/prompts/en/metaprompts/hybrid-ai-bootstrap/hybrid-ai-bootstrap.md"
applicable_rules:
  - rule-0
  - rule-1
  - rule-2
  - rule-4
applicable_skills:
  - prompt-validator
last_updated: "2026-02-01"
-->

# Hybrid AI Bootstrap

[contenu du prompt...]
```

### 3.3 Données des règles (`data/rules/rules.yaml`)

```yaml
# Règles extraites de AGENTS.md pour accès distant

schema_version: "1.0.0"
source_file: "AGENTS.md"
version: "1.0.0"

rules:
  - id: "rule-0"
    name: "honesty"
    description: "Droit de ne pas savoir, de demander clarification"
    instruction: |
      - Ne jamais inventer de faits, ne jamais prétendre
      - Reconnaître l'incertitude quand elle est présente

  - id: "rule-1"
    name: "state of the art and consensus"
    description: "Consulter la documentation officielle avant d'agir"
    instruction: |
      - Chercher des solutions qui font consensus
      - Préférer les patterns établis aux approches nouvelles

  # ... autres règles
```

### 3.4 Format du changelog (`data/prompts/CHANGELOG.md`)

```markdown
# Changelog des prompts

## [1.2.0] - 2026-02-01

### hybrid-ai-bootstrap
- **Ajout** : Support mémoire persistante (rule-11)
- **Modification** : Section écriture inclusive mise à jour
- **Correction** : Cas limite validation de schéma

### hybrid-ai-takeover
- **Ajout** : Instruction de vérification de version

## [1.1.0] - 2026-01-30

### hybrid-ai-bootstrap
- **Ajout** : Version initiale avec fonctionnalités de base
```

## 4. Mécanisme de vérification de version

### 4.1 Nouvelle règle : rule-13 (version check)

À ajouter dans AGENTS.md :

```markdown
## Rule 13: version check

Au démarrage de session, si ce prompt provient de Meta-prompt-LLM :

1. Lire le bloc `<!-- META -->`
2. Extraire `manifest_url` et `version`
3. Récupérer le manifest (si accès web disponible)
4. Comparer version locale avec version distante
5. Si différente :
   - Informer l'utilisateur·ice
   - Afficher le résumé du changelog
   - Proposer : [Mettre à jour] [Ignorer] [Voir détails]
6. Si identique ou pas d'accès web :
   - Continuer normalement
```

### 4.2 Algorithme de vérification (pseudocode)

```
function checkVersion():
    meta = parseMetaBlock(prompt)
    if meta is null:
        return  // Pas un prompt Meta-prompt-LLM

    try:
        manifest = fetch(meta.manifest_url)
    catch NetworkError:
        log("Vérification version ignorée : pas d'accès réseau")
        return

    remote_prompt = manifest.prompts.find(id == meta.prompt_id)
    if remote_prompt is null:
        warn("Prompt non trouvé dans le manifest")
        return

    if semver.gt(remote_prompt.version, meta.version):
        displayUpdateNotification(
            local: meta.version,
            remote: remote_prompt.version,
            changelog: fetch(manifest.prompts.changelog_url)
        )
```

### 4.3 Flux d'interaction utilisateur·ice

```
┌────────────────────────────────────────────────────────────┐
│  🔄 Vérification de version...                             │
├────────────────────────────────────────────────────────────┤
│                                                            │
│  ⚠️  Mise à jour disponible !                              │
│                                                            │
│  Prompt : hybrid-ai-bootstrap                              │
│  Version locale :  1.1.0                                   │
│  Version distante : 1.2.0                                  │
│                                                            │
│  Changements en 1.2.0 :                                    │
│  • Ajout : Support mémoire persistante (rule-11)           │
│  • Modification : Section écriture inclusive mise à jour   │
│  • Correction : Cas limite validation de schéma            │
│                                                            │
│  ┌───────────────┐  ┌──────────┐  ┌──────────────┐         │
│  │ Mettre à jour │  │  Ignorer │  │ Voir détails │         │
│  └───────────────┘  └──────────┘  └──────────────┘         │
│                                                            │
└────────────────────────────────────────────────────────────┘
```

## 5. Workflow de mise à jour

### 5.1 Options de mise à jour

| Option | Action |
|--------|--------|
| **Mettre à jour** | Récupérer nouvelle version, afficher diff, remplacer contenu |
| **Ignorer** | Passer cette version (optionnellement mémoriser le choix) |
| **Voir détails** | Afficher changelog complet et diff |

### 5.2 Processus de mise à jour

1. Récupérer le nouveau contenu du prompt depuis `source_url`
2. Afficher le diff entre local et distant
3. L'utilisateur·ice confirme le remplacement
4. Mettre à jour le bloc `<!-- META -->` avec la nouvelle version
5. Logger la mise à jour dans la session

### 5.3 Mises à jour partielles

Pour les prompts avec modifications locales :

```
⚠️  Votre prompt a des modifications locales.

Options :
1. [Tout remplacer] - Écraser avec nouvelle version (perte des changements locaux)
2. [Voir diff]      - Comparer local vs distant
3. [Fusionner]      - Tenter fusion automatique (peut nécessiter résolution manuelle)
4. [Garder local]   - Garder votre version, mettre à jour META uniquement
```

## 6. Structure des répertoires

### 6.1 Nouvelle structure `data/`

```
data/
├── manifest.yaml              # Index central
├── rules/
│   ├── rules.yaml            # Toutes les règles en YAML
│   ├── CHANGELOG.md          # Changelog des règles
│   └── schema.json           # Schéma de validation (optionnel)
├── skills/
│   ├── index.yaml            # Index des skills
│   ├── CHANGELOG.md          # Changelog des skills
│   ├── inclusivity-reviewer.yaml
│   ├── prompt-validator.yaml
│   └── ... (autres skills)
└── prompts/
    ├── index.yaml            # Index des prompts avec versions
    └── CHANGELOG.md          # Changelog des prompts
```

### 6.2 Relation avec la structure existante

| Existant | Nouveau (data/) | Relation |
|----------|-----------------|----------|
| `AGENTS.md` | `data/rules/rules.yaml` | Règles extraites en YAML |
| `.ai/skills/*.yaml` | `data/skills/*.yaml` | Copie ou symlink |
| `prompts/**/*.md` | `data/prompts/index.yaml` | Index seulement, prompts restent en place |

### 6.3 Flux de génération

```
data/rules/rules.yaml  ─────┐
                            ├──► generate.sh ──► AGENTS.md
data/skills/*.yaml     ─────┘

data/prompts/index.yaml ◄─── generate.sh lit prompts/**/*.md
```

## 7. Schéma d'URLs

### 7.1 URLs de base

| Type | Pattern d'URL |
|------|---------------|
| Contenu raw | `https://raw.githubusercontent.com/jmchantrein/Meta-prompt-LLM/main/...` |
| GitHub Pages | `https://jmchantrein.github.io/Meta-prompt-LLM/...` |

### 7.2 Recommandé : URLs raw

Les URLs raw sont préférées car :
- Accès direct au contenu (pas de wrapper HTML)
- Toujours synchronisé avec le dépôt
- Pas de configuration GitHub Pages requise
- Plus facile à parser pour les LLMs

### 7.3 Exemples d'URLs

```
# Manifest
https://raw.githubusercontent.com/jmchantrein/Meta-prompt-LLM/main/data/manifest.yaml

# Règles
https://raw.githubusercontent.com/jmchantrein/Meta-prompt-LLM/main/data/rules/rules.yaml

# Skill spécifique
https://raw.githubusercontent.com/jmchantrein/Meta-prompt-LLM/main/data/skills/inclusivity-reviewer.yaml

# Prompt spécifique
https://raw.githubusercontent.com/jmchantrein/Meta-prompt-LLM/main/prompts/en/metaprompts/hybrid-ai-bootstrap/hybrid-ai-bootstrap.md
```

## 8. Rétrocompatibilité

### 8.1 Prompts sans bloc META

- Continuent à fonctionner normalement
- Pas de vérification de version effectuée
- Pas de notifications de mise à jour

### 8.2 Chemin de migration

1. Ajouter le bloc `<!-- META -->` aux prompts existants
2. Initialiser toutes les versions à `1.0.0`
3. Incrémenter lors des changements suivants

### 8.3 Dégradation gracieuse

| Scénario | Comportement |
|----------|--------------|
| Pas de bloc META | Exécution normale, pas de vérification |
| Pas d'accès réseau | Message de log, continuer normalement |
| Manifest indisponible | Avertissement, continuer normalement |
| Version invalide | Avertissement, continuer normalement |

## 9. Considérations de sécurité

### 9.1 Validation des URLs

- N'accepter que les URLs de domaines connus (github.com, githubusercontent.com)
- Valider le format de l'URL avant de récupérer
- Timeout sur les réponses lentes

### 9.2 Validation du contenu

- Vérifier la structure YAML/Markdown
- Rejeter le contenu malformé
- Limites de taille sur le contenu récupéré

### 9.3 Consentement utilisateur·ice

- Ne jamais mettre à jour automatiquement sans confirmation
- Afficher le diff complet avant remplacement
- Option d'ignorer des versions spécifiques

## 10. Checklist d'implémentation (ancienne)

- [ ] Créer la structure du répertoire `data/`
- [ ] Créer `data/manifest.yaml`
- [ ] Créer `data/rules/rules.yaml` depuis AGENTS.md
- [ ] Copier/adapter les skills dans `data/skills/`
- [ ] Créer `data/prompts/index.yaml`
- [ ] Ajouter rule-13 à AGENTS.md
- [ ] Mettre à jour `generate.sh` pour maintenir la sync data/
- [ ] Ajouter `<!-- META -->` au template de prompt
- [ ] Injecter les blocs META dans les prompts existants
- [ ] Créer les CHANGELOGs
- [ ] Mettre à jour README.md avec la nouvelle architecture
- [ ] Mettre à jour README.fr.md (traduction)
- [ ] Tester la vérification de version avec un prompt exemple

## 11. Décisions de conception

| Question | Décision | Justification |
|----------|----------|---------------|
| Stratégie de branches | `main` uniquement | Simplicité, source unique de vérité |
| Durée du cache | 1 jour | Équilibre entre fraîcheur et performance |
| Fréquence de vérification | Chaque session | S'assurer que les utilisateur·ices sont toujours informé·es |
| Copie des skills | Duplication + agent de sync | data/ est la source de vérité, sync vers .ai/skills/ |

## 12. Agent data-sync

### 12.1 Objectif

Nouvel agent responsable de :
1. Synchroniser `data/` → `.ai/skills/`, `AGENTS.md`, etc.
2. Au démarrage de session : vérifier l'intégrité des hash
3. Si hash différent : recalculer le hash, incrémenter la version

### 12.2 Spécification de l'agent

```yaml
name: "data-sync"
version: "1.0.0"
description: "Synchronise data/ vers les fichiers projet et valide l'intégrité"
category: "core"

triggers:
  automatic: true  # S'exécute au démarrage de session
  patterns:
    - "data/**/*.yaml"
    - "data/**/*.md"
  commands:
    - "/data-sync"
    - "/sync"
    - "/integrity-check"

context:
  files:
    - "data/manifest.yaml"
    - "data/rules/rules.yaml"
    - "data/skills/*.yaml"
    - "data/prompts/index.yaml"
  outputs:
    - ".ai/skills/*.yaml"
    - "AGENTS.md"
    - "prompts/**/*.md"  # Blocs META

instructions:
  role: |
    Tu es l'agent responsable de la synchronisation des données
    et de l'intégrité du projet Meta-prompt-LLM.

    ## Source de vérité

    `data/` est la source unique de vérité pour :
    - Règles (data/rules/rules.yaml)
    - Skills (data/skills/*.yaml)
    - Index des prompts (data/prompts/index.yaml)

    ## Fichiers générés (outputs)

    - `.ai/skills/*.yaml` : Copie depuis data/skills/
    - `AGENTS.md` : Généré depuis data/rules/ et data/skills/
    - `prompts/**/*.md` : Bloc META injecté/mis à jour

  process: |
    ## Processus au début de session

    ### 1. Vérification d'intégrité

    Pour chaque fichier dans data/ :
    ```
    current_hash = sha256(file_content)
    stored_hash = manifest.items[file_id].hash

    if current_hash != stored_hash:
        # Fichier modifié manuellement
        report_change(file_id, stored_hash, current_hash)
    ```

    ### 2. Si changements détectés

    ```
    🔄 Changements détectés dans data/

    | Fichier | Action requise |
    |---------|----------------|
    | data/skills/new-skill.yaml | Nouveau fichier |
    | data/rules/rules.yaml | Hash modifié |

    Actions proposées :
    1. Recalculer les hash dans manifest.yaml
    2. Incrémenter les versions concernées
    3. Synchroniser vers .ai/skills/ et AGENTS.md
    4. Mettre à jour les blocs META des prompts

    Procéder ? [Oui / Non / Détails]
    ```

    ### 3. Synchronisation (si validé)

    1. **Skills** : data/skills/*.yaml → .ai/skills/*.yaml
    2. **Rules** : data/rules/rules.yaml → AGENTS.md (via generate.sh)
    3. **Prompts** : Mettre à jour les blocs META avec nouvelles versions
    4. **Manifest** : Mettre à jour hash et timestamps

    ### 4. Versioning automatique

    Règles de bump de version :
    - Nouveau fichier : 1.0.0
    - Hash changé (contenu modifié) : bump patch (1.0.0 → 1.0.1)
    - Structure changée : bump minor (1.0.0 → 1.1.0)
    - Breaking change : bump major (1.0.0 → 2.0.0, manuel)

  output_format: |
    ## Rapport de synchronisation

    ```
    ✅ Synchronisation data-sync terminée

    ### Fichiers vérifiés
    - data/rules/rules.yaml: ✅ Intègre
    - data/skills/inclusivity-reviewer.yaml: ⚠️ Modifié
    - data/skills/new-skill.yaml: 🆕 Nouveau

    ### Actions effectuées
    - [x] Hash recalculé pour inclusivity-reviewer
    - [x] Version bump: 1.0.0 → 1.0.1
    - [x] Copié vers .ai/skills/inclusivity-reviewer.yaml
    - [x] new-skill.yaml ajouté (v1.0.0)
    - [x] AGENTS.md régénéré
    - [x] manifest.yaml mis à jour

    ### Commit suggéré
    feat(data): sync data changes to project

    @future-self: data-sync completed, all hashes verified.
    ```

constraints:
  must:
    - "TOUJOURS vérifier l'intégrité avant synchronisation"
    - "TOUJOURS proposer avant de synchroniser"
    - "TOUJOURS mettre à jour le manifest après modification"
    - "TOUJOURS utiliser le versioning sémantique"
  must_not:
    - "JAMAIS modifier data/ sans validation utilisateur·ice"
    - "JAMAIS écraser des modifications locales sans confirmation"
    - "JAMAIS synchroniser si les hash ne sont pas vérifiés"
```

### 12.3 Flux de vérification d'intégrité

```
┌─────────────────────────────────────────────────────────────┐
│                    Démarrage de session                     │
└─────────────────────────────┬───────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│  data-sync: Lire manifest.yaml                              │
│  Extraire les hash stockés pour tous les fichiers           │
└─────────────────────────────┬───────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│  Pour chaque fichier dans data/ :                           │
│    current_hash = sha256(file)                              │
│    if current_hash != stored_hash:                          │
│      marquer comme MODIFIÉ                                  │
└─────────────────────────────┬───────────────────────────────┘
                              │
              ┌───────────────┴───────────────┐
              │                               │
              ▼                               ▼
┌─────────────────────────┐     ┌─────────────────────────────┐
│  Aucun changement       │     │  Changements détectés       │
│  ✅ Continuer           │     │  Proposer actions sync      │
└─────────────────────────┘     └──────────────┬──────────────┘
                                               │
                                               ▼
                                ┌─────────────────────────────┐
                                │  Utilisateur·ice valide ?   │
                                │  [Oui] → Exécuter sync      │
                                │  [Non] → Ignorer, avertir   │
                                └─────────────────────────────┘
```

### 12.4 Manifest avec hash

Structure du manifest mise à jour pour inclure les hash de contenu :

```yaml
# data/manifest.yaml

schema_version: "1.0.0"
last_updated: "2026-02-01T12:00:00Z"
last_sync: "2026-02-01T12:00:00Z"

# Hash d'intégrité pour tous les fichiers data
integrity:
  "data/rules/rules.yaml":
    hash: "sha256:abc123..."
    version: "1.0.0"
    last_modified: "2026-02-01T12:00:00Z"

  "data/skills/inclusivity-reviewer.yaml":
    hash: "sha256:def456..."
    version: "1.0.0"
    last_modified: "2026-02-01T12:00:00Z"

  "data/skills/prompt-validator.yaml":
    hash: "sha256:ghi789..."
    version: "1.0.0"
    last_modified: "2026-02-01T12:00:00Z"

# ... reste du manifest (sections rules, skills, prompts)
```

## 13. Architecture mise à jour

### 13.1 Flux de données complet

```
┌─────────────────────────────────────────────────────────────────────┐
│                         data/ (Source de vérité)                    │
├─────────────────────────────────────────────────────────────────────┤
│  manifest.yaml ◄─── Contient hash + versions                       │
│  rules/rules.yaml                                                   │
│  skills/*.yaml                                                      │
│  prompts/index.yaml                                                 │
└───────────────────────────────┬─────────────────────────────────────┘
                                │
                                │ agent data-sync
                                │ (vérifie hash, synchronise)
                                │
        ┌───────────────────────┼───────────────────────┐
        │                       │                       │
        ▼                       ▼                       ▼
┌───────────────┐     ┌─────────────────┐     ┌─────────────────────┐
│ .ai/skills/   │     │   AGENTS.md     │     │  prompts/**/*.md    │
│ *.yaml        │     │   (généré)      │     │  (blocs META)       │
│ (copies)      │     │                 │     │                     │
└───────────────┘     └─────────────────┘     └─────────────────────┘
                                │
                                │ GitHub raw URL
                                │
                                ▼
                    ┌───────────────────────┐
                    │  LLM externe          │
                    │  Récupère manifest    │
                    │  Vérifie versions     │
                    └───────────────────────┘
```

### 13.2 Responsabilités des agents

| Agent | Responsabilité |
|-------|----------------|
| **data-sync** | Vérification d'intégrité, sync data/ → outputs |
| **self-improver** | Détecter changements règles/skills, proposer propagation |
| **generate.sh** | Générer AGENTS.md depuis data/ |

### 13.3 Séquence de démarrage de session

```
1. memory-keeper --load     # Charger le contexte
2. data-sync --check        # Vérifier intégrité, sync si nécessaire
3. self-improver --check    # Vérifier propagation règles/skills
4. [session normale]
```

## 14. Checklist d'implémentation mise à jour

- [ ] Créer la structure du répertoire `data/`
- [ ] Créer `data/manifest.yaml` avec hash d'intégrité
- [ ] Créer `data/rules/rules.yaml` depuis AGENTS.md
- [ ] Copier les skills dans `data/skills/`
- [ ] Créer `data/prompts/index.yaml`
- [ ] **Créer le skill `data-sync` dans `.ai/skills/data-sync.yaml`**
- [ ] **Mettre à jour `workflow-orchestrator` pour inclure data-sync**
- [ ] Ajouter rule-13 à AGENTS.md (version check)
- [ ] Mettre à jour `generate.sh` pour lire depuis data/
- [ ] Ajouter `<!-- META -->` au template de prompt
- [ ] Injecter les blocs META dans les prompts existants
- [ ] Créer les CHANGELOGs
- [ ] Mettre à jour README.md avec la nouvelle architecture
- [ ] Mettre à jour README.fr.md (traduction)
- [ ] Tester la vérification d'intégrité avec un fichier modifié
- [ ] Tester la vérification de version avec un prompt exemple

---

*Version du document : 0.2.0 - Mis à jour avec décisions de conception et agent data-sync*
