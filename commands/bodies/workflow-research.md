---
name: workflow-research
description: RESEARCH workflow - add knowledge from raw/ sources into the wiki with discussion, citations and gap reports. Two steps, two approvals. Loops for multiple sources. Estimated ~2,000-4,000 per source.
allowed-tools: Bash
---

You are the RESEARCH workflow. Two steps. Two approvals. Output:
new wiki pages with citations, contradictions surfaced, and a
knowledge-gap report.

ESTIMATED COST: ~2,000 - 4,000 tokens per source.

Display upfront:

  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  RESEARCH
  Estimated: ~2,000 - 4,000 tokens per source
  Session so far: ~[count]
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

===========================================
STEP 1 OF 2 — READ AND DISCUSS
===========================================
Estimated: ~1,500 tokens

List all files in $OBSIDIAN_RAW subfolders that are NOT referenced
in $OBSIDIAN_VAULT/wiki/log.md.

If none found, display:

  No unprocessed sources found.

  Drop files into the matching folder, then run RESEARCH again:
    raw/articles/     web articles
    raw/rules/        JSON rules files
    raw/calls/        customer call notes
    raw/transcripts/  podcasts, videos
    raw/papers/       research papers
    raw/sources/      anything else

  Tokens this session: ~[total]

  Stop here.

If sources found, display:

  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  RESEARCH - [PROJECT_NAME]
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Unprocessed sources in raw/:

    1  [filename]  [type detected]  [size]
    2  [filename]  [type detected]  [size]
    ...

  Which would you like to process?
  Type the number or filename.

  APPROVAL: Pick which source.
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Wait for the user to pick. Read the selected source completely.

IF the source is a JSON rules file:
  Extract every rule automatically. No discussion step is needed.
  Jump straight to STEP 2.

OTHERWISE:
  Show a discussion summary:

    Source read: [filename]
    Type:        [source type]
    Credibility: [level]

    Key takeaways:
      1. [finding] — Confidence: [level]
      2. [finding] — Confidence: [level]
      3. [finding] — Confidence: [level]

    Wiki pages that will be UPDATED:
    [list]

    NEW pages that will be CREATED:
    [list]

    Contradictions detected:
    [any conflict with existing wiki content]

    Knowledge gaps revealed:
    [topics this source mentions that have no wiki page yet]

    APPROVAL: Confirm before writing.
      Type yes
      Type correct [what is wrong]
      Type skip [number] to skip a takeaway
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  TOKENS
  This step:    ~[estimate]
  This session: ~[running total]

===========================================
STEP 2 OF 2 — UPDATE AND SURFACE
===========================================
Estimated: ~1,000 tokens

Lessons-awareness pre-write (v3.1.0+):
  Read $OBSIDIAN_LESSONS_FILE if it exists.
  Look for prior entries under "## Confidence updates applied" or
  "## Skip patterns" that relate to this source type, rule domain,
  or wiki page the current ingest will touch.

  If relevant entries exist, display BEFORE writing to the wiki:

    ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    LESSONS FROM PREVIOUS INGESTS
    You have ingested [source type] before. Here is what was
    learned:

    [one-line summary per relevant prior lesson]

    Consider these when reviewing takeaways for this new source.
    ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  Carry these lessons forward: if a rule type was previously marked
  NOT_APPLICABLE or DISPUTED for the current project, seed the new
  wiki page's frontmatter with the same confidence_for_projects
  entry so the learning is not lost on a fresh ingest.

Write the confirmed takeaways to the wiki:
  Every claim cited to its raw source.
  Every page given a confidence level.
  Never overwrite a page marked MANUALLY CORRECTED.
  Update $OBSIDIAN_VAULT/wiki/index.md.
  Append to $OBSIDIAN_VAULT/wiki/log.md.

Show what was written:

  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  WIKI UPDATED
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Pages created:    [count]
  Pages updated:    [count]
  Rules compiled:   [count if rules file]

  KNOWLEDGE GAPS:
  Topics mentioned with no wiki page:
  [list]

  Suggested sources to find:
  [specific suggestions]

  Questions worth asking next:
  [questions this source raised]

  Flow new knowledge to plugin commands:
    New Rules pages       → /design and /copy
    Customer language     → /copyai (and EMPATHY)
    Competitor intel      → MARKET workflow
  [Show which commands now benefit from this ingest.]
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  TOKENS
  This step:    ~[estimate]
  This session: ~[running total]
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Process another source?
  Type yes to loop back to STEP 1
  Type stop to end the workflow
