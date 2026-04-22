---
name: wiki-query
description: Ask any question and get an answer synthesised from the compiled wiki with full citations. Every useful answer is automatically filed back as a Synthesis page so explorations compound in the knowledge base.
allowed-tools: Bash
---
Run the RESOLVER first.

Then read:
- `$OBSIDIAN_VAULT/schema/WIKI_SCHEMA.md` — governance rules
- `$OBSIDIAN_VAULT/wiki/index.md` — master catalog of wiki pages

$ARGUMENTS is the question.

===========================================
QUERY PHASE 1 - FIND RELEVANT PAGES
===========================================

Read `wiki/index.md`. Identify every page relevant to answering the
question. Read only those pages. Do not read `raw/` sources unless a
specific claim needs verification.

===========================================
QUERY PHASE 2 - SYNTHESISE THE ANSWER
===========================================

Build the answer from wiki pages only. For every claim, state the
confidence level and cite the wiki page. If synthesising across
multiple pages, show the reasoning chain explicitly.

Display:

  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  WIKI QUERY: [question]
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  ANSWER:
  [Plain English answer]

  EVIDENCE CHAIN:
  Claim: [specific claim]
  Confidence: [level]
  Wiki page: [page name]
  Raw source behind it: [raw/ file]

  [Repeat for each claim]

  WHAT THE WIKI DOES NOT YET KNOW:
  [Parts the wiki cannot fully answer]

  To fill this gap add these source types to raw/:
  [Specific suggestions]
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

===========================================
QUERY PHASE 3 - FILE BACK INTO WIKI
===========================================

**CRITICAL — do not skip this step.**

From the Karpathy LLM Wiki gist: good answers can be filed back into
the wiki as new pages. A comparison you asked for, an analysis, a
connection you discovered — these are valuable and should not
disappear into chat history. Explorations compound in the knowledge
base just like ingested sources do.

If the answer synthesised across multiple wiki pages and produced a
non-obvious connection or conclusion, ask:

  This answer synthesised across [count] wiki pages.

  Worth filing as a Synthesis page?
  Proposed title: Synthesis-[topic].md

  Type yes / no / rename [title]

If yes:
- Create `Synthesis-[topic].md` with: conclusion, evidence chain,
  confidence level, contradicting evidence, "Created from query: [Q]",
  date
- Update `wiki/index.md`
- Append to `wiki/log.md`:
  `## [YYYY-MM-DD] synthesis | [topic] (from query: [question])`
