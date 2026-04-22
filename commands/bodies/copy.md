---
name: copy
description: Full copy and brand voice audit. Checks terminology consistency, tone, error messages, empty states and marketing vs product alignment.
allowed-tools: Bash, mcp__chrome-devtools__*
---
===========================================
WIKI INTEGRATION (v2.5.0)
===========================================

If OBSIDIAN_BRIDGE=on, at the start of every run:

1. Read `$OBSIDIAN_VAULT/wiki/index.md`.
2. Load `Rules-BrandVoice.md` if it exists — this is the authority
   for terminology, tone, and style. Not VOICE.md, not generic
   copywriting best practice.
3. Load every `Concept-*.md` page about customer language. These are
   the user's own words about pains, desires, and framings — cite
   from them rather than inventing phrases.

Display:

  Wiki authority loaded:
  Brand voice: [Rules-BrandVoice.md or "none — using VOICE.md fallback"]
  Customer language concepts: [count]
  Auditing against YOUR voice + YOUR users' language.

===========================================
COMMAND BODY
===========================================

You are running a full copy and brand voice audit for: $ARGUMENTS

Read $PRODUCT_MD silently if it exists
Read $VOICE_MD
Read $SEO_MD if it exists
Read $ATLAS/COPYAI.md if it exists

IF COPYAI.md exists and was generated in the last 6 months:
Use the confirmed copy strategy and customer language bank as the
foundation for this audit. Reference it when making suggestions.

IF COPYAI.md does not exist:
Display at the start:

  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  TIP: For stronger copy suggestions
  run /copyai first.

  /copyai researches your competitors,
  sources real customer language from
  Reddit, review sites and social
  platforms, and builds a copy strategy
  grounded in evidence before auditing.

  Run /copy now for a standard audit
  Run /copyai for intelligence-driven
  copy strategy and rewrites
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

===========================================
PHASE 1 - BUILD OR LOAD VOICE GUIDE
===========================================

If VOICE.md is empty or contains only the template comment:

Display:
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  BUILDING YOUR BRAND VOICE GUIDE
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  I have not defined your brand voice yet.
  I will read your codebase and draft a
  voice guide from what I find. You can
  confirm or correct it before I use it.
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Read every user-facing string in the project:
- All visible text in the browser
- All button labels, form labels, placeholder text
- All error messages, success messages, empty states
- All tooltip and helper text
- All email templates if present
- All marketing and landing page copy
- All onboarding copy

From this derive:
- The apparent tone being used
- Terminology patterns that exist
- Inconsistencies already present
- Quality of error messages and empty states

Draft VOICE.md with:
# [Product Name] - Brand Voice

## What this product is in one sentence
## Who we are talking to
## Our tone
## Words we always use (terminology map)
## Words we never use
## How we write CTAs (verb-first pattern)
## How we write error messages (what happened + what to do)
## How we write empty states (acknowledge + one action)
## How we write success messages
## Tone by context (marketing, onboarding, dashboard, errors, emails)

Display the draft and ask:
Does this look right?
Type yes to confirm / edit to change / skip to audit without confirming

If confirmed: save to VOICE.md with status: Confirmed by user
If already confirmed from a previous run: load and use it.

===========================================
PHASE 2 - TERMINOLOGY AUDIT
===========================================

Read every user-facing string with VOICE.md loaded.

CHECK 1: FEATURE NAMING CONSISTENCY
Build a map of every term used for each feature or concept.
Flag anywhere the same thing is called different names.

For each inconsistency show:
  TERMINOLOGY INCONSISTENCY
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Concept: [what this thing is]
  Names found: [list with locations]
  Recommended term: [which one and why]
  Suggested changes: [file:line for each]
  Apply all? Type yes / no / one-by-one
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

CHECK 2: CTA CONSISTENCY
Check all buttons and links follow the voice guide CTA pattern.
Flag CTAs that don't start with a verb, use vague language,
or use submit/OK/yes.

CHECK 3: TONE CONSISTENCY
Compare tone on marketing pages vs inside the app.
Flag sections that sound significantly different.
Rate each section: On voice / Slightly off / Off brand

===========================================
PHASE 3 - QUALITY AUDIT
===========================================

CHECK 4: ERROR MESSAGE QUALITY
Find every error message. For each evaluate:
- Says what went wrong in plain English?
- Says what user can do next?
- Avoids technical jargon?
- Matches product tone?

Flag poor messages with suggested rewrites.

CHECK 5: EMPTY STATE QUALITY
Find every empty state. For each check:
- Acknowledges the emptiness?
- Gives one clear action?
- Friendly and helpful tone?

Flag poor empty states with suggested rewrites.

CHECK 6: MARKETING VS PRODUCT ALIGNMENT
Compare landing page claims with product reality:
- Claims the product doesn't deliver yet
- Features described differently between marketing and product
- Pricing promises vs actual limits
- Setup described as simple vs complex reality

For each mismatch show options:
1. Update marketing to be accurate
2. Simplify product to match claim
3. Add context to bridge the gap

===========================================
PHASE 4 - BROWSER COPY CHECK
===========================================

Open Chrome and visually read copy on every page.

Check for:
- Text truncated incorrectly
- Placeholder text never replaced
- TODO or lorem ipsum still visible
- Developer strings exposed to users
- Hardcoded test data visible
- Copy overlapping other elements
- Copy too small to read on mobile

Screenshot any copy issues found.

===========================================
PHASE 5 - RESULTS
===========================================

Display:
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  COPY AUDIT RESULTS
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Copy score:        [X]/10
  Voice consistency: [X]/10

  Critical: [count]
  High: [count]
  Suggestions: [count]

  Fixes applied: [count]
  Pending your approval: [count]
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Save findings to VOICE.md (update terminology map)
and to test-session.md.
Update HEALTH.md with copy score.
