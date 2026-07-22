#!/bin/sh
# Extract the Abbenay VSIX, register it with VS Code, and start the daemon.
# Called from postStartCommand.
#
# Logs details to /tmp/abbenay-init.log and prints a summary to stdout
# (visible in the VS Code devcontainer log). Never exits non-zero so
# container startup always succeeds.

LOG=/tmp/abbenay-init.log
VSIX=/opt/abbenay-provider.vsix
ARCH=$(uname -m | sed 's/x86_64/x64/' | sed 's/aarch64/arm64/')

log() { echo "[$(date -Iseconds)] $1" >> "$LOG"; }
summary() { echo "Abbenay: $1"; log "$1"; }

log "init-abbenay.sh starting" > "$LOG"

if [ ! -f "$VSIX" ]; then
  summary "skipped (no VSIX at $VSIX, ABBENAY_VERSION=none?)"
  exit 0
fi

# 1. Install extension via VS Code's own CLI (survives reloads, no race)
CODE_SERVER=$(find /root/.vscode-server/bin -name "code-server" -type f 2>/dev/null | sort | tail -1)
if [ -n "$CODE_SERVER" ]; then
  log "Installing VSIX via code-server: $CODE_SERVER"
  "$CODE_SERVER" --install-extension "$VSIX" --force >> "$LOG" 2>&1
  INSTALL_RC=$?
  log "code-server --install-extension exit code: $INSTALL_RC"
  if [ "$INSTALL_RC" -ne 0 ]; then
    summary "WARNING: code-server install failed (rc=$INSTALL_RC), falling back to manual extraction"
  fi
fi

# 2. Fallback: manual extraction if code-server unavailable or failed
if [ -z "$CODE_SERVER" ] || [ "${INSTALL_RC:-1}" -ne 0 ]; then
  [ -z "$CODE_SERVER" ] && log "code-server binary not found, using manual extraction"
  EXT_DIR=/root/.vscode-server/extensions/redhat.abbenay-provider
  mkdir -p /root/.vscode-server/extensions
  rm -rf /tmp/abbenay-vsix
  if unzip -qo "$VSIX" 'extension/*' -d /tmp/abbenay-vsix >> "$LOG" 2>&1; then
    rm -rf "$EXT_DIR"
    mv /tmp/abbenay-vsix/extension "$EXT_DIR"
    rm -rf /tmp/abbenay-vsix
    log "VSIX extracted to $EXT_DIR"
  else
    summary "ERROR: unzip failed (see $LOG)"
    exit 0
  fi

  EXTENSIONS_JSON=/root/.vscode-server/extensions/extensions.json
  VERSION=$(jq -r .version "$EXT_DIR/package.json" 2>/dev/null)
  if [ -n "$VERSION" ] && [ -f "$EXTENSIONS_JSON" ]; then
    ENTRY="{\"identifier\":{\"id\":\"redhat.abbenay-provider\"},\"version\":\"$VERSION\",\"location\":{\"\$mid\":1,\"path\":\"$EXT_DIR\",\"scheme\":\"file\"},\"relativeLocation\":\"redhat.abbenay-provider\",\"metadata\":{\"isApplicationScoped\":true,\"installedTimestamp\":$(date +%s)000,\"source\":\"vsix\"}}"
    if ! grep -q '"redhat.abbenay-provider"' "$EXTENSIONS_JSON" 2>/dev/null; then
      TMPJSON=$(mktemp)
      jq ". + [$ENTRY]" "$EXTENSIONS_JSON" > "$TMPJSON" && mv "$TMPJSON" "$EXTENSIONS_JSON"
      log "Registered extension in extensions.json (v$VERSION)"
    else
      log "Extension already registered in extensions.json"
    fi
  else
    summary "WARNING: could not register in extensions.json (version=$VERSION, file exists=$([ -f "$EXTENSIONS_JSON" ] && echo yes || echo no))"
  fi
fi

# 3. Start daemon if binary exists
DAEMON=$(find /root/.vscode-server/extensions -path "*abbenay*" -name "abbenay-daemon-linux-$ARCH" -type f 2>/dev/null | head -1)
if [ -z "$DAEMON" ]; then
  summary "ERROR: daemon binary not found (see $LOG)"
  exit 0
fi

chmod +x "$DAEMON" 2>/dev/null
setsid "$DAEMON" serve --port 8788 >> "$LOG" 2>&1 &
DAEMON_PID=$!
sleep 2

if kill -0 "$DAEMON_PID" 2>/dev/null; then
  summary "daemon running (PID $DAEMON_PID) on port 8788"
else
  summary "ERROR: daemon exited immediately (see $LOG)"
  exit 0
fi
