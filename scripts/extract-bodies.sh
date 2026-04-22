#!/bin/bash
# extract-bodies.sh
# One-time helper: splits each commands/*.md file into a body file at
# commands/bodies/*.md. The body contains the original frontmatter plus
# everything after the END OF RESOLVER marker. Run once to seed the
# build system; thereafter edit bodies/*.md directly and re-run
# build-commands.sh.

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
COMMANDS_DIR="$REPO_ROOT/commands"
BODIES_DIR="$COMMANDS_DIR/bodies"

mkdir -p "$BODIES_DIR"

count=0
skipped=0

for cmd in "$COMMANDS_DIR"/*.md; do
  [ -f "$cmd" ] || continue
  name=$(basename "$cmd" .md)
  output="$BODIES_DIR/$name.md"

  # A real resolver block opens with "RESOLVER — RUN THIS BEFORE" on its own
  # line. Checking only for "END OF RESOLVER" false-positives on commands
  # (like vtpaudit) whose body text mentions the phrase.
  if ! grep -q "^RESOLVER — RUN THIS BEFORE" "$cmd"; then
    echo "Skipping $name (no resolver block)"
    skipped=$((skipped + 1))
    continue
  fi

  awk '
    BEGIN { fm = 0; after_end = 0; in_body = 0 }
    # Frontmatter
    fm < 2 {
      print
      if ($0 == "---") fm++
      next
    }
    # After END OF RESOLVER marker, skip the === line that follows
    !in_body && /^END OF RESOLVER/ {
      after_end = 1
      next
    }
    after_end && /^===+$/ {
      after_end = 0
      in_body = 1
      next
    }
    # Before body starts: skip everything (blanks and resolver content)
    !in_body { next }
    # Body: print
    { print }
  ' "$cmd" > "$output"

  # Trim leading blank lines from body section
  awk '
    /^---$/ && fm < 2 { fm++; print; next }
    fm < 2 { print; next }
    # After frontmatter, skip leading blanks until first content line
    !started && NF == 0 { next }
    { started = 1; print }
  ' "$output" > "$output.tmp" && mv "$output.tmp" "$output"

  echo "Extracted: $name"
  count=$((count + 1))
done

echo ""
echo "Done. $count bodies extracted, $skipped skipped."
