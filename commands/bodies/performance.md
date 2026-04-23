---
name: performance
description: Measures real Core Web Vitals, Lighthouse scores, bundle sizes and load times. Compares against previous runs. Stores results in HEALTH.md so /seo and /pillars reference real numbers.
allowed-tools: Bash, mcp__chrome-devtools__*
---
Read $HEALTH_MD for previous performance scores.

PHASE 1 - ENVIRONMENT CHECK:
Detect Lighthouse: `which lighthouse && lighthouse --version`.
If missing offer: `npm install -g lighthouse`.
Verify Chrome is connected via MCP (required).
Look for build output: dist/, build/, .next/, .nuxt/, out/. Offer to
build if not found.
Detect app URL from dev server (ports 3000, 3001, 5173, 8080, 4321, 5000).
Ask if none responds.

Display setup panel: Lighthouse status, Chrome status, app URL, build
output location, previous scores found.

PHASE 2 - LIGHTHOUSE AUDIT:
Run DESKTOP:
  lighthouse [URL] --output=json --output-path=$PROJECT_CONTEXT/reports/lighthouse-desktop.json --form-factor=desktop --chrome-flags="--headless"
Run MOBILE:
  lighthouse [URL] --output=json --output-path=$PROJECT_CONTEXT/reports/lighthouse-mobile.json --form-factor=mobile --chrome-flags="--headless"

Stream progress per mode: URL, elapsed time, audit steps as they run.

Extract Core Web Vitals:
- LCP: GOOD <2500ms / NEEDS IMPROVEMENT 2500-4000 / POOR >4000
- CLS: GOOD <0.1 / NEEDS IMPROVEMENT 0.1-0.25 / POOR >0.25
- INP: GOOD <200ms / NEEDS IMPROVEMENT 200-500 / POOR >500
- FCP: value in ms
- TTFB: value in ms

Extract Lighthouse scores (0-100):
Performance, Accessibility, Best Practices, SEO.

PHASE 3 - BUNDLE ANALYSIS:
For each JS file in build output: size in KB. Flag >250KB as large,
>500KB as critical. Total JS size + gzipped estimate (x0.3).
Total CSS size. Largest file.
Images: flag any >200KB, non-WebP/AVIF, missing width/height.

Display bundle panel: total JS, total CSS, largest file, oversized
files with recommendations, image issues.

PHASE 4 - COMPARE TO PREVIOUS:
Read previous scores from $HEALTH_MD. Show trend:
Metric | Previous | Current | Change
LCP, CLS, INP, Performance, Bundle JS.
Trend: IMPROVING / STABLE / DECLINING.
List regressions.

PHASE 5 - RECOMMENDATIONS:
For each failing metric show:
- Current value, target, gap
- Most likely cause based on Lighthouse diagnostics
- Specific fix (code or configuration)
- Estimated improvement

SAVE TO HEALTH.md:
Append section:
## Performance Audit
Last run: [timestamp]
URL tested: [url]
Desktop: LCP [value] [rating], CLS, INP, Performance/Accessibility/Best Practices/SEO scores
Mobile: same fields
Bundle: Total JS, Total CSS, Largest file

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
