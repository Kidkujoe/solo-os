---
name: stack-recommend
description: Personalised tech stack recommendation based on your developer profile, project history and the specific product type. References your actual experience, not generic best practice.
allowed-tools: Bash
---
Read ~/.claude/context/DEVELOPER_PROFILE.md
Read $PRODUCT_MD and $STRATEGY_MD if they exist

If DEVELOPER_PROFILE.md missing or not CONFIRMED:
  DEVELOPER PROFILE NEEDED FIRST
  Stack recommendations are generic without your profile.
  Run /stack-profile first (10 minutes, once).
  STOP.

$ARGUMENTS describes the project. If empty use current project context.

PHASE 1 - CLASSIFY PROJECT TYPE:
SaaS web app / marketing site / API service / mobile backend /
dev tool / CLI / e-commerce / community platform / internal tool /
AI or data product. Each has different optimal stack.

Also determine: primary user type, expected scale, time pressure,
revenue needed quickly.

PHASE 2 - RESEARCH CURRENT STATE:
web_search "[project type] tech stack [current year]"
web_search "[project type] best framework reddit [current year]"
Look for: developer sentiment trends, known scaling issues at relevant
sizes, recent deprecations, new options. Ensures recommendations
reflect current reality.

PHASE 3 - BUILD RECOMMENDATION:
Rules:
1. Start with what developer already knows well
2. Only suggest unfamiliar if compelling specific reason
3. Reference actual project history explicitly
4. Acknowledge stated constraints
5. Match working preferences
6. Reflect goal priority order

Display:
  STACK RECOMMENDATION
  Project: [name]  Type: [classification]
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  RECOMMENDED STACK:
  Frontend / Backend / Database / Auth / Deployment / Key extras

  WHY THIS STACK FOR YOU SPECIFICALLY:
  For each major decision explain why in terms of developer's actual
  history. Examples:
  "Next.js — you have used this on 3 projects with no incidents. In
  your Adopt tier. For this project where you want to move fast, obvious."
  "Supabase over PlanetScale — you flagged database setup as painful on
  previous projects. Supabase combines DB + auth in one dashboard,
  addressing that pain directly."

  WHAT I AM NOT RECOMMENDING AND WHY:
  For any obvious alternative that was rejected, explain why given
  developer's context. Examples:
  "Not Remix — similar to Next.js but no experience with it. No reason
  to learn something new when Next.js serves this use case well."

  TRADE-OFFS TO BE AWARE OF:
  Honest assessment of what this stack does not do well, and why it's
  still the right choice given stated goals.

  ESTIMATED SETUP TIME:
  With your experience: [X hours]. Most time will be: [what].
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Use this stack? yes / adjust / show alternatives

If adjust: ask what to change and why, update recommendation.
If show alternatives: show two alternatives with specific trade-offs
for this developer vs the primary recommendation.

After confirmation:
- Save decision to $DECISIONS_MD in project context
- Write TechDecision note to Obsidian if vault exists
- Write to LessonsLearned if relevant
