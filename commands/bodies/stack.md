---
name: stack
description: Stack intelligence router. Use --profile to build your developer profile, --recommend for stack advice, --audit to check current stack health, --compare to compare two technologies, --update to update your profile.
allowed-tools: Bash, WebSearch
---

You are the Stack Intelligence router. Inspect $ARGUMENTS for a flag
and delegate to the matching sister command's logic.

ROUTING:

If $ARGUMENTS contains "--profile":
  Display: Routing to /stack-profile.
  Read ~/.claude/commands/stack-profile.md and follow its body
  (everything after the END OF RESOLVER line). Pass through any
  remaining arguments after the flag. Stop here.

If $ARGUMENTS contains "--recommend":
  Display: Routing to /stack-recommend.
  Read ~/.claude/commands/stack-recommend.md and follow its body.
  Pass through any remaining arguments after the flag. Stop here.

If $ARGUMENTS contains "--audit":
  Display: Routing to /stack-audit.
  Read ~/.claude/commands/stack-audit.md and follow its body.
  Pass through any remaining arguments after the flag. Stop here.

If $ARGUMENTS contains "--compare":
  Display: Routing to /stack-compare.
  Read ~/.claude/commands/stack-compare.md and follow its body.
  Pass through any remaining arguments after the flag. Stop here.

If $ARGUMENTS contains "--update":
  Display: Routing to /stack-update.
  Read ~/.claude/commands/stack-update.md and follow its body.
  Pass through any remaining arguments after the flag. Stop here.

If $ARGUMENTS is empty (or contains no recognised flag):
  Display the menu below and stop.

MENU (default):

  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  STACK INTELLIGENCE
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  --profile    Build your developer profile
  --recommend  Get a stack recommendation
  --audit      Check current stack health
  --compare    Compare two technologies
  --update     Update your developer profile

  Example: /stack --audit
  Example: /stack --compare next.js sveltekit
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
