---
name: design
description: Full design integrity audit comparing a feature or the whole product against the established design system.
allowed-tools: Bash, mcp__chrome-devtools__*
---
===========================================
KNOWLEDGE BRIDGE HOOKS (v2.3.0)
===========================================

If OBSIDIAN_BRIDGE=on (STEP R8):

After audit complete — for each design decision confirmed during the
audit (new component convention, spacing rule, colour token choice,
animation policy) call write_decision_note from RESOLVER.md §
KNOWLEDGE_BRIDGE. Do not call on every observation, only on decisions
the user confirmed.

If a bridge call fails do not abort — log and continue.
===========================================

Running design integrity audit for: $ARGUMENTS

Read $PRODUCT_MD silently if it exists
Read $DESIGN_MD
Read $DECISIONS_MD

If DESIGN.md is empty or minimal:
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  BUILDING DESIGN INVENTORY FIRST
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  I need to map your design system before
  I can audit against it. Reading your
  codebase now. This only happens once.
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  Run the full DESIGN.md population (see DESIGN INVENTORY below).
  Confirm with user before proceeding to audit.

If $ARGUMENTS is empty ask:
  1. A specific new feature (tell me which)
  2. A specific page or section (tell me which)
  3. The whole product (thorough, uses more tokens)
  4. Just update the design inventory (no audit)

===========================================
DESIGN INVENTORY (for DESIGN.md population)
===========================================

When building or refreshing DESIGN.md, read the entire codebase
and capture the following comprehensive inventory:

COLOUR SYSTEM:
For every colour found: variable name, hex value, where used
(backgrounds, borders, text, icons, buttons), frequency
(dominant/accent/rare), semantic meaning (primary action,
danger, success, neutral, brand).

Colour usage rules inferred from the code: what colour primary
buttons use, destructive actions, success states, hover darkening,
disabled states, links, body text, headings, borders, backgrounds,
cards, inputs.

Colour anti-patterns: any colours used inconsistently.

TYPOGRAPHY SYSTEM:
For every font: name, source (Google Fonts/local/system), usage
(headings/body/code/UI), fallback stack.

Type scale: every size with what it's used for, heading level,
line height, weight. Rules inferred: page headings, section
headings, body copy, small labels, code, letter spacing, text
transform patterns.

Typography anti-patterns: any size/weight inconsistencies.

SPACING SYSTEM:
Every spacing value found, what it's used for, whether it follows
a grid pattern (4px/8px/Tailwind). Rules inferred: card padding,
section gap, button padding, form field gap, page padding, stack
spacing. Anti-patterns found.

COMPONENT INVENTORY:
For every reusable component: location, visual signature (bg,
border, radius, shadow, padding, dimensions), props and variants,
interactive states (hover, focus, active, disabled, loading),
used by which pages.

Component categories: buttons, inputs, cards, modals, navigation,
tables, badges/tags, alerts/toasts, empty states, loading states,
icons, avatars, dividers.

LAYOUT SYSTEM:
Max widths, column grid, sidebar pattern, header height, footer,
content area width, responsive breakpoints with layout changes,
z-index scale with what each level is used for.

BORDER AND SHAPE SYSTEM:
Every border radius, border style (width, style, colour),
box-shadow/drop-shadow with semantic meaning (elevated, floating,
pressed). Patterns and anti-patterns.

ANIMATION AND TRANSITION SYSTEM:
Every transition (duration, easing, property, element), animation
patterns (page transitions, loading, hover, modal, toast, skeleton).

ICON SYSTEM:
Library name/version, import method, standard sizes, standard
colours, usage rules (icons vs text, with labels).

OVERALL AESTHETIC:
Plain English description of the visual style. Design maturity
rating. Key design decisions that define the product's identity.

===========================================
PHASE 1 - IDENTIFY WHAT CHANGED
===========================================

Before comparing anything identify:
- Which files were added or changed
- Which UI elements are new or modified
- Which pages or views contain changes
- What the feature is supposed to do

===========================================
PHASE 2 - EXTRACT VISUAL SIGNATURE
===========================================

Read every new or changed UI file and extract:

Colours: every value and how each is used
Typography: every size, weight, family and what each applies to
Spacing: every padding, margin, gap and what each applies to
Components: every component referenced and which variant
New elements: anything not using an existing component, inline
styles bypassing design system, hardcoded values instead of tokens
Shape/borders: radius, styles, shadows
Animation/transitions: values and interaction behaviour

===========================================
PHASE 3 - COMPARE AGAINST DESIGN.md
===========================================

For every element extracted compare against the inventory:

COLOUR: Is this in the palette? Correct semantic purpose?
Hardcoded hex instead of variable? New colour close-but-not-matching?

TYPOGRAPHY: Size in the type scale? Weight consistent? Line height
matching? Correct font family for this content type?

SPACING: Value in the spacing scale? Follows the grid pattern?
Padding consistent with similar elements elsewhere?

COMPONENTS: Does an existing component cover this? If new one
created, is it genuinely new or duplication? Props used correctly?
Correct variant for context?

BORDERS/SHAPE: Radius matching system? Borders matching style?
Shadows matching elevation system?

ANIMATION: Transitions using established duration/easing? New
interactions feel consistent with existing ones?

OVERALL FIT: Does it feel like it belongs? Visual density match?
Hierarchy consistent? Seamless or bolt-on?

Read DECISIONS.md before flagging — if a finding matches a
documented intentional variation, note it as intentional and
do not flag as an issue.

===========================================
PHASE 4 - CATEGORISE FINDINGS
===========================================

CRITICAL: Feature visually clashes in a way users will notice.
Different colour palette, different font family, new button style
when existing one should be used, rounded vs sharp corners mismatch.

HIGH: Noticeable if you look closely. Spacing slightly off, font
size not in type scale, hardcoded colour instead of token, shadow
mismatch.

MEDIUM: Minor deviation careful eye would catch. Transition duration
off, minor radius difference, slightly different hover behaviour.

INTENTIONAL VARIATION: Confirmed differences. Flag for confirmation
not as errors.

===========================================
PHASE 5 - DISPLAY REPORT
===========================================

  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  DESIGN INTEGRITY REPORT
  Feature: [name]
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Design consistency score: [X]/10

  Overall fit:
  Seamless / Minor drift / Noticeable drift / Clashing

  Critical: [count]
  High: [count]
  Medium: [count]
  Intentional variations: [count]
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

For each finding show:
  [SEVERITY] - [title]
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  What was found: [specific description with values]
  Where: [file:line]
  What the product uses: [correct value/component]
  Suggested fix: [exact code change]
  Impact: [plain English user perception]
  Apply? Type yes / no / explain
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

===========================================
PHASE 6 - BROWSER VISUAL COMPARISON
===========================================

Open Chrome. Navigate to the new/changed feature and an existing
similar feature. Compare visually:
- Cards same weight? Buttons look like siblings?
- Spacing consistent? Colour usage coherent?
- Typography unified?

Take screenshots of both for the report.

Flag anything visible in browser not caught in code: colours
looking different due to opacity/layering, spacing looking wrong
despite matching values, elements visually heavy/light vs equivalents.

===========================================
PHASE 7 - SAVE AND UPDATE
===========================================

When user confirms a variation as intentional save to DECISIONS.md:
## [date] - [description]
What: [variation]
Why: [user's reason]
Affects: [files/features]
Do not flag again: yes

Update design consistency score in DESIGN.md and HEALTH.md.
Save findings summary to DESIGN.md under Known Inconsistencies.

For the HTML report add DESIGN INTEGRITY section with:
- Overall score and verdict
- Design system reference (colour swatches, typography, spacing)
- Findings grouped by: colour, typography, spacing, components,
  shape/borders, animation, overall aesthetic
- Each finding in plain English with file refs and fix
- Before/after screenshots where relevant
- Intentional variations log
- Design health trend over time
