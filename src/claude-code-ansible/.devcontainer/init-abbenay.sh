#!/bin/sh
# Extract the Abbenay VSIX, register it with VS Code, and start the daemon.
# Called from postStartCommand. Logs to /tmp/abbenay-init.log for debugging.

LOG=/tmp/abbenay-init.log
VSIX=/opt/abbenay-provider.vsix
EXT_DIR=/root/.vscode-server/extensions/redhat.abbenay-provider
EXTENSIONS_JSON=/root/.vscode-server/extensions/extensions.json
ARCH=$(uname -m | sed 's/x86_64/x64/' | sed 's/aarch64/arm64/')
DAEMON="$EXT_DIR/bin/abbenay-daemon-linux-$ARCH"

echo "[$(date -Iseconds)] init-abbenay.sh starting" > "$LOG"

# 1. Extract VSIX if present
if [ ! -f "$VSIX" ]; then
  echo "[$(date -Iseconds)] No VSIX at $VSIX, skipping (ABBENAY_VERSION=none?)" >> "$LOG"
  exit 0
fi

mkdir -p /root/.vscode-server/extensions
rm -rf /tmp/abbenay-vsix
if unzip -qo "$VSIX" 'extension/*' -d /tmp/abbenay-vsix >> "$LOG" 2>&1; then
  rm -rf "$EXT_DIR"
  mv /tmp/abbenay-vsix/extension "$EXT_DIR"
  rm -rf /tmp/abbenay-vsix
  echo "[$(date -Iseconds)] VSIX extracted to $EXT_DIR" >> "$LOG"
else
  echo "[$(date -Iseconds)] ERROR: unzip failed" >> "$LOG"
  exit 1
fi

# 2. Register extension in VS Code's extensions.json
VERSION=$(jq -r .version "$EXT_DIR/package.json" 2>/dev/null)
if [ -n "$VERSION" ] && [ -f "$EXTENSIONS_JSON" ]; then
  ENTRY="{\"identifier\":{\"id\":\"redhat.abbenay-provider\"},\"version\":\"$VERSION\",\"location\":{\"\$mid\":1,\"path\":\"$EXT_DIR\",\"scheme\":\"file\"},\"relativeLocation\":\"redhat.abbenay-provider\",\"metadata\":{\"isApplicationScoped\":true,\"installedTimestamp\":$(date +%s)000,\"source\":\"vsix\"}}"
  if ! grep -q '"redhat.abbenay-provider"' "$EXTENSIONS_JSON" 2>/dev/null; then
    CONTENT=$(cat "$EXTENSIONS_JSON")
    echo "$CONTENT" | sed "s/^\[/[$ENTRY,/" > "$EXTENSIONS_JSON"
    echo "[$(date -Iseconds)] Registered extension in extensions.json (v$VERSION)" >> "$LOG"
  else
    echo "[$(date -Iseconds)] Extension already registered in extensions.json" >> "$LOG"
  fi
else
  echo "[$(date -Iseconds)] WARNING: could not register in extensions.json (version=$VERSION)" >> "$LOG"
fi

# 3. Start daemon if binary exists
if [ ! -f "$DAEMON" ]; then
  echo "[$(date -Iseconds)] ERROR: daemon binary not found at $DAEMON" >> "$LOG"
  exit 1
fi

setsid "$DAEMON" serve --port 8788 >> "$LOG" 2>&1 &
DAEMON_PID=$!
sleep 2

if kill -0 "$DAEMON_PID" 2>/dev/null; then
  echo "[$(date -Iseconds)] Daemon started (PID $DAEMON_PID) on port 8788" >> "$LOG"
else
  echo "[$(date -Iseconds)] ERROR: daemon exited immediately, check log above" >> "$LOG"
  exit 1
fi
