#!/usr/bin/env bash
# Centralized logging helper for user-maintained scripts.
# Usage: source ~/.config/scripts/lib/logging.sh

set -euo pipefail

export HOST="${HOST:-$(cat /etc/hostname)}"

# --- Configuration ---
LOGDIR="/var/log/${USER}"
mkdir -p "$LOGDIR"

# Default log file name if not set by the parent script
LOGFILE="${LOGFILE:-${LOGDIR}/$(basename "${0%.*}").log}"

# --- Functions ---
log() {
  local timestamp
  timestamp="$(date '+%Y-%m-%d %H:%M:%S')"
  echo "[$timestamp] $*" | tee -a "$LOGFILE"
}

start_log() {
  log "=== Starting $(basename "$0") on $(HOST) ==="
}

end_log() {
  log "=== Finished $(basename "$0") ==="
}

# Redirect stdout/stderr to log file unless already handled by parent script
exec >>"$LOGFILE" 2>&1
