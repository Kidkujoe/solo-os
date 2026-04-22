---
name: seo
description: Full SEO audit covering on-page basics, semantic HTML, technical SEO, structured data opportunities and Core Web Vitals.
allowed-tools: Bash, mcp__chrome-devtools__*
---

===========================================
RESOLVER — RUN THIS BEFORE ANYTHING ELSE
===========================================

STEP R1 - ESTABLISH PROJECT IDENTITY:
Run: pwd to get the absolute project path.
Take the folder basename. Add a 6-character hash of the full path
(try md5sum first, fall back to shasum). Format as:
PROJECT_ID = [basename]-[6char-hash]
PROJECT_CONTEXT = ~/.claude/context/projects/[PROJECT_ID]/

If current directory is not a project directory (is home, is
~/.claude, has no code files), display PROJECT NOT DETECTED
warning and stop. Ask user to cd into their project folder.

STEP R2 - CREATE PROJECT FOLDERS:
mkdir -p $PROJECT_CONTEXT
mkdir -p $PROJECT_CONTEXT/atlas
mkdir -p $PROJECT_CONTEXT/screenshots
mkdir -p $PROJECT_CONTEXT/reports

STEP R3 - ESTABLISH ALL FILE PATHS:
SESSION_FILE      = $PROJECT_CONTEXT/test-session.md
DATA_FILE         = $PROJECT_CONTEXT/test-data.json
AGENT_STATE       = $PROJECT_CONTEXT/agent-state.json
AGENT_COORD       = $PROJECT_CONTEXT/agent-coordination.json
EDGE_CASES        = $PROJECT_CONTEXT/edge-cases.md
COPYAI_FILE       = $PROJECT_CONTEXT/COPYAI.md
COMPASS_FILE      = $PROJECT_CONTEXT/COMPASS.md
EMPATHY_FILE      = $PROJECT_CONTEXT/EMPATHY.md
SCREENSHOTS       = $PROJECT_CONTEXT/screenshots
REPORTS           = $PROJECT_CONTEXT/reports
TEST_REPORT       = $REPORTS/test-report.html
COPY_REPORT       = $REPORTS/copy-report.html
COMPASS_REPORT    = $REPORTS/compass-report.html
EMPATHY_REPORT    = $REPORTS/empathy-report.html
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

Global resources (shared across all projects):
REPORT_TEMPLATE    = ~/.claude/context/report-template.html
GLOBAL_ACCOUNTS    = ~/.claude/context/test-accounts-global.md
DEVELOPER_PROFILE  = ~/.claude/context/DEVELOPER_PROFILE.md

STEP R4 - VERIFY ISOLATION:
Every file path used in this command must either start with
$PROJECT_CONTEXT or be one of the approved global resources listed
below.

Approved globals inside ~/.claude/:
  ~/.claude/context/report-template.html      (shared HTML template)
  ~/.claude/context/test-accounts-global.md   (keyed test accounts)
  ~/.claude/context/DEVELOPER_PROFILE.md      (cross-project developer profile, v2.4.0+)
  ~/.claude/context/projects/                 (parent of all project folders)
  ~/.claude/commands/                         (the commands themselves)

Approved globals inside ~/Documents/SecondBrain/ (v2.5.0+ Obsidian vault):
  $OBSIDIAN_VAULT and anything under it, including raw/, wiki/,
  schema/, program/, Products/, Research/, Patterns/, Inbox/,
  Templates/, Developer/. Resolved dynamically in STEP R8.

If any path outside these is referenced, stop and report.

STEP R5 - DISPLAY CONTEXT CONFIRMATION:
Display a one-line confirmation so user can see which project:
  Project: [PROJECT_NAME] ([PROJECT_ID])

STEP R6 - CHECK FOR CONTAMINATION:
If SESSION_FILE exists, check its first line for:
  # Project: [project-id]
If the stamp does not match PROJECT_ID, display CONTAMINATION DETECTED
warning and ask user: 1) archive and start fresh, 2) show contents,
3) stop. Wait for response.

STEP R7 - STAMP NEW FILES:
When creating any new context file, write as first line:
  # Project: [PROJECT_ID]
  # Path: [PROJECT_PATH]
  # Created: [timestamp]

STEP R8 - KNOWLEDGE BRIDGE INITIALIZATION (v2.3.0+):
Read $STRATEGY_MD if it exists and extract the line:
  Obsidian vault: [path]
If found set OBSIDIAN_VAULT to that path.
If not found default to: OBSIDIAN_VAULT="$HOME/Documents/SecondBrain"

Derive these paths:
  OBSIDIAN_PRODUCTS="$OBSIDIAN_VAULT/Products"
  OBSIDIAN_RESEARCH="$OBSIDIAN_VAULT/Research"
  OBSIDIAN_PATTERNS="$OBSIDIAN_VAULT/Patterns"
  OBSIDIAN_INBOX="$OBSIDIAN_VAULT/Inbox"
  OBSIDIAN_PRODUCT_DIR="$OBSIDIAN_PRODUCTS/$PROJECT_NAME"

Wiki-layer paths (v2.5.0+):
  OBSIDIAN_RAW="$OBSIDIAN_VAULT/raw"
  OBSIDIAN_WIKI="$OBSIDIAN_VAULT/wiki"
  OBSIDIAN_SCHEMA="$OBSIDIAN_VAULT/schema"
  OBSIDIAN_PROGRAM="$OBSIDIAN_VAULT/program"
  OBSIDIAN_PROGRAM_FILE="$OBSIDIAN_PROGRAM/$PROJECT_NAME.md"

Check vault exists. If not found display:
  Obsidian vault not found at $OBSIDIAN_VAULT
  Knowledge Bridge disabled for this run.
  Set up Obsidian to enable. Continuing without it.
Then set OBSIDIAN_BRIDGE=off and skip all bridge calls.

If vault exists but $OBSIDIAN_PRODUCT_DIR is missing, create:
  mkdir -p "$OBSIDIAN_PRODUCT_DIR"/{Features,Decisions,Insights,Reviews}

Set OBSIDIAN_BRIDGE=on. Commands should call read/write functions
defined in RESOLVER.md § KNOWLEDGE_BRIDGE at their specified hooks.

END OF RESOLVER — continue with command logic below
===========================================

You are running a full SEO audit for: $ARGUMENTS

Read $PRODUCT_MD silently if it exists
Read $SEO_MD
Read $VOICE_MD if it exists
Read $HEALTH_MD if it exists

===========================================
PHASE 1 - PAGE INVENTORY
===========================================

Build a complete map of every page in the application.

For each page read:
- The file that renders it
- Current page title (or MISSING)
- Current meta description (or MISSING)
- H1 and heading structure
- Canonical URL (or MISSING)
- Should be indexed or not
- Open Graph tags (or MISSING)
- Any existing schema markup

Classify each page:
SHOULD BE INDEXED: marketing, landing, pricing, blog, features, about, homepage
SHOULD NOT BE INDEXED: dashboard, settings, admin, checkout, auth pages

Flag: pages that should be indexed but have noindex,
pages that should NOT be indexed but have no noindex directive.

===========================================
PHASE 2 - ON-PAGE BASICS
===========================================

For every indexable page:

CHECK 1: PAGE TITLES
- Is title set? Unique? 50-60 characters?
- Includes primary keyword? Brand name?
Flag missing or poor titles with suggested rewrites.

CHECK 2: META DESCRIPTIONS
- Is description set? Unique? 120-158 characters?
- Accurately describes page? Includes soft CTA?
- Sounds human and matches brand voice?

CHECK 3: H1 STRUCTURE
- Exactly one H1 per page?
- H1 descriptive and relevant?
- Heading hierarchy correct (H1 > H2 > H3, no skips)?

CHECK 4: OPEN GRAPH TAGS
For shareable pages:
- og:title, og:description, og:image (1200x630+), og:type set?

CHECK 5: CANONICAL URLS
- Canonical set on each page?
- Points to correct URL?
- No pages accessible at multiple URLs without canonical?

===========================================
PHASE 3 - SEMANTIC HTML AUDIT
===========================================

Read rendered HTML via browser.

CHECK 6: SEMANTIC STRUCTURE
- nav for navigation? main for content? article for articles?
- section used meaningfully? footer for footer?
- Important elements in divs that should be semantic?

CHECK 7: IMAGE ALT TEXT
Every image: has alt? descriptive? not filename? not keyword-stuffed?
Decorative images have alt=""?

CHECK 8: LINK TEXT QUALITY
Flag: "Click here", "Read more" (no context), bare URLs, generic labels.
Suggest descriptive rewrites.

===========================================
PHASE 4 - TECHNICAL SEO
===========================================

CHECK 9: SITEMAP
- sitemap.xml exists and accessible?
- Includes all indexable pages, excludes non-indexable?
- Referenced in robots.txt?
If missing: offer to create one.

CHECK 10: ROBOTS.TXT
- Exists and accessible?
- Has Sitemap reference?
- Dashboard/admin paths blocked?
- No important public pages blocked?
If missing: offer to create one.

CHECK 11: INTERNAL LINKS
- Any broken internal links?
- Important pages linked from other pages?
- Homepage linked from every page?
- Any orphan pages with no internal links?

CHECK 12: REDIRECTS
- Any redirect chains longer than one hop?
- Any redirect loops?

===========================================
PHASE 5 - STRUCTURED DATA
===========================================

CHECK 13: SCHEMA OPPORTUNITIES
Based on page types found:

Homepage → Organisation schema
Pricing → Product/Offer schema
Blog/Articles → Article schema
FAQ section → FAQPage schema
Team/About → Person schema

For each opportunity show:
  STRUCTURED DATA OPPORTUNITY
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Page: [path]
  Type: [schema type]
  Why: [plain English benefit]
  Shall I generate the markup?
  Type yes / skip
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

If yes: generate valid JSON-LD and offer to inject it.

===========================================
PHASE 6 - PERFORMANCE AS SEO SIGNAL
===========================================

CHECK 14: CORE WEB VITALS
Do not re-run performance tests.
Read from HEALTH.md pillars audit if available.

Display SEO framing of performance findings:
  PERFORMANCE AS SEO SIGNAL
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Google uses Core Web Vitals as a ranking factor.
  Images: [finding] → affects LCP
  Bundle size: [finding] → affects INP
  Run /pillars for detailed recommendations.
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

===========================================
PHASE 7 - KEYWORD CONSISTENCY
===========================================

CHECK 15: KEYWORD ALIGNMENT
Read PRODUCT.md and marketing copy.
- What keywords does marketing target?
- Are those keywords used in-product?
- Any keywords on landing page that disappear inside the app?
Flag major disconnects.

===========================================
PHASE 8 - RESULTS AND SAVE
===========================================

Display:
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  SEO AUDIT RESULTS
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  SEO score: [X]/10

  Page Titles:       [score] [icon]
  Meta Descriptions: [score] [icon]
  Heading Structure: [score] [icon]
  Image Alt Text:    [score] [icon]
  Open Graph:        [score] [icon]
  Sitemap:           [score] [icon]
  Robots.txt:        [score] [icon]
  Structured Data:   [score] [icon]
  Internal Links:    [score] [icon]

  Critical: [count]
  High: [count]
  Opportunities: [count]

  Fixes applied: [count]
  Pending approval: [count]
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Save full inventory to $SEO_MD
Update HEALTH.md with SEO score and timestamp.
