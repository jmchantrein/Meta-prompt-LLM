# Système de vérification de version et mise à jour automatique

> **Statut** : BROUILLON - Mis à jour avec retours utilisateur·ice
> **Version** : 0.3.0
> **Date** : 2026-02-01

## 1. Vue d'ensemble

### 1.1 Problématique

Quand un prompt de la collection Meta-prompt-LLM est copié et utilisé ailleurs :
- Il devient déconnecté de sa source
- Il ne peut pas accéder aux règles et skills associés
- Les utilisateur·ices ne sont pas informé·es des mises à jour

### 1.2 Objectifs

1. **Récupération déterministe** : Les prompts peuvent récupérer leurs règles/skills via URLs
2. **Suivi de version** : Chaque prompt a une version sémantique
3. **Auto-vérification** : Au démarrage, les prompts vérifient si des mises à jour existent
4. **Contrôle utilisateur·ice** : Les mises à jour sont proposées, jamais forcées
5. **Copier-coller friendly** : Mini-prompts pour adoption facile dans les prompts déployés

### 1.3 Principes

- **KISS** : Garder simple, éviter la sur-ingénierie
- **Non-intrusif** : L'utilisateur·ice décide de mettre à jour ou non
- **Transparent** : Le changelog explique ce qui a changé
- **Déterministe** : Numéros de version, pas d'ambiguïté
- **Le projet valide** : La validation est faite avant distribution, pas par les LLMs consommateurs

## 2. Architecture

### 2.1 Source de vérité

Toutes les données vivent dans `data/` au sein du dossier metametaprompts :

```
prompts/fr/metametaprompts/data/    # Source de vérité
├── manifest.yaml                   # Index central + versions + hash
├── rules/
│   ├── rules.yaml                 # Toutes les règles
│   └── CHANGELOG.md
├── skills/
│   ├── *.yaml                     # Tous les skills
│   └── CHANGELOG.md
└── prompts/
    ├── en/                        # Prompts anglais
    │   └── *.md
    ├── fr/                        # Prompts français
    │   └── *.md
    └── CHANGELOG.md
```

### 2.2 Flux de données

```
┌─────────────────────────────────────────────────────────────────┐
│                  data/ (Source de vérité)                       │
├─────────────────────────────────────────────────────────────────┤
│  manifest.yaml                                                  │
│  rules/*.yaml                                                   │
│  skills/*.yaml                                                  │
│  prompts/**/*.md  ◄── Les prompts vivent ici directement       │
└───────────────────────────────┬─────────────────────────────────┘
                                │
                                │ agent data-sync
                                │
        ┌───────────────────────┼───────────────────────┐
        │                       │                       │
        ▼                       ▼                       ▼
┌───────────────┐     ┌─────────────────┐     ┌─────────────────┐
│ .ai/skills/   │     │   AGENTS.md     │     │   CLAUDE.md     │
│ (copies)      │     │   (généré)      │     │   (généré)      │
└───────────────┘     └─────────────────┘     └─────────────────┘
                                │
                                │ GitHub raw URL (dépôt officiel uniquement)
                                │
                                ▼
                    ┌───────────────────────┐
                    │  LLM externe          │
                    │  Récupère & utilise   │
                    └───────────────────────┘
```

## 3. Schéma d'URLs

### 3.1 Dépôt officiel uniquement

Tous les fetches sont restreints au dépôt officiel :

```
https://raw.githubusercontent.com/jmchantrein/Meta-prompt-LLM/main/...
```

Aucun autre domaine n'est autorisé.

### 3.2 Exemples d'URLs

```
# Manifest
https://raw.githubusercontent.com/jmchantrein/Meta-prompt-LLM/main/prompts/fr/metametaprompts/data/manifest.yaml

# Règles
https://raw.githubusercontent.com/jmchantrein/Meta-prompt-LLM/main/prompts/fr/metametaprompts/data/rules/rules.yaml

# Skill
https://raw.githubusercontent.com/jmchantrein/Meta-prompt-LLM/main/prompts/fr/metametaprompts/data/skills/inclusivity-reviewer.yaml

# Prompt
https://raw.githubusercontent.com/jmchantrein/Meta-prompt-LLM/main/prompts/fr/metametaprompts/data/prompts/en/hybrid-ai-bootstrap.md
```

## 4. Structures de données

### 4.1 Manifest (`data/manifest.yaml`)

```yaml
# Manifest Meta-prompt-LLM
schema_version: "1.0.0"
last_updated: "2026-02-01T12:00:00Z"
repository: "https://github.com/jmchantrein/Meta-prompt-LLM"

base_url: "https://raw.githubusercontent.com/jmchantrein/Meta-prompt-LLM/main/prompts/fr/metametaprompts/data"

# Hash d'intégrité
integrity:
  "rules/rules.yaml":
    hash: "sha256:abc123..."
    version: "1.0.0"
  "skills/inclusivity-reviewer.yaml":
    hash: "sha256:def456..."
    version: "1.0.0"
  "prompts/en/hybrid-ai-bootstrap.md":
    hash: "sha256:ghi789..."
    version: "1.2.0"

# Règles
rules:
  version: "1.0.0"
  url: "{base_url}/rules/rules.yaml"

# Skills
skills:
  version: "1.0.0"
  items:
    - id: "inclusivity-reviewer"
      version: "1.0.0"
      url: "{base_url}/skills/inclusivity-reviewer.yaml"

# Prompts
prompts:
  items:
    - id: "hybrid-ai-bootstrap"
      version: "1.2.0"
      language: "en"
      url: "{base_url}/prompts/en/hybrid-ai-bootstrap.md"
      applicable_rules: ["rule-0", "rule-1", "rule-4"]
      applicable_skills: ["prompt-validator"]
```

### 4.2 Bloc META des prompts

Chaque prompt inclut un bloc `<!-- META -->` avec :
- Info de version
- URL source
- **Mini-prompt de mise à jour** (copier-coller friendly)
- **One-liner pour utiliser ce prompt** (copier-coller friendly)

```markdown
<!-- META
prompt_id: "hybrid-ai-bootstrap"
version: "1.2.0"
source_url: "https://raw.githubusercontent.com/jmchantrein/Meta-prompt-LLM/main/prompts/fr/metametaprompts/data/prompts/en/hybrid-ai-bootstrap.md"
applicable_rules: ["rule-0", "rule-1", "rule-4"]
applicable_skills: ["prompt-validator"]
last_updated: "2026-02-01"

# --- PROMPTS À COPIER-COLLER ---

# One-liner : Utiliser ce prompt
use_prompt: "Récupère et applique le prompt depuis : https://raw.githubusercontent.com/jmchantrein/Meta-prompt-LLM/main/prompts/fr/metametaprompts/data/prompts/en/hybrid-ai-bootstrap.md"

# Mini-prompt : Vérifier les mises à jour
update_prompt: |
  Vérifie si mon prompt est à jour :
  - Ma version : 1.2.0
  - Source : https://raw.githubusercontent.com/jmchantrein/Meta-prompt-LLM/main/prompts/fr/metametaprompts/data/prompts/en/hybrid-ai-bootstrap.md
  Récupère la source, compare les versions dans le bloc META.
  Si une version plus récente existe, montre-moi ce qui a changé et demande si je veux mettre à jour.
-->

# Hybrid AI Bootstrap

[contenu du prompt...]
```

### 4.3 Scénarios d'utilisation

#### Scénario A : L'utilisateur·ice a un prompt avec bloc META

Le LLM lit META, récupère l'URL source, compare les versions, propose une mise à jour si nécessaire.

#### Scénario B : L'utilisateur·ice a un ancien prompt sans META

L'utilisateur·ice peut copier-coller le `update_prompt` d'une version plus récente pour activer les mises à jour.

#### Scénario C : L'utilisateur·ice veut utiliser un prompt from scratch

L'utilisateur·ice copie-colle le `use_prompt` one-liner dans son LLM.

## 5. Mécanisme de vérification de version

### 5.1 Rule-13 : version check

```markdown
## Rule 13: version check

Au démarrage de session, si ce prompt a un bloc META :

1. Lire `source_url` et `version` depuis META
2. Récupérer la source (si accès web disponible)
3. Comparer version locale avec version distante
4. Si distante plus récente :
   - Informer l'utilisateur·ice avec le diff de version
   - Afficher le résumé du changelog
   - Proposer : [Mettre à jour] [Ignorer]
5. Si identique ou pas d'accès web :
   - Continuer normalement
```

### 5.2 Flux de vérification simple

```
Démarrage Session
     │
     ▼
Lire bloc META ──► Pas de META ? ──► Continuer normalement
     │
     ▼
Récupérer source_url
     │
     ▼
Comparer versions
     │
     ├── Identique ──► Continuer normalement
     │
     └── Différente ──► Afficher notification de mise à jour
                            │
                            ▼
                    L'utilisateur·ice choisit [Mettre à jour/Ignorer]
```

## 6. Philosophie de validation

### 6.1 Le projet valide, pas les LLMs consommateurs

Les LLMs ne peuvent pas effectuer de manière fiable des tâches de validation déterministes :
- Validation de structure YAML
- Vérification de taille de prompt
- Vérification de format
- Conformité au schéma

**C'est la responsabilité du projet, pas celle des LLMs consommateurs.**

### 6.2 Validation pré-distribution

Avant qu'un prompt soit publié dans `data/` :

1. `prompt-validator` vérifie la structure et le schéma
2. `inclusivity-reviewer` vérifie le contenu français
3. `link-checker` valide les liens internes
4. Le hash et la version sont calculés
5. Le manifest est mis à jour

**Les LLMs consommateurs font confiance au contenu récupéré comme étant valide.**

## 7. Agent data-sync

### 7.1 Objectif

Synchronise `data/` vers les fichiers du projet :
- `data/skills/*.yaml` → `.ai/skills/*.yaml`
- `data/rules/rules.yaml` → `AGENTS.md` (via generate.sh)

### 7.2 Vérification d'intégrité au démarrage

```
1. Lire manifest.yaml
2. Pour chaque fichier dans data/ :
   - Calculer le hash actuel
   - Comparer avec le hash stocké
3. Si différence :
   - Rapporter le changement
   - Incrémenter la version
   - Mettre à jour le manifest
   - Synchroniser vers les outputs
```

### 7.3 Séquence de démarrage de session

```
1. memory-keeper --load
2. data-sync --check
3. [session normale]
```

## 8. Décisions de conception

| Question | Décision | Justification |
|----------|----------|---------------|
| Stratégie de branches | `main` uniquement | KISS |
| Durée du cache | 1 jour | Équilibre fraîcheur/performance |
| Fréquence de vérification | Chaque session | Garder les utilisateur·ices informé·es |
| Domaines autorisés | Dépôt officiel uniquement | Sécurité |
| Emplacement des prompts | `data/prompts/` | Source unique de vérité |
| Validation | Côté projet uniquement | Les LLMs ne peuvent pas faire de vérifications déterministes |

## 9. Checklist d'implémentation

- [ ] Créer la structure `data/` dans metametaprompts
- [ ] Déplacer les prompts vers `data/prompts/`
- [ ] Créer `data/manifest.yaml`
- [ ] Créer `data/rules/rules.yaml`
- [ ] Copier les skills vers `data/skills/`
- [ ] Créer l'agent `data-sync`
- [ ] Ajouter rule-13 à AGENTS.md
- [ ] Ajouter les blocs META avec prompts copier-coller
- [ ] Créer les CHANGELOGs
- [ ] Mettre à jour generate.sh
- [ ] Mettre à jour les READMEs

## 10. Sécurité

### 10.1 Restriction d'URL

N'accepter que les URLs correspondant à :
```
https://raw.githubusercontent.com/jmchantrein/Meta-prompt-LLM/main/...
```

### 10.2 Consentement utilisateur·ice

- Ne jamais mettre à jour automatiquement sans confirmation
- Afficher le diff avant remplacement
- L'utilisateur·ice peut toujours ignorer les mises à jour

---

*Version du document : 0.3.0 - Simplifié avec KISS, prompts copier-coller, validation côté projet*
