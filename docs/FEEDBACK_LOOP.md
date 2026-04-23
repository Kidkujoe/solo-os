# Feedback Loop and Learning System

Added in v3.1.0. Closes the gap between knowledge accumulation
(the wiki) and judgement (the lessons file). Confidence connects the two.

Three behaviours:

1. **Skip detection** — repeated skips of the same finding trigger one
   question that shapes every future session.
2. **Outcome follow-ups** — BRIEF asks one question about kept EVOLVE
   experiments (14 days later) and MARKET recommendations (8 weeks later).
3. **Confidence updates** — answers flow back to per-project wiki
   confidence automatically.

All three write to the same lessons file per project at
`$OBSIDIAN_LESSONS_FILE` (= `$OBSIDIAN_PROGRAM/[PROJECT_NAME]-lessons.md`).

---

## Skip tracker

Per-project JSON at `$SKIP_TRACKER` (= `$PROJECT_CONTEXT/skip-tracker.json`).

```json
{
  "skips": [
    {
      "rule_id": "krug-007",
      "rule_name": "Navigation must be obviously clickable",
      "source": "wiki/Rules-UsabilityNavigation.md",
      "skip_count": 3,
      "last_skipped": "[timestamp]",
      "status": "pending_question | resolved | deferred_monthly",
      "resolution": null
    }
  ]
}
```

### Tracking rules

Any workflow or command that shows findings must:

- On finding display, track whether the user acts on it or moves past
  without fixing.
- Skip 1 and skip 2: record silently, increment `skip_count`.
- Skip 3: set `status` to `pending_question` and ask the question below
  on the next relevant session start (BRIEF surfaces it, or the command
  asks inline).

### The question (shown on third skip)

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
You have skipped this 3 times:

"[rule or finding name]"
Source: [wiki page]

Should I handle this differently?

A  Not relevant to [PROJECT_NAME]
   I will stop flagging this.

B  Intentional design choice
   I will remember this decision
   and never flag it again.

C  Fix it later
   Remind me monthly not every session.

D  Disagree with this rule
   Lower its priority. Show as
   suggestion not violation.

E  Keep flagging it
   I just have not got to it yet.
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

Wait for one keystroke.

### Skip resolutions

**A — Not relevant**
- Update wiki page frontmatter: add `not_applicable_for: [PROJECT_NAME]`
  with reason `flagged as not relevant by user after 3 skips`.
- Set `confidence_for_projects.[PROJECT_NAME]: MEDIUM` with a context note.
- Append to lessons: `## [date] - Rule marked not applicable`.
- Never flag this finding again for this project.

**B — Intentional design choice**
- Append to `$DECISIONS_FILE`:
  `## [date] - Intentional design choice` with finding + decision.
- Append to lessons: `## [date] - Intentional choice recorded`.
- Never flag again. If it reappears in an audit, show it as
  `Skipped: [rule] - intentional design choice confirmed [date]`.

**C — Fix later**
- Append to lessons: `## [date] - Deferred finding`.
- Set skip-tracker status to `deferred_monthly`.
- Do not flag in every session. Surface once per month in BRIEF:
  `DEFERRED ITEMS: [rule] - deferred [X] days ago. Still want to fix?
  Type yes / no.`

**D — Disagree with rule**
- Update wiki page confidence for this project:
  - First dispute: HIGH → MEDIUM
  - Second: MEDIUM → LOW
  - Third: LOW → DISPUTED
- Add wiki note: `Disputed [count] times in [PROJECT_NAME] context.
  Apply as suggestion not violation.`
- Append to lessons: `## [date] - Rule disputed`.
- Enforcement changes per level (see below).

**E — Keep flagging**
- Reset `skip_count` to 0. Ask again after 3 more skips.

---

## Confidence enforcement levels (per project)

Confidence is project-specific, stored in the wiki page frontmatter
as `confidence_for_projects.[PROJECT_NAME]`. Read this, not the
global `confidence`, when enforcing rules against a project.

| Level          | Behaviour                                                        |
|----------------|------------------------------------------------------------------|
| HIGH           | Enforced strictly. Shown as VIOLATION. SHIP must fix before go.  |
| MEDIUM         | Shown as SUGGESTION. Not blocking. Noted in report.              |
| LOW            | Shown only in full audits. Prefixed `Low priority for [PROJECT]`.|
| DISPUTED       | Not enforced by EVOLVE autonomously. Silent unless requested.    |
| NOT_APPLICABLE | Never shown.                                                     |

---

## Wiki frontmatter format

```yaml
---
confidence: HIGH                      # global default
confidence_for_projects:
  RSVPie: MEDIUM
  HeroDocs: HIGH
disputes: 0
not_applicable_for: []
last_reviewed: [date]
skip_count_RSVPie: 3
resolution_RSVPie: not_applicable
---
```

---

## Outcome follow-ups (BRIEF)

### EVOLVE — 14 days after KEEP

Trigger: any entry in the experiment log marked KEEP whose
timestamp is ≥ 14 days old and has no follow-up recorded yet.

BRIEF surfaces once:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EVOLVE FOLLOW-UP
14 days ago this was kept:

[experiment description]
[metric]: [before] -> [after]

Did this actually improve things in practice?

A  Yes - noticeable improvement
B  Unclear - cannot tell yet
C  No - metric improved but no real difference felt
D  No - caused a different problem
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

- **A**: Lessons entry `EVOLVE outcome confirmed`. Create
  `Synthesis-Evolve-[topic].md` with confidence HIGH.
- **B**: Lessons entry `outcome unclear`. Ask again in 30 days.
- **C**: Lessons entry `metric unreliable`. Update program file
  with a WARNING note on that metric. Create
  `Synthesis-MetricReliability-[PROJECT_NAME].md`.
- **D**: Lessons entry `harmful outcome`. Surface **URGENT**
  block in BRIEF immediately next run with revert options.

### MARKET — 8 weeks after priority-1 recommendation

Trigger: MARKET recommendation classified priority 1 whose
recommendation date is ≥ 8 weeks old and has no follow-up recorded.

BRIEF surfaces once:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
MARKET FOLLOW-UP
8 weeks ago MARKET recommended:

[feature name]
PRISM-PV score: [score]
Classification: [Painkiller/Vitamin]

What happened?

A  Built it - users love it
B  Built it - users are indifferent
C  Built it - it caused problems
D  Did not build it - wrong priority
E  Did not build it - still planning
F  Still building it
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

- **A**: Lessons entry `MARKET prediction validated`. Create
  `Synthesis-MarketValidation-[feature].md` with confidence HIGH.
  Record PRISM-PV calibration note for this user type.
- **B**: Lessons entry `prediction partially wrong`.
  Lower painkiller-classification confidence for this feature type
  from HIGH to MEDIUM. Trigger `/compass --retro` automatically.
- **C**: Lessons entry `prediction wrong`. Add caution note to
  competitor research pages about this feature direction.
- **D**: Lessons entry `priority overridden`. Ask for brief reason.
- **E/F**: No action. Ask again in 4 weeks.

---

## BRIEF surfacing rules

BRIEF reads silently on every run:

- `$OBSIDIAN_LESSONS_FILE` — last 30 days of entries.
- `$SKIP_TRACKER` — pending questions and deferred items.
- Experiment log — KEEP entries aged ≥14 days without follow-up.
- MARKET recommendations — priority 1 aged ≥8 weeks without follow-up.

If any are present, BRIEF appends blocks to its briefing:

```
FOLLOW-UPS NEEDED:
[count] experiments need outcome feedback. Takes 30 seconds.
Type f to answer now or skip.

DEFERRED ITEMS DUE:
[rule] - deferred [X] days ago
Type d to review or skip.

SKIP PATTERNS DETECTED:
[count] findings skipped 3+ times
Type s to resolve or skip.

RECENT LESSONS:
[most relevant lesson in one line]
[link to lessons file]
```

---

## EVOLVE lessons-awareness

Before the improvement loop starts, EVOLVE reads:

- `$OBSIDIAN_LESSONS_FILE`
- All wiki pages where `confidence_for_projects.[PROJECT_NAME]` is
  LOW or DISPUTED.

It displays:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EVOLVE - [PROJECT_NAME]
Reading lessons from [count] sessions.

Rules excluded from autonomous improvement
(disputed or low confidence):
[list]

Metrics with reliability warnings:
[list metrics flagged unreliable in lessons]

Program file last updated: [date]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

EVOLVE never autonomously applies changes based on DISPUTED or LOW
confidence rules. If the only available improvement uses one, ask:

```
The lowest scoring area involves a rule with LOW confidence
for [PROJECT_NAME]:

[rule name]

This rule has been disputed [count] times.

Apply anyway?
A  Yes - try it and measure
B  No - skip this rule
C  Remove from EVOLVE scope entirely
```

---

## RESEARCH lessons-awareness

After a source is ingested and wiki pages are written, check lessons
for prior entries about this source type or rule domain. If any
exist, display:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
LESSONS FROM PREVIOUS INGESTS
[summary of prior lessons relevant to this source type]

Consider these when reviewing takeaways for the new source.
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

## Schema: the lessons file

One file per project at `$OBSIDIAN_LESSONS_FILE`. Created on first
write if missing. Template:

```markdown
# [PROJECT_NAME] - Lessons Learned
Created: [timestamp]

## How this file works
Every session appends to this file.
- 1 or 2 skips of a finding: noted silently.
- 3 skips: one question asked, answer recorded here.
- BRIEF surfaces relevant recent lessons.
- EVOLVE updates the program file from lessons.
- Wiki confidence levels adjust from disputes.

## Skip patterns
(Populated automatically)

## Outcome follow-ups
(Populated automatically by BRIEF)

## Confidence updates applied
(Populated automatically)

## Program file changes
(Populated automatically when EVOLVE metric proves unreliable)
```

---

## Section appenders (used across commands)

When a command needs to append an entry, it writes under the
appropriate H2 header. If the H2 does not exist yet, create it.

- Skip resolutions → `## Skip patterns`
- Outcome follow-ups → `## Outcome follow-ups`
- Confidence changes → `## Confidence updates applied`
- Program changes → `## Program file changes`

Each entry is an H3 dated block: `### [YYYY-MM-DD] - [title]`.
