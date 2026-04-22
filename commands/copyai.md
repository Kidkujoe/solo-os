---
name: copyai
description: Intelligent copy strategy and rewriting skill. Analyses your product, researches competitors, sources real customer language and pain points from Reddit, review sites and social platforms, then produces a data-driven copy strategy and full rewrites with evidence for every change.
allowed-tools: Bash, mcp__chrome-devtools__*
---


===========================================
RESOLVER — RUN THIS BEFORE ANYTHING ELSE
===========================================

STEP R1 - ESTABLISH PROJECT IDENTITY:
Run `pwd` to get the absolute project path.
Derive PROJECT_ID = [basename]-[6char hash of full path] using md5sum
(fall back to shasum if unavailable).
Set PROJECT_CONTEXT = ~/.claude/context/projects/[PROJECT_ID]/

If current directory is NOT a project directory (is home, is ~/.claude,
no code files present), display PROJECT NOT DETECTED warning and stop.
Ask user to cd into their project folder.

STEP R2 - CREATE PROJECT FOLDERS if missing:
mkdir -p $PROJECT_CONTEXT/atlas $PROJECT_CONTEXT/screenshots $PROJECT_CONTEXT/reports

STEP R3 - ALL PATHS (use these variables, never hardcode):
SESSION_FILE      = $PROJECT_CONTEXT/test-session.md
DATA_FILE         = $PROJECT_CONTEXT/test-data.json
AGENT_STATE       = $PROJECT_CONTEXT/agent-state.json
AGENT_COORD       = $PROJECT_CONTEXT/agent-coordination.json
EDGE_CASES        = $PROJECT_CONTEXT/edge-cases.md
COPYAI_FILE       = $PROJECT_CONTEXT/COPYAI.md
COMPASS_FILE      = $PROJECT_CONTEXT/COMPASS.md
EMPATHY_FILE      = $PROJECT_CONTEXT/EMPATHY.md
SCREENSHOTS       = $PROJECT_CONTEXT/screenshots
TEST_REPORT       = $PROJECT_CONTEXT/reports/test-report.html
COPY_REPORT       = $PROJECT_CONTEXT/reports/copy-report.html
COMPASS_REPORT    = $PROJECT_CONTEXT/reports/compass-report.html
EMPATHY_REPORT    = $PROJECT_CONTEXT/reports/empathy-report.html
ATLAS             = $PROJECT_CONTEXT/atlas
PRODUCT_MD        = $ATLAS/PRODUCT.md
DESIGN_MD         = $ATLAS/DESIGN.md
DECISIONS_MD      = $ATLAS/DECISIONS.md
DEPENDENCIES_MD   = $ATLAS/DEPENDENCIES.md
REGRESSIONS_MD    = $ATLAS/REGRESSIONS.md
HEALTH_MD         = $ATLAS/HEALTH.md
STRATEGY_MD       = $ATLAS/STRATEGY.md
VOICE_MD          = $ATLAS/VOICE.md
SEO_MD            = $ATLAS/SEO.md

Approved global resources (shared across all projects):
REPORT_TEMPLATE   = $REPORT_TEMPLATE
GLOBAL_ACCOUNTS   = ~/.claude/context/test-accounts-global.md

STEP R4 - VERIFY ISOLATION:
Every path used must start with $PROJECT_CONTEXT or be one of the two
approved globals. Any other ~/.claude/context/ path is a violation.

STEP R5 - DISPLAY CONFIRMATION (one line):
  Project: [PROJECT_NAME] ([PROJECT_ID])

STEP R6 - CONTAMINATION CHECK:
If $SESSION_FILE exists, check its first line for `# Project: [id]`.
If stamp does not match PROJECT_ID, display CONTAMINATION DETECTED
warning with options: archive + start fresh / show contents / stop.
Wait for user response.

STEP R7 - STAMP NEW FILES:
When creating any new context file, write as first line:
  # Project: [PROJECT_ID]
  # Path: [PROJECT_PATH]
  # Created: [timestamp]

TEST-ACCOUNTS USAGE:
When reading accounts, read $GLOBAL_ACCOUNTS and filter to the section
matching PROJECT_ID. Never read another project's section.
When writing accounts, update the $PROJECT_ID section only.

END OF RESOLVER — command-specific logic follows
===========================================

You are a world-class conversion copywriter and brand strategist.
You never write copy from gut instinct. Every word you recommend
is backed by evidence from real customers talking about real
problems in their own language.

Read $PRODUCT_MD silently if it exists
Read $VOICE_MD if it exists
Read CLAUDE.md in the project root

$ARGUMENTS can specify a focus area. If empty run the full audit.

===========================================
CORE PRINCIPLE - PATTERN OVER ANECDOTE
===========================================

A single review, one Reddit comment or one tweet is not evidence.
It is an anecdote. An anecdote tells you someone had an experience.
A pattern tells you enough people had the same experience that it
is shaping behaviour.

This skill only acts on patterns. Nothing is presented as actionable
unless it meets the signal thresholds defined below.

SIGNAL THRESHOLDS:

THRESHOLD 1 - VOLUME:
Same sentiment appears in at least 5 separate instances.
5+ = LOW confidence. 10+ = MEDIUM. 20+ = HIGH.

THRESHOLD 2 - CROSS-PLATFORM:
Pattern appears on at least 2 different platforms.
Cross-platform patterns have higher signal because they are not
influenced by a single community's culture or bias.

THRESHOLD 3 - BEHAVIOURAL CONSEQUENCE:
Pattern associated with specific user behaviour, not just opinion.
High-signal behaviours: cancelled, switching, seeking alternative,
recommending against, cannot complete core task, paying but not using,
built a workaround. Opinions without consequence do not meet threshold.

THRESHOLD 4 - RECENCY:
Last 12 months = full weight. 12-24 months = half weight and flagged.
Older than 24 months = historical context only, cannot drive decisions
without corroborating recent evidence.

CONFIDENCE SCORING:
Start at 0. +1 per instance above minimum 5. +3 if 3+ platforms.
+5 if behavioural consequence in 20%+ of instances. +3 if all recent.
-2 if mostly single platform. -3 if mostly older than 12 months.

0-5: WEAK — do not act on this
6-10: MODERATE — note with caution
11-15: STRONG — actionable insight
16+: VERY STRONG — core copy opportunity

===========================================
PHASE 1 - PRODUCT INTELLIGENCE
===========================================

Read the entire codebase focusing on every user-facing string:
landing page, marketing, onboarding, feature names, pricing,
error messages, empty states, email templates, blog content.

Build and display a PRODUCT INTELLIGENCE BRIEF:

  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  PRODUCT INTELLIGENCE BRIEF
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  WHAT THIS PRODUCT DOES: [one sentence]
  PRIMARY USER: [who pays and why]
  SECONDARY USER: [who uses it daily]
  CORE VALUE PROPOSITION DETECTED: [current promise]
  KEY FEATURES: [list with current descriptions]
  CURRENT COPY ASSESSMENT: [honest strengths and weaknesses]
  BUSINESS MODEL: [pricing model from code]
  STAGE: [pre-launch/early/growing/scaling]

  Is this accurate?
  Type yes to continue / correct to fix
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Wait for confirmation. Save confirmed brief to PRODUCT.md.

===========================================
PHASE 2 - COMPETITOR IDENTIFICATION
===========================================

Use web search to find direct competitors, indirect competitors,
and emerging alternatives.

Search: "[category] alternatives", "[category] competitors",
"best [category] tools", "[category] vs", Product Hunt category,
G2/Capterra category pages, Reddit recommendations.

Display findings and ask which to research:
  Type all / [specific names] / add [name]

Wait for confirmation.

===========================================
PHASE 3 - COMPETITIVE INTELLIGENCE
===========================================

For each confirmed competitor:

STEP A - READ THEIR POSITIONING:
Use web search to read their homepage headline, pricing copy,
feature descriptions, about page, onboarding language.
Extract: value proposition, emotional hook, target user, pain
points they lead with, words they repeat, what they promise
that you don't, what you offer that they don't.

STEP B - FIND THEIR WEAKNESSES (with collection targets):
Search real customer complaints across multiple platforms.
Do not evaluate during collection. Gather raw material first.

Minimum collection targets per platform:
- Reddit: minimum 15 posts/comments before moving on
- G2 or Capterra: minimum 20 reviews before moving on
- Product Hunt: minimum 10 comments before moving on
- Twitter/X: minimum 10 posts before moving on
- Other platforms: minimum 5 sources each before moving on

If a platform returns fewer than minimum, try 3 alternative search
terms before accepting low results. Note low results explicitly.

Reddit: "[competitor] problems", "[competitor] frustrating",
"switched from [competitor]", "leaving [competitor]",
"[competitor] not worth"
G2: Focus on 1-3 star reviews, recurring themes, exact language.
Capterra: Same focus on negative reviews.
Product Hunt: Read comments not just votes.
Trustpilot: If applicable.
Twitter/X: "[competitor] frustrated", "[competitor] switching"
YouTube: "[competitor] review" video comments.
Hacker News: "site:news.ycombinator.com [competitor]"
Indie Hackers: "[competitor]"

TAG EVERY DATA POINT collected with:
- Source: [platform]
- Date: [when posted]
- Type: complaint / praise / question / feature request /
  migration signal / comparison / workaround
- Sentiment: frustrated / confused / satisfied / neutral / angry / relieved
- Behaviour: cancelled / switching / seeking alternative / staying /
  recommending / warning others / building workaround / not using
- Topic: [specific topic]
- Key phrase: [most quotable part in user's own words]
- Confidence: HIGH if behaviour present / MEDIUM if strong sentiment /
  LOW if opinion only

STEP C - IDENTIFY MIGRATION TRIGGERS:
Deal breakers (immediate cancellation), slow burns (frustration
buildup), better alternative triggers (what they searched for).

===========================================
PHASE 4 - VOICE OF CUSTOMER RESEARCH
===========================================

Search for how real users talk about the PROBLEM your product
solves. Not your product. The problem.

Apply same collection targets and tagging as Phase 3.

Reddit: "how do I [problem]", "struggling with [problem]",
"[problem] is killing me", "[problem] workflow"
Search relevant subreddits for the industry.
Quora: Most viewed questions about the problem category.
Stack Overflow: Questions revealing pain points (if technical).
Twitter/X: "[problem] anyone", "[problem] so annoying"
YouTube: Tutorial video comments where people actively struggle.

Tag and collect as in Phase 3.

===========================================
PHASE 4B - CLUSTERING AND FILTERING
===========================================

After all collection is complete:

CLUSTER: Group all tagged data into clusters of similar topics.
A cluster is 3+ tagged pieces sharing the same topic across any
combination of platforms.

For each cluster calculate:
- Total instances
- Platforms represented
- Behaviour signals present (count and type)
- Recency (most recent and oldest)
- Confidence score (using the formula above)

FILTER: Discard any cluster with:
- Fewer than 5 instances total
- Confidence score below 6
- Only one platform unless 15+ instances with behavioural consequence

Save discarded clusters to COPYAI.md under "Emerging Signals to Watch"
— these may become actionable with more data in future runs.

===========================================
PHASE 5 - COPY INTELLIGENCE SYNTHESIS
===========================================

Display patterns ranked by signal strength:

  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  COPY INTELLIGENCE SYNTHESIS
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  RESEARCH COMPLETED
  Total data points collected: [count]
  Platforms: [count] — [list]
  Date range: [oldest to newest]
  Patterns above threshold: [count]
  Patterns discarded (weak signal): [count]
  Emerging signals to watch: [count]
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

For each confirmed pattern display:

  PATTERN: [name]
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Signal: [WEAK/MODERATE/STRONG/VERY STRONG]
  Score: [X]/20
  Instances: [count] across [count] platforms
  Behaviour signals: [count] — [types]
  Trend: Growing (60%+ from last 6mo) /
         Stable / Declining (60%+ older than 12mo)

  WHAT THIS PATTERN SHOWS: [one paragraph]

  REPRESENTATIVE QUOTES (3-5 from different platforms):
  "[exact words]"
  Platform: [name] | Date: [month year]
  Behaviour: [what this person did]

  COPY IMPLICATION: [specific action for the copy]
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  WHAT THE DATA DOES NOT SHOW:
  Topics with insufficient data: [list]
  Platforms with low response: [list with reason]
  Recency gaps: [patterns needing verification]
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

THE COPY STRATEGY (evidence-anchored):

  POSITIONING: [statement]
  Supported by: Pattern [name] [score]/20, Pattern [name] [score]/20

  PRIMARY MESSAGE: [message]
  Evidence: Pattern [name] — [count] users across [count] platforms
  described [thing] before switching. Highest-signal pain point.

  WHAT WE ARE NOT SAYING AND WHY:
  [Approaches the data does not support, with reason]

  EMOTIONAL HOOK: [emotion]
  Evidence: "[word]" appears [count] times. Emotion of [emotion]
  present in [count] of highest-signal instances.

  WORDS TO USE: "[phrase]" — [count] times across [count] platforms
  WORDS TO AVOID: "[word]" — does not appear in customer language

  STRATEGY CONFIDENCE:
  HIGH: 3+ STRONG/VERY STRONG signals pointing same direction
  MODERATE: Mix of STRONG and MODERATE. Test before committing.
  LOW: Mostly MODERATE. Consider refined research first.

  Does this strategy feel right?
  Type yes / adjust / evidence
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Wait for strategy confirmation before any rewrites.

===========================================
PHASE 6 - COPY REWRITES WITH PATTERN EVIDENCE
===========================================

For every copy surface:

  SURFACE: [name]
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  CURRENT: "[exact text]"

  WHY CHANGE: [reason linked to specific pattern]

  PATTERN EVIDENCE:
  Supported by [pattern name] — score [X]/20,
  [count] instances across [count] platforms.
  "[most powerful supporting quote]"
  Platform: [name] | Date: [date] | Behaviour: [action]
  + [count] more users expressed same sentiment.

  SUGGESTED: "[new copy]"

  WHY IT WORKS:
  Uses "[phrase]" found [count] times in research.
  Avoids "[current word]" not found in customer language.

  EXPECTED IMPACT:
  [HIGH/MODERATE confidence] — [specific expected improvement]

  Apply? yes / no / edit / evidence
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

If user types evidence: show ALL instances in the cluster.

Rewrite in order:
1. Landing page 2. Onboarding 3. Feature copy 4. Pricing
5. Error messages 6. Empty states 7. Email copy 8. In-app labels

After all rewrites:
  Surfaces rewritten: [count]
  Approved: [count] Pending: [count] Declined: [count]
  1. Apply all approved changes
  2. Show before/after summary
  3. Export copy document
  4. Update VOICE.md with new positioning
  5. All of the above

===========================================
PHASE 7 - APPLY AND UPDATE MEMORY
===========================================

Apply approved changes to files. Screenshot updated elements.

Update VOICE.md with new positioning, customer language,
tone, words to use/avoid, emotional hook, competitor positioning.

Save to $ATLAS/COPYAI.md:

# Copy Intelligence Report
Generated: [timestamp] | Next refresh: [6 months]

## Research Summary
Total data points: [count] | Platforms: [list] | Date range
Patterns above threshold: [count] | Discarded: [count] | Emerging: [count]

## Pattern Database
### Pattern: [name]
Score: [X]/20 | Signal: [level] | Instances: [count] | Platforms: [list]
Date range | Behaviour signals: [count and type] | Trend: [direction]
Status: Actioned/Pending/Monitoring
All collected quotes (not just samples)
Copy surfaces this informed

## Emerging Signals
### Signal: [name]
Instances: [count] | Platforms: [count]
Why below threshold | What would elevate it

## What The Data Does Not Show
[Explicit limits]

## Customer Language Bank
[phrase]: [count] instances, [count] platforms, [signal level]

## Competitor Weaknesses | Changes Made | Sources Consulted

===========================================
PHASE 8 - HTML REPORT
===========================================

Generate $COPY_REPORT and open in Chrome.

Include pattern strength indicators on every insight:
- Very strong: solid filled bar
- Strong: mostly filled
- Moderate: half filled
- Weak: not shown in report

Evidence count badges: [count] instances across [count] platforms
Trend arrows: up (Growing), right (Stable), down (Declining)

Sections:
1. Executive summary (half page, for 5-minute read)
2. EVIDENCE WALL — every representative quote as cards showing
   quote text, platform, date, behaviour signal, pattern it belongs to
3. Why customers leave competitors (intelligence cards)
4. Copy problems found (evidence cards with pattern scores)
5. The copy strategy (one page brief with evidence links)
6. Before and after (comparison cards, red removed, green added)
7. What to do next (action list, most impactful first)
8. Sources (full transparent list with dates)

===========================================
PHASE 9 - REFRESH SCHEDULE
===========================================

Add to COPYAI.md:
Next recommended refresh: [6 months from now]

Add flag to /atlas: if refresh overdue display reminder
to run /copyai to refresh copy strategy.
