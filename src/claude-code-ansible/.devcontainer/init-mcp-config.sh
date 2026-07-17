#!/bin/bash
# Generate MCP config files for multiple AI harnesses from a single source.
# Merge-or-create with jq additive merge to preserve existing user config.
# Called from postStartCommand.

set -euo pipefail

DEVCONTAINER_DIR="/workspace/.devcontainer"
WORKSPACE="/workspace"
SOURCE="$DEVCONTAINER_DIR/mcp-servers.json"

if [ ! -f "$SOURCE" ]; then
  echo "init-mcp-config: source not found: $SOURCE, skipping"
  exit 0
fi

merge_mcp_config() {
  local target="$1"
  local transform="$2"  # jq expression to transform the source
  local target_name
  target_name=$(basename "$(dirname "$target")")/$(basename "$target")

  local transformed
  transformed=$(jq "$transform" "$SOURCE")

  local target_dir
  target_dir=$(dirname "$target")
  mkdir -p "$target_dir"

  if [ ! -f "$target" ]; then
    echo "$transformed" > "$target"
    echo "init-mcp-config: created $target_name"
    return 0
  fi

  # Additive merge: existing config is base, transformed source overlays
  local merged
  merged=$(jq -s '.[0] * .[1]' "$target" <(echo "$transformed"))
  echo "$merged" > "$target"
  echo "init-mcp-config: updated $target_name (merged)"
}

# .mcp.json — Claude Code + Copilot CLI
# Add type:"local" and tools:["*"] per server for Copilot CLI compatibility
merge_mcp_config "$WORKSPACE/.mcp.json" \
  '{mcpServers: (.mcpServers | to_entries | map(.value += {type: "local", tools: ["*"]}) | from_entries)}'

# .vscode/mcp.json — Copilot (VS Code)
# Rename mcpServers to servers
merge_mcp_config "$WORKSPACE/.vscode/mcp.json" \
  '{servers: .mcpServers}'

# .gemini/settings.json — Gemini CLI + Gemini Code Assist
# Keep mcpServers key, add context.fileName for AGENTS.md discovery
merge_mcp_config "$WORKSPACE/.gemini/settings.json" \
  '. + {context: {fileName: ["AGENTS.md"]}}'

# .cursor/mcp.json — Cursor
# mcpServers key as-is
merge_mcp_config "$WORKSPACE/.cursor/mcp.json" '.'
