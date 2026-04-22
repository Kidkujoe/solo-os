---
name: atlas-check
description: Check for regressions and design consistency only
allowed-tools: Bash, mcp__chrome-devtools__*
---
Run Atlas phases 4 and 5 only.
Check for regressions and design consistency. No recommendations.
Good to run after any set of changes.

Build dependency snapshot of recently changed files.
Compare against what DEPENDENCIES.md recorded.
Flag any broken dependencies or missing exports.
Run design consistency check against DESIGN.md.
Show results and update REGRESSIONS.md.
