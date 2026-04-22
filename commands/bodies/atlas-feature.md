---
name: atlas-feature
description: Run the post-feature checklist for a specific feature
allowed-tools: Bash, mcp__chrome-devtools__*
---
===========================================
KNOWLEDGE BRIDGE HOOKS (v2.3.0)
===========================================

If OBSIDIAN_BRIDGE=on (STEP R8):

At the start — call read_pattern_context and read_product_context from
RESOLVER.md § KNOWLEDGE_BRIDGE. Flag any known recurring pattern
against this feature as a known risk, not a new finding.

After review complete — call write_feature_note with status="built",
filling in prism_score and pv_classification from the feature's
COMPASS record if it exists.

If a new recurring pattern is detected (same class of issue seen 3+
times in this project's review history) call write_pattern_note.

If a bridge call fails do not abort — log and continue.
===========================================

Run Atlas phase 6 only for: $ARGUMENTS

Post-feature checklist for the named feature:

Step 1: Regression check — dependency diff on changed files
Step 2: Quick visual test on this feature
Step 3: Edge case scan on changed files
Step 4: Security + reliability check on changed files
Step 5: Design consistency check against DESIGN.md
Step 6: CodeRabbit review (if installed)
Step 7: Update PRODUCT.md and DESIGN.md with changes
Step 8: Terminology check against VOICE.md
Step 9: Basic SEO check (title, meta, H1, indexing)
Step 10: UX empathy check (Group 1 and Group 2 friction)

Give verdict: READY / NEARLY READY / NOT READY

STEP 11 - AUTOMATED REVIEW PIPELINE:
After the post-feature checklist passes, offer to trigger the full
review cycle automatically.

Display:

  POST-FEATURE CHECKLIST COMPLETE
  Starting automated review pipeline
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  This will run:
  1. Pre-review gates (secrets, deps, build, tests, lint, impact)
  2. CodeRabbit code review
  3. Visual browser test
  4. Fix approval flow
  5. Documentation check
  6. Merge readiness assessment

  Estimated time: 10-30 minutes depending on code size and
  CodeRabbit speed.

  Start now?  Type yes / later

If yes: run /review-cycle with the feature name as argument.

STEP 12 - DEPLOY PROMPT:
After /review-cycle completes and branch is merged:

  Feature merged successfully.

  Deploy to production?
  Type yes to run /deploy
  Type later to deploy manually
  Type no to skip

If yes: run /deploy with the feature name as argument.
