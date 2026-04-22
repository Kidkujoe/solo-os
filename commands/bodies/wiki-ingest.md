---
name: wiki-ingest
description: Process any source file from raw/ into the Obsidian wiki. Reads the source, discusses key takeaways, writes and updates wiki pages, detects contradictions, tracks confidence and logs everything. Handles markdown, JSON rules files and plain text. Do one source at a time for best results.
allowed-tools: Bash, WebSearch
---
Run the RESOLVER first.

Then read:
- `$OBSIDIAN_VAULT/schema/WIKI_SCHEMA.md` — governance rules for every wiki operation
- `$OBSIDIAN_VAULT/wiki/index.md` — current wiki state

$ARGUMENTS is the filename in `raw/` to process.

If $ARGUMENTS is empty:
- List every file in `$OBSIDIAN_VAULT/raw/` that does not already
  appear in `$OBSIDIAN_VAULT/wiki/log.md`
- Ask which to process
- Wait for response

===========================================
INGEST PHASE 1 - IDENTIFY SOURCE TYPE
===========================================

Read the source file completely. Identify its type:

**RULES FILE** (`.json` or structured `.md` inside `raw/rules/`)
Contains explicit rules, standards or guidelines.
Treatment: Compile each rule into a dedicated `Rules-[Domain].md` page.
Rules are non-negotiable standards. Every future audit checks against
them.

**RESEARCH ARTICLE**
An article about the market, competitors or users.
Treatment: Extract key claims, identify entities mentioned, update
relevant entity and concept pages.

**CUSTOMER CALL NOTES**
Notes from a real user conversation.
Treatment: Extract pain points in their exact words, update concept
pages, add to customer language bank for `/copyai`.

**COMPETITOR RESEARCH**
Information about a specific competitor.
Treatment: Update or create the competitor entity page in `wiki/`.
Note: this is separate from `Research/Competitors/` which plugin
commands write to. Do not confuse them.

**PERSONAL THINKING**
Your own notes about the product.
Treatment: Treat as high-signal context. Extract strategic implications.
Update synthesis pages.

**TRANSCRIPT**
A podcast or video transcript.
Treatment: Same as research article, but note spoken language may be
less precise than written sources.

===========================================
INGEST PHASE 2 - JSON RULES FILES
===========================================

JSON files in `raw/rules/` get special handling because they are
structured.

Read every key-value pair. For each rule, create or update a Rules
page in `wiki/`:

`Rules-[Domain].md`

Format each rule as:

```
## Rule: [rule name]
Statement: [the rule in plain English]
Applies to: [what this governs]
Violation looks like: [example]
Correct looks like: [example]
Source: [raw/rules/filename.json]
Confidence: HIGH
(Explicit rule from human = highest possible confidence)
```

After compiling all rules:
- Update `wiki/index.md`
- Append to `wiki/log.md`

Display:

  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  RULES FILE INGESTED
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Source: [filename]
  Rules extracted: [count]
  Wiki pages created or updated: [list]

  These rules will now be enforced in:
  /design   — design consistency checks
  /copy     — brand voice checks
  /autoloop — autonomous improvements
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

===========================================
INGEST PHASE 3 - DISCUSSION STEP
===========================================

For all non-rules sources, this step is **mandatory**. Do not skip.

Display:

  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  SOURCE READ: [filename]
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Type: [source type]
  Credibility: [HIGH/MEDIUM/LOW/UNKNOWN]
  Date: [if identifiable]

  KEY TAKEAWAYS:
  1. [Most important finding]
     Confidence: [level and why]

  2. [Second finding]
     Confidence: [level and why]

  3. [Third finding if relevant]
     Confidence: [level and why]

  WIKI PAGES THAT WILL BE UPDATED:
  [List existing pages this touches]

  NEW PAGES NEEDED:
  [New entities or concepts to create]

  CONTRADICTIONS DETECTED:
  [Any conflict with existing wiki claims]

  KNOWLEDGE GAPS REVEALED:
  [What this source shows we do not know yet — what to look for next]

  Does this match your understanding?
  Type yes to write to wiki
  Type correct [what] to adjust first
  Type skip [number] to exclude a takeaway
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Wait for response. Do not write anything to the wiki until confirmed.

===========================================
INGEST PHASE 4 - WRITE TO WIKI
===========================================

After confirmation, write to `wiki/`.

Rules:
- Every claim must cite its source (`[Source: raw/folder/filename.md]`)
- Every page must have a confidence level
- Never overwrite `MANUALLY CORRECTED` sections
- Update existing pages rather than creating duplicates
- Update `wiki/index.md` after writing
- Append to `wiki/log.md`

Show each page written:

  WIKI UPDATED: [page name]
  Action: CREATED / UPDATED
  Added: [what was written]
  Confidence: [level]
  Source: [raw/folder/filename]

Contradictions:
- If a new claim conflicts with an existing one, do **not** silently
  overwrite. Append both to `wiki/contradictions.md`, show both with
  their sources, and ask the user to resolve.

===========================================
INGEST PHASE 5 - KNOWLEDGE GAP REPORT
===========================================

After every ingest, report what the source revealed that the wiki
does not yet cover.

  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  KNOWLEDGE GAPS IDENTIFIED
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Topics mentioned with no wiki page:

  [Topic]: mentioned [count] times
  Suggested source to find:
  [Specific type of source]

  Questions this source raised:
  [Questions the wiki cannot yet answer]
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
