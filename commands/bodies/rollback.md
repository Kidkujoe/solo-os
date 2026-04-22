---
name: rollback
description: Rollback a merged feature if post-merge verification fails or issues surface after merge.
allowed-tools: Bash, mcp__chrome-devtools__*
---
Rolling back: $ARGUMENTS

STEP 1 - READ PRE-MERGE SNAPSHOT:
Read $PROJECT_CONTEXT/pre-merge-snapshot.txt for pre-merge commit hash.
If missing: ask user for the commit hash to roll back to.

STEP 2 - CONFIRM ROLLBACK:

  ROLLBACK CONFIRMATION
  Feature: [name]
  Merge commit: [hash]

  Rolling back will:
  - Revert [DEFAULT_BRANCH] to [pre-merge hash]
  - Remove the merged changes
  - Preserve the feature branch so work is not lost

  Has anyone pulled [DEFAULT_BRANCH] since the merge?
  Type yes - use git revert (safer, creates new commit)
  Type no  - use git reset (cleaner, removes merge commit)

STEP 3 - EXECUTE:

If no one pulled (reset):
  git checkout [DEFAULT_BRANCH]
  git reset --hard [pre-merge-hash]
  git push origin [DEFAULT_BRANCH] --force-with-lease

If others pulled (revert):
  git checkout [DEFAULT_BRANCH]
  git revert -m 1 [merge-commit-hash]
  git push origin [DEFAULT_BRANCH]

STEP 4 - VERIFY:
Open Chrome. Navigate to the feature.
Confirm it is no longer present. Confirm rest of app works.

STEP 5 - DISPLAY RESULT:

  ROLLBACK COMPLETE
  [DEFAULT_BRANCH] restored to: [pre-merge hash]
  Feature branch preserved: [name]

  Next steps:
  1. Investigate what caused the rollback
  2. Fix on the feature branch
  3. Run /review-cycle again when ready

STEP 6 - UPDATE RECORDS:
Update REVIEWS.md with rollback record: timestamp, reason (if user provides),
method used (reset/revert), verification result.
