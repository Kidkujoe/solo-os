# Visual-Test-Pro Workflow

## The one command to remember

```
/vtp
```

Type `/vtp` and answer the questions. You never need to remember
anything else. The entry point is context-aware — it checks for
uncommitted changes, open reviews, stale Atlas context and
unprocessed wiki sources before showing the menu, and tells you what
the obvious next step is.

## If you prefer direct commands

| Moment | Command |
|---|---|
| Every morning | `/atlas --quick` |
| Finished a feature | `/atlas-feature [name]` |
| Small change | `/ship` |
| Shipping a feature | `/review-cycle [feature name]` |
| Adding knowledge | drop file into `raw/` then `/wiki-ingest` |
| Understanding the market | `/compass` |
| Starting a new project | `/new-project [idea]` |

### Before any launch

```
/test --deep
/pillars --full
/empathy
/seo
/performance
```

## The mental model in plain English

| Layer | What it knows |
|---|---|
| **Atlas** | The brain — your product |
| **Compass** | The strategy — your market |
| **Empathy** | The users — how they actually behave |
| **Wiki** | The knowledge — everything you have ever read or learned |
| **Autoloop** | The improver — fixes things autonomously while you work |
| **The rest** | Tools for specific moments |

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
