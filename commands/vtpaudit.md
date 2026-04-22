---
name: vtpaudit
description: Internal audit. Checks all installed command files for path isolation violations.
allowed-tools: Bash
---

Run a path isolation audit on all installed command files.

For each file in ~/.claude/commands/ search for hardcoded
~/.claude/context/ paths. Any path that is NOT one of these
approved global paths is a violation:

Approved global paths:
- ~/.claude/context/report-template.html
- ~/.claude/context/test-accounts-global.md
- ~/.claude/context/projects/

Any other hardcoded ~/.claude/context/ path in a command file
means that command will contaminate projects when run.

Display:

  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  PATH ISOLATION AUDIT
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Commands audited: [count]

  VIOLATIONS FOUND: [count]
  [For each violation show:
    File: [command file]
    Line: [line number]
    Violating path: [path]
    Should be: [resolver variable to use]]

  CLEAN: [count]
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

If violations are found, recommend the user run the migration
by reinstalling the plugin.

RESOLVER VERSION CHECK (v2.2.0+):
Read the canonical resolver block from ~/visual-test-pro/RESOLVER.md.
For each installed command in ~/.claude/commands/ extract its resolver
section (lines between "RESOLVER — RUN THIS BEFORE ANYTHING ELSE" and
"END OF RESOLVER").

Compare the extracted resolver against the canonical version.

Display:

  RESOLVER VERSION CHECK
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Canonical version: [hash or version marker]
  Commands with current resolver: [count]
  Commands out of date: [count]

  OUT OF DATE:
  [command name] - last updated [date]
  [list each out-of-date command]

  To update run:
  bash ~/visual-test-pro/scripts/build-commands.sh
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
