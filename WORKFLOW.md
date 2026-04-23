# Visual-Test-Pro Workflow

## The one command to remember

```
/explore
```

Type `/explore` and answer the questions. You never need to remember
anything else. The entry point is context-aware — it checks for
uncommitted changes, branches ready to merge, stale Atlas context and
unprocessed wiki sources before showing the menu, and surfaces the
obvious next step.

## The mental model

| Layer | Role | What it knows |
|---|---|---|
| **Atlas** | the brain | your product |
| **Compass** | the strategy | your market |
| **Empathy** | the users | your users |
| **Wiki** | the knowledge | everything you have read |
| **Autoloop** | the improver | fixes things while you work on other things |

## If you prefer direct commands

| Moment | Command |
|---|---|
| Every morning | `/atlas-quick` |
| Finished a feature | `/atlas-feature [feature name]` |
| Small change | `/ship` |
| Shipping a feature | `/review-cycle [feature name]` |
| Adding knowledge | drop file into `raw/` then `/wiki-ingest` |
| Understanding the market | `/compass` |
| Starting a new project | `/new-project [idea]` |
| Not sure what to do | `/explore` |

### Before any launch

```
/test --deep
/pillars --full
/empathy
/seo
/performance
```

## Flag shortcuts (v2.6.0)

The standalone commands still exist. Flags are additive shortcuts:

| Flag | Equivalent |
|---|---|
| `/atlas --rebuild` | `/atlas-map` |
| `/atlas --check` | `/atlas-check` |
| `/atlas --quick` | `/atlas-quick` |
| `/atlas --feature [name]` | `/atlas-feature [name]` |
| `/test --quick` | `/test-quick` |
| `/test --deep` | `/test-deep` |
| `/compass --feature [name]` | `/compass-feature [name]` |
| `/compass --project` | `/compass-project` |
| `/compass --retro [name]` | `/compass-retro [name]` |
| `/copyai --research-only` | `/copyai-research` |
| `/new-project [idea] --validate-only` | validation-only mode |
| `/stack --profile / --recommend / --audit / --compare / --update` | `/stack-*` |
