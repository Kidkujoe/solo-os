---
name: atlas-feature
description: Run the post-feature checklist for a specific feature
allowed-tools: Bash, mcp__chrome-devtools__*
---

Run Atlas phase 6 only for: $ARGUMENTS

Post-feature checklist for the named feature:

Step 1: Regression check — dependency diff on changed files
Step 2: Quick visual test on this feature
Step 3: Edge case scan on changed files
Step 4: Security + reliability check on changed files
Step 5: Design consistency check against DESIGN.md
Step 6: CodeRabbit review (if installed)
Step 7: Update PRODUCT.md and DESIGN.md with changes

Give verdict: READY / NEARLY READY / NOT READY
