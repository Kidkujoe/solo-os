---
name: seo
description: Full SEO audit covering on-page basics, semantic HTML, technical SEO, structured data opportunities and Core Web Vitals.
allowed-tools: Bash, mcp__chrome-devtools__*
---
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
