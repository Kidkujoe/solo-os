---
name: edgecases
description: Analyse the app and discover edge cases without running a full test
allowed-tools: Bash, mcp__chrome-devtools__*
---
Analyse this codebase deeply and generate a comprehensive
list of edge cases specific to this app.

Do not run any tests. Just analyse and think.

STEP 1 - LOAD CONTEXT
- Read $PRODUCT_MD silently if it exists
- Read $SESSION_FILE
- Read $GLOBAL_ACCOUNTS (filter by PROJECT_ID)
- Read $EDGE_CASES if it exists
- Check for previous edge case analysis

STEP 2 - DEEP CODEBASE ANALYSIS

Read every key file in the project. Map every user flow.
Find every data boundary. Identify every integration point.
Think about every failure scenario.

Analyse:

TECH STACK PATTERNS
- What framework is being used
- What database or data layer exists
- What auth system is in place
- What third party services are connected
- What payment systems if any
- What file upload systems if any
- What real time features if any
- What API integrations exist
- What caching layer if any
- What background jobs if any

USER FLOW MAPPING
- Map every possible user journey from entry to completion
- Find where journeys branch
- Find where journeys can dead end
- Find where data is passed between steps
- Find where state is stored (localStorage, sessions, cookies)
- Find where tokens are passed

DATA BOUNDARIES
- What is the minimum valid input for every field
- What is the maximum valid input
- What characters could cause issues
- What happens at zero values
- What happens at negative values
- What happens with empty states
- What happens with very long strings
- What happens with special characters
- What happens with unicode and emoji
- What happens with SQL-like input
- What happens with HTML in inputs

ASYNC AND TIMING
- What operations take time to complete
- What shows loading states
- What could time out
- What happens if a user acts before loading completes
- What happens if network drops mid flow
- What race conditions could exist

PERMISSION BOUNDARIES
- What can a logged out user access
- What can a basic user access
- What can a premium user access
- What can an admin access
- Where do these boundaries overlap
- Where could they be bypassed

STEP 3 - GENERATE EDGE CASES

Based purely on what was found in the analysis,
independently generate a list of edge cases.
Do not use a generic checklist. Think specifically
about this app.

Organise into:

HAPPY PATH VARIATIONS
Things that should work but in slightly different ways
than the most obvious path.

BOUNDARY CONDITIONS
The edges of what the system accepts.

UNHAPPY PATH SCENARIOS
Things users do that they should not.

BROKEN ENVIRONMENT SCENARIOS
Things that break the environment around the action.

INTEGRATION FAILURE SCENARIOS
What happens when connected services fail.

PERMISSION EDGE CASES
Unusual combinations of access.

STATE CORRUPTION SCENARIOS
What could leave the app in a bad state.

STEP 4 - DISPLAY FULL REPORT

Display all discovered edge cases organised by risk:

  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  EDGE CASE ANALYSIS COMPLETE
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Project: [name]
  Files analysed: [count]
  Edge cases found: [count]
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  HIGH RISK
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  For each:
  What: [plain English description]
  Why risky: [what could go wrong]
  How to test: [plain English approach]
  Category: [which category above]
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  MEDIUM RISK
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  For each:
  What: [plain English description]
  Why: [brief reason]
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  INTERESTING
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  [List each with brief description]
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

STEP 5 - SAVE TO FILE

Save all edge cases to $EDGE_CASES

Format:
# Edge Cases - [Project Name]

Date analysed: [date]
Total edge cases found: [count]

## HIGH RISK
[list each with description and test approach]

## MEDIUM RISK
[list each]

## INTERESTING
[list each]

## TESTED
[empty - filled in during test sessions]

## NOT YET TESTED
[all of them initially]

STEP 6 - ASK WHAT TO DO NEXT

Display:

  Edge cases saved to:
  $EDGE_CASES

  Would you like to run these edge cases now?
  Type yes to start /test with edge cases
  Type save to keep for later

===========================================
SKIP DETECTION (v3.1.0+)
===========================================

Every finding this command surfaces is subject to skip tracking in
$SKIP_TRACKER. For each rule read confidence_for_projects.[PROJECT_NAME]
from the wiki page frontmatter and apply the per-level enforcement:
  HIGH            → VIOLATION.
  MEDIUM          → SUGGESTION (non-blocking).
  LOW             → shown only in full-audit mode.
  DISPUTED        → silent unless explicitly requested.
  NOT_APPLICABLE  → silent.

Track skips per rule_id (first/second skip silent, third triggers
status=pending_question). The 5-option question, resolutions A-E,
and wiki confidence updates are defined in
~/solo-os/docs/FEEDBACK_LOOP.md. Follow it exactly.

Skip entries must include: rule_id, rule_name, source (wiki page),
skip_count, last_skipped (ISO timestamp), status, resolution.
