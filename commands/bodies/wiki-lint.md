---
name: wiki-lint
description: Health check on the wiki. Finds structural issues, contradictions, stale claims and concepts without pages. Actively identifies knowledge gaps and suggests sources to fill them. The system reports what it does not know and what to look for next.
allowed-tools: Bash
---
Run the RESOLVER first.

Then read:
- `$OBSIDIAN_VAULT/schema/WIKI_SCHEMA.md` — governance rules

===========================================
LINT PHASE 1 - STRUCTURAL CHECK
===========================================

**ORPHAN PAGES** — pages with no inbound links. Isolated knowledge
islands.

**BROKEN LINKS** — wikilinks pointing to pages that do not exist.

**UNSOURCED CLAIMS** — claims with no `Source:` citation. Cannot be
verified.

**MISSING INDEX ENTRIES** — pages not listed in `wiki/index.md`.

===========================================
LINT PHASE 2 - QUALITY CHECK
===========================================

**CONTRADICTIONS** — find claims that conflict across pages. Show
both with their sources. Ask for resolution. Log to
`wiki/contradictions.md`.

**STALE CLAIMS** — claims from sources older than 12 months. Flag:
`VERIFY — source over 12 months old`. Suggest a newer source to
confirm or update.

**CONFIDENCE DRIFT** — synthesis pages claiming higher confidence
than the pages they are based on. Confidence cannot increase through
abstraction. Flag and correct.

===========================================
LINT PHASE 3 - GAP IDENTIFICATION
===========================================

From the Karpathy LLM Wiki gist: the LLM is good at suggesting new
questions to investigate and new sources to look for. This keeps the
wiki healthy as it grows.

**CONCEPTS WITHOUT PAGES** — find concepts mentioned 3 or more times
across wiki pages with no dedicated page.

**QUESTIONS THE WIKI RAISES** — read the wiki and identify questions
it implies but cannot answer. These are worth surfacing explicitly.

**SOURCES THE WIKI NEEDS** — for each gap, suggest a specific type of
source to fill it. Not generic research suggestions. **This type** of
source from **this platform** about **this specific topic**.

===========================================
LINT PHASE 4 - DISPLAY REPORT
===========================================

  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  WIKI HEALTH REPORT
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Total wiki pages: [count]
  Total raw sources: [count]
  Last ingest: [date]

  STRUCTURAL ISSUES:
  Orphan pages: [count]
  Broken links: [count]
  Unsourced claims: [count]
  Missing index entries: [count]

  QUALITY ISSUES:
  Contradictions: [count]
  Stale claims: [count]
  Confidence drift: [count]

  KNOWLEDGE GAPS:
  Concepts without pages: [list]

  WHAT THE WIKI DOES NOT KNOW:
  [Most important gaps]

  SOURCES TO FIND:
  [Specific suggestions per gap]

  QUESTIONS WORTH ASKING:
  [Questions current wiki raises but cannot answer]

  Overall health: CLEAN / GOOD / NEEDS ATTENTION / DEGRADED
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Append to `wiki/log.md`:
`## [YYYY-MM-DD] lint | [overall health] — [structural + quality issue counts]`
