# Prompt pour futures sessions - Analyse et recommandations

> Document généré le 2026-02-02 par une session d'analyse approfondie
> Session Claude Code: session_01BDQxqq4HVb7yC6d4HuVUon

## Contexte du projet

Tu reprends le projet **Meta-prompt-LLM**, un framework de création et maintenance de collections de prompts avec :
- Architecture IA hybride multi-plateforme
- Source unique de vérité dans `prompts/fr/metametaprompts/data/`
- 11 skills, 14 règles, génération pour 10 plateformes
- Documentation bilingue EN/FR

## Actions obligatoires au démarrage

1. **Lire la mémoire** : `cat .ai/MEMORY.md`
2. **Vérifier la synchronisation** : `.ai/generate.sh --check`
3. **Lire ce document** pour comprendre l'état actuel et les priorités

---

## État actuel du projet (2026-02-02)

### ✅ Ce qui fonctionne bien

| Composant | Status | Notes |
|-----------|--------|-------|
| Architecture source unique | ✅ Stable | `data/` → `.ai/` → fichiers générés |
| Génération multi-plateforme | ✅ Complet | 10 plateformes supportées |
| Documentation bilingue | ✅ Synchronisée | EN/FR avec liens croisés |
| Système de hooks | ✅ Fonctionnel | 8 hooks configurés |
| Skills de validation | ✅ Définis | 4 validateurs (prompt, inclusivité, liens, traduction) |
| Schémas workflows | ✅ Créés | `docs/*/workflows.md` avec ASCII diagrams |

### ⚠️ Fonctionnalités incomplètes

| Fonctionnalité | État | Priorité | Impact |
|----------------|------|----------|--------|
| Fichiers d'index data | Manquants | HAUTE | `self-improver` partiellement fonctionnel |
| META `dependencies_urls` | Spécifié, non implémenté | MOYENNE | Traçabilité dépendances |
| Documentation skills individuelle | Absente | BASSE | Lisibilité |
| Documentation hooks dédiée | Dispersée | BASSE | Centralisation |

### 🔴 Problèmes connus

1. **Fichiers d'index manquants pour self-improver**
   - `data/rules-index.yaml` - index des règles avec hashes
   - `data/skills-index.yaml` - index des skills avec hashes
   - `data/prompts-index.yaml` - index des prompts versionnés
   - `data/dependencies.yaml` - mapping règles/skills → prompts
   - `data/pending-reviews.yaml` - notes @future-self en attente

2. **Système de vérification de version des prompts**
   - Documenté dans `docs/*/specs/version-check-system.md`
   - Non implémenté dans les prompts existants

---

## Recommandations prioritaires

### Priorité 1 : Créer les fichiers d'index (HAUTE)

Ces fichiers sont référencés par `self-improver` et `meta-meta-prompt-llm.md` mais n'existent pas :

```bash
# Fichiers à créer dans prompts/fr/metametaprompts/data/
data/
├── rules-index.yaml      # Hash de chaque règle dans AGENTS.md
├── skills-index.yaml     # Hash de chaque skill YAML
├── prompts-index.yaml    # Version et hash de chaque prompt
├── dependencies.yaml     # Mapping skill/règle → prompts impactés
└── pending-reviews.yaml  # File des notes @future-self
```

**Format suggéré pour `rules-index.yaml` :**
```yaml
version: "1.0.0"
updated: "2026-02-02"
rules:
  rule-0:
    name: "Honesty"
    hash: "sha256:..."
    last_modified: "2026-02-01"
  rule-1:
    name: "State of the Art"
    hash: "sha256:..."
    last_modified: "2026-02-01"
  # ... etc
```

**Format suggéré pour `dependencies.yaml` :**
```yaml
version: "1.0.0"
updated: "2026-02-02"
mappings:
  rules:
    rule-10:  # Écriture inclusive
      impacts:
        - "prompts/fr/**/*.md"
      skills:
        - "inclusivity-reviewer"
  skills:
    translator:
      impacts:
        - "prompts/en/**/*.md"
        - "prompts/fr/**/*.md"
        - "docs/**/*.md"
```

### Priorité 2 : Implémenter `dependencies_urls` dans les prompts (MOYENNE)

Le format est défini dans `_TEMPLATE.md` mais aucun prompt ne l'utilise encore.

**Action :** Mettre à jour les META blocks de :
- `prompts/en/metaprompts/hybrid-ai-bootstrap/hybrid-ai-bootstrap.md`
- `prompts/en/metaprompts/hybrid-ai-takeover/hybrid-ai-takeover.md`
- `prompts/en/metametaprompts/meta-meta-prompt-llm.md`
- Versions françaises correspondantes

**Exemple :**
```markdown
<!-- META
prompt_id: "hybrid-ai-bootstrap"
version: "2.1.0"
source_url: "https://raw.githubusercontent.com/jmchantrein/Meta-prompt-LLM/main/prompts/en/metaprompts/hybrid-ai-bootstrap/hybrid-ai-bootstrap.md"
applicable_rules: ["rule-0", "rule-1", "rule-2", "rule-4", "rule-8", "rule-10"]
applicable_skills: ["prompt-validator", "inclusivity-reviewer", "translator"]

dependencies_urls:
  skills:
    - "https://raw.githubusercontent.com/jmchantrein/Meta-prompt-LLM/main/prompts/fr/metametaprompts/data/skills/prompt-validator.yaml"
    - "https://raw.githubusercontent.com/jmchantrein/Meta-prompt-LLM/main/prompts/fr/metametaprompts/data/skills/inclusivity-reviewer.yaml"
    - "https://raw.githubusercontent.com/jmchantrein/Meta-prompt-LLM/main/prompts/fr/metametaprompts/data/skills/translator.yaml"
  hooks:
    - "https://raw.githubusercontent.com/jmchantrein/Meta-prompt-LLM/main/prompts/fr/metametaprompts/data/hooks/hooks.yaml"
  rules:
    - "https://raw.githubusercontent.com/jmchantrein/Meta-prompt-LLM/main/AGENTS.md"
-->
```

### Priorité 3 : Améliorer le workflow self-improver (MOYENNE)

Le skill `self-improver` est conçu pour :
1. Détecter les changements de règles via comparaison de hash
2. Identifier les prompts impactés via `dependencies.yaml`
3. Proposer des mises à jour (semi-automatique)

**Problème actuel :** Sans les fichiers d'index, il ne peut pas fonctionner complètement.

**Action :**
1. Créer les fichiers d'index (Priorité 1)
2. Tester le workflow complet :
   - Modifier une règle dans AGENTS.md
   - Vérifier que `self-improver` détecte le changement
   - Valider que le scope d'impact est correct

### Priorité 4 : Documentation skills (BASSE)

Créer `docs/en/skills/` avec un fichier par skill généré depuis les YAML.

**Option automatisée :** Ajouter une fonction à `generate.sh` :
```bash
generate_skill_docs() {
    for skill in .ai/skills/*.yaml; do
        # Extraire name, description, instructions
        # Générer docs/en/skills/${name}.md
    done
}
```

---

## Architecture à comprendre

### Flux de données (critique)

```
prompts/fr/metametaprompts/data/   ← SOURCE UNIQUE DE VÉRITÉ
        │
        │ (copie manuelle ou data-sync)
        ▼
.ai/skills/*.yaml                  ← COPIE DE TRAVAIL
.ai/hooks/hooks.yaml
        │
        │ (generate.sh)
        ▼
AGENTS.md, CLAUDE.md               ← FICHIERS GÉNÉRÉS
.cursorrules, .continuerc.json     (NE PAS MODIFIER DIRECTEMENT)
.claude/settings.json, etc.
```

**Règle absolue :** Toute modification doit être faite dans `data/` puis synchronisée.

### Skills par catégorie

**Core (infrastructure) :**
- `data-sync` - Synchronisation data/ → .ai/
- `memory-keeper` - Mémoire persistante
- `workflow-orchestrator` - Orchestration multi-agents
- `hooks-manager` - Base de connaissances hooks
- `self-improver` - Auto-amélioration du projet

**Validation :**
- `prompt-validator` - Schéma et champs requis
- `inclusivity-reviewer` - Écriture inclusive FR
- `link-checker` - Liens internes markdown
- `translator` - Synchronisation EN/FR

**Documentation :**
- `workflow-documenter` - Schémas et META blocks

### Hooks actifs

| Event | Hook | Effet |
|-------|------|-------|
| UserPromptSubmit | load-memory | Rappel MEMORY.md |
| UserPromptSubmit | check-skills-sync | Vérifie generate.sh |
| PreToolUse | protect-env-files | Confirmation .env |
| PreToolUse | protect-credentials | Confirmation credentials |
| PreToolUse | confirm-delete | Confirmation rm |
| PostToolUse | auto-generate | Après modif skill |
| PostToolUse | inclusivity-reminder-fr | Après modif FR |
| PostToolUse | translation-sync-reminder | Après modif docs EN |
| Stop | memory-update-reminder | Rappel MEMORY.md |

---

## Commandes utiles

```bash
# Vérifier si génération nécessaire
.ai/generate.sh --check

# Régénérer tous les fichiers
.ai/generate.sh --force

# Voir ce qui serait généré
.ai/generate.sh --dry-run

# Calculer hash d'un fichier
sha256sum prompts/fr/metametaprompts/data/skills/mon-skill.yaml

# Vérifier la structure
tree -L 3 prompts/fr/metametaprompts/data/
```

---

## Convention @future-self

Pour laisser des notes aux futures sessions, utiliser dans les messages de commit :

```
<type>(<scope>): <description>

@future-self: <note importante>
- Impact : <fichiers/prompts concernés>
- Action : <ce qu'il faudra vérifier>
- Contexte : <pourquoi cette décision>

https://claude.ai/code/session_xxx
```

Ces notes seront extraites vers `pending-reviews.yaml` (quand ce fichier existera).

---

## Checklist de fin de session

- [ ] Tous les fichiers modifiés dans `data/` ont été synchronisés vers `.ai/`
- [ ] `generate.sh --check` retourne succès
- [ ] Documentation mise à jour si nécessaire
- [ ] Commit avec convention @future-self si décisions importantes
- [ ] `MEMORY.md` mis à jour avec le contexte actuel

---

## Points d'attention pour le développement

1. **Ne jamais modifier directement les fichiers générés** (AGENTS.md, .cursorrules, etc.)
2. **Toujours synchroniser** : data/ → .ai/ → generate.sh
3. **Écriture inclusive obligatoire** pour le contenu français (point médian : utilisateur·ice)
4. **Tester les hooks** après modification de hooks.yaml
5. **Vérifier les deux langues** : modifier EN ET FR ou utiliser translator

---

## Contacts et ressources

- **Repository** : https://github.com/jmchantrein/Meta-prompt-LLM
- **Standard AGENTS.md** : https://agents.md/
- **MCP Protocol** : https://modelcontextprotocol.io/
- **BMAD Method** : https://github.com/bmad-code-org/BMAD-METHOD

---

*Document de session généré automatiquement. À utiliser comme contexte de démarrage pour toute future session de développement sur ce projet.*
