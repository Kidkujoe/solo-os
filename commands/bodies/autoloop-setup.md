---
name: autoloop-setup
description: Creates the product program file for the current project. Defines the evaluation metric, what the agent can and cannot change, the simplicity criterion and which wiki sources apply. Based on Karpathy autoresearch program.md pattern. You iterate on this file over time. The instructions are the product.
allowed-tools: Bash
---
Run the RESOLVER first.

Read:
- `$PRODUCT_MD` — atlas product brain for context
- `$STRATEGY_MD` — strategic goals if set
- `$OBSIDIAN_VAULT/wiki/index.md` — list of Rules pages to reference

Target path: `$OBSIDIAN_VAULT/program/$PROJECT_NAME.md`

If the file already exists, read it first and offer to update rather
than overwrite. Preserve any sections the user has already filled in.

Ask these questions one at a time. Wait for each answer before the
next.

===========================================
QUESTION 1 — THE METRIC
===========================================

  What is the single metric that determines whether a change is an
  improvement for [project name]?

  Must be measurable in one session.

  1. Lighthouse performance score
  2. Test pass rate
  3. Design consistency score
  4. Accessibility violation count
  5. Security pillar score
  6. All of the above as a composite

  Type your choice.

===========================================
QUESTION 2 — ALLOWED SCOPE
===========================================

  What files and folders can the autoloop change without asking?

  Example: CSS files, copy files, image files, meta tags.

  What can it NOT touch without your explicit approval?

  Example: auth, payment, database, environment variables.

===========================================
QUESTION 3 — SIMPLICITY FOR THIS PRODUCT
===========================================

  What does simpler mean for this specific product?

  Example: fewer UI elements is always better for RSVPie because
  event hosts want to complete tasks quickly not explore features.

===========================================
QUESTION 4 — WIKI SOURCES
===========================================

  Which wiki pages should the autoloop read before running?

  [List available Rules-*.md and relevant Concept-*.md pages from
  wiki/index.md]

  Confirm which ones apply.

===========================================
WRITE THE PROGRAM FILE
===========================================

Compose the program file from the answers. Show the complete file
before saving. Ask for confirmation.

Write to `$OBSIDIAN_VAULT/program/$PROJECT_NAME.md`.

Display when saved:

  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  PROGRAM FILE CREATED
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  This file is yours to iterate on.
  As you run autoloop sessions and learn what works, refine this file.
  The better the program file gets, the smarter the autoloop becomes.

  This is how Karpathy uses program.md.
  The instructions are the product.
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
