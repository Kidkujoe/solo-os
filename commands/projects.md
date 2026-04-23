---
name: projects
description: List all projects that have Solo OS context data.
allowed-tools: Bash
---

Read ~/.claude/context/projects/ and list every project folder found.

For each project folder show:
- Project ID
- Project name (basename before the hash suffix)
- Last active (last modified date of any file in the folder)
- Data size (total folder size)
- Atlas exists (PRODUCT.md present?)
- Last test date (from HEALTH.md or test-session.md if exists)
- Last audit date (from HEALTH.md if exists)
- Status (v3.2.0+): if last-active date is more than 90 days ago,
  mark as INACTIVE; otherwise ACTIVE.

Display:

  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  YOUR PROJECTS
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  [count] projects with context data

  [Project name]
  ID: [project-id]
  Last active: [date]
  Data: [size]
  Atlas: [yes/no]
  Last test: [date or never]

  [Continue for each project]

  Total context data: [total size]
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

If $ARGUMENTS is "clean [project-name]":
Show what will be deleted and ask for confirmation before removing.

If $ARGUMENTS is "detail [project-name]":
Show full file listing with sizes for that specific project.

If any project is marked INACTIVE (v3.2.0+), after the listing offer:
  [count] project(s) inactive over 90 days.
  Archive or delete?
  A  Archive - move to ~/.claude/context/projects/_archived/
  B  Delete - remove permanently (confirmation required)
  C  Leave as-is
Never delete without explicit confirmation.
