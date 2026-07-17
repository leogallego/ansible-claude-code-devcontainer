#!/bin/bash
# Generate AGENTS.md and CLAUDE.md from devcontainer source files.
# Append-or-create with idempotent marker-based replacement.
# Called from postStartCommand.

set -euo pipefail

DEVCONTAINER_DIR="/workspace/.devcontainer"
WORKSPACE="/workspace"
BEGIN_MARKER="<!-- BEGIN ANSIBLE-DEVCONTAINER -->"
END_MARKER="<!-- END ANSIBLE-DEVCONTAINER -->"

merge_markdown() {
  local source="$1"
  local target="$2"
  local target_name
  target_name=$(basename "$target")

  if [ ! -f "$source" ]; then
    echo "init-claude-md: source not found: $source, skipping $target_name"
    return 0
  fi

  if [ ! -f "$target" ]; then
    cp "$source" "$target"
    echo "init-claude-md: created $target_name"
    return 0
  fi

  if grep -q "$BEGIN_MARKER" "$target"; then
    # Replace existing marked section
    local tmpfile
    tmpfile=$(mktemp)
    # Print everything before BEGIN marker, then new content, then everything after END marker
    awk -v begin="$BEGIN_MARKER" -v end="$END_MARKER" -v src="$source" '
      BEGIN { printing=1; printed_src=0 }
      $0 ~ begin { printing=0; if (!printed_src) { while ((getline line < src) > 0) print line; printed_src=1 }; next }
      $0 ~ end { printing=1; next }
      printing { print }
    ' "$target" > "$tmpfile"
    mv "$tmpfile" "$target"
    echo "init-claude-md: updated $target_name (replaced marked section)"
    return 0
  fi

  # Append to existing file
  printf '\n' >> "$target"
  cat "$source" >> "$target"
  echo "init-claude-md: updated $target_name (appended)"
}

merge_markdown "$DEVCONTAINER_DIR/agents-md-devcontainer.md" "$WORKSPACE/AGENTS.md"
merge_markdown "$DEVCONTAINER_DIR/claude-md-devcontainer.md" "$WORKSPACE/CLAUDE.md"
