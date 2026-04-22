---
name: reviews
description: Branch and review status board. Shows all open branches, their review status, what is blocking merge and detects conflicts across branches.
allowed-tools: Bash
---
Display the full branch and review status board.

STEP 1 - GET ALL BRANCHES:
Run `git branch -a` and `git branch -r`.

STEP 2 - STATUS OF EACH BRANCH:
For each non-default branch:
- Last commit: `git log [branch] -1 --format="%H %s %ar"`
- Ahead/behind: `git rev-list --left-right --count [DEFAULT_BRANCH]...[branch]`
- Changed files: `git diff [DEFAULT_BRANCH]...[branch] --name-only`
- Check for open PR on platform (via `gh pr list --head [branch]`)

STEP 3 - READ REVIEW HISTORY:
Read $PROJECT_CONTEXT/REVIEWS.md and match each branch to its review record.

STEP 4 - CONFLICT DETECTION:
For every pair of non-default branches:
Run `git diff [branch-a]...[branch-b] --name-only`.
If any file appears in both: flag as potential conflict.
Recommend merge order based on which branch was created earlier.

STEP 5 - DISPLAY STATUS BOARD:

  BRANCH AND REVIEW STATUS — [timestamp]
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  For each branch:

  [branch-name]
  Last commit: [message] ([time ago])
  Changes: [count] files, +[added] -[removed] lines
  Status: READY TO MERGE / REVIEW IN PROGRESS / FIXES NEEDED /
          NOT REVIEWED / PR OPEN
  Review: [date or NEVER]
  Quality: [score or N/A]
  Findings: [fixed] / [total]
  PR: [link or NONE]
  Blocking: [what is stopping merge or NOTHING]

  CONFLICT WARNINGS:
  [branch-a] and [branch-b] both modified: [files]
  Recommended merge order:
  1. [branch] first (branched earlier)
  2. [branch] second (re-review after first merges)

  SUMMARY
  Total: [count]  Ready: [count]  Review needed: [count]
  Fixes needed: [count]  Conflicts: [count]

  Commands:
    /review-cycle [branch] - start review
    /merge-ready [branch]  - check merge readiness
    /rollback [feature]    - rollback a merge
