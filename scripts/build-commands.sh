#!/bin/bash
# build-commands.sh
# Regenerates all command files by combining RESOLVER.md with each
# command body. Run this after any RESOLVER.md change.
#
# Command bodies live in commands/bodies/. Build script combines
# frontmatter + RESOLVER block + body to produce final commands/*.md

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

RESOLVER_FILE="$REPO_ROOT/RESOLVER.md"
BODIES_DIR="$REPO_ROOT/commands/bodies"
COMMANDS_DIR="$REPO_ROOT/commands"
LOCAL_COMMANDS_DIR="$HOME/.claude/commands"

if [ ! -f "$RESOLVER_FILE" ]; then
  echo "ERROR: RESOLVER.md not found at $RESOLVER_FILE"
  exit 1
fi

# Extract just the first fenced code block from RESOLVER.md — this is the
# canonical resolver block. Stop at its closing fence; later fenced blocks
# (e.g. inside the KNOWLEDGE_BRIDGE documentation section) must not bleed in.
RESOLVER_BLOCK=$(awk '
  /^```$/ {
    if (!started) { started=1; next }
    else { exit }
  }
  started { print }
' "$RESOLVER_FILE")

if [ -z "$RESOLVER_BLOCK" ]; then
  echo "ERROR: Could not extract resolver block from RESOLVER.md"
  echo "Expected a fenced code block containing the resolver."
  exit 1
fi

# If bodies/ directory doesn't exist yet, this is the first build.
# Skip silently — bodies/ is an optional organisational improvement.
if [ ! -d "$BODIES_DIR" ]; then
  echo "No bodies/ directory found. Skipping build."
  echo "To use the build system, move each command's body to commands/bodies/[name].md"
  echo "(without the frontmatter or resolver — just the command logic)."
  exit 0
fi

mkdir -p "$LOCAL_COMMANDS_DIR"

count=0
for body_file in "$BODIES_DIR"/*.md; do
  [ -f "$body_file" ] || continue
  command_name=$(basename "$body_file" .md)
  
  # Read body file — first line must be the frontmatter marker
  # Format: frontmatter between --- lines, then body
  output="$COMMANDS_DIR/$command_name.md"
  
  # Extract frontmatter (lines between first --- and second ---)
  awk '
    /^---$/ { fm++; print; next }
    fm < 2 { print; next }
    fm == 2 && !done {
      print ""
      # Inject resolver block
      while ((getline line < "'$RESOLVER_FILE'") > 0) {
        # Only print lines inside the code fence
      }
      close("'$RESOLVER_FILE'")
      done = 1
    }
    { print }
  ' "$body_file" > "$output"
  
  # Simpler approach: just cat frontmatter + resolver + body
  # Extract frontmatter
  awk '/^---$/{f++; print; if(f==2) exit; next} f==1 {print}' "$body_file" > "$output"
  echo "" >> "$output"
  echo "$RESOLVER_BLOCK" >> "$output"
  echo "" >> "$output"
  awk '/^---$/{f++; next} f>=2 {print}' "$body_file" >> "$output"
  
  # Also copy to local install
  cp "$output" "$LOCAL_COMMANDS_DIR/$command_name.md"
  
  echo "Built: $command_name"
  count=$((count + 1))
done

# Copy meta commands that have no body file in commands/bodies/
# These are intentionally resolver-less (vtpaudit audits; projects
# lists across projects globally) so the main loop skips them.
# Copy them verbatim so repo edits always reach ~/.claude/commands/.
META_COMMANDS="vtpaudit projects"
meta_count=0
for cmd in $META_COMMANDS; do
  if [ -f "$COMMANDS_DIR/$cmd.md" ]; then
    cp "$COMMANDS_DIR/$cmd.md" "$LOCAL_COMMANDS_DIR/$cmd.md"
    echo "Synced meta: $cmd"
    meta_count=$((meta_count + 1))
  fi
done

echo ""
echo "Done. $count commands built, $meta_count meta commands synced."
echo "Repo: $COMMANDS_DIR"
echo "Local: $LOCAL_COMMANDS_DIR"
