#!/usr/bin/env bash
set -euo pipefail

export HOST="${HOST:-$(cat /etc/hostname)}"

LOGDIR="/var/log/${USER}"
mkdir -p "$LOGDIR"
LOGFILE="${LOGFILE:-${LOGDIR}/$(basename "${0%.*}").log}"

log() {
  local timestamp
  timestamp="$(date '+%Y-%m-%d %H:%M:%S')"
  echo "[$timestamp] $*" | tee -a "$LOGFILE"
}

start_log() {
  log "=== Starting $(basename "$0") on $HOST ==="
}

end_log() {
  log "=== Finished $(basename "$0") ==="
}
