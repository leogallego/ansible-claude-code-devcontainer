#!/bin/sh
# Extract the Abbenay VSIX and start the daemon.
# Called from postStartCommand. Logs to /tmp/abbenay-init.log for debugging.

LOG=/tmp/abbenay-init.log
VSIX=/opt/abbenay-provider.vsix
EXT_DIR=/root/.vscode-server/extensions/redhat.abbenay-provider
DAEMON="$EXT_DIR/bin/abbenay-daemon-linux-x64"

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

# 2. Start daemon if binary exists
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
