#!/usr/bin/env bash
set -euo pipefail

# === Environment setup ===
export HOST="${HOST:-$(cat /etc/hostname)}"
export CODEDIR="${CODEDIR:-/mnt/raid/mycode}"
export PKGDIR="$CODEDIR/packages"
mkdir -p "$PKGDIR/$HOST"
cd "$PKGDIR"

# === Logging ===
source ~/scripts/lib/logging.sh
start_log

# === Handle non-existing binaries ===
safe_run() {
  local cmd="$1"; shift
  if command -v "$cmd" >/dev/null 2>&1; then
    log "[run] $cmd $*"
    "$cmd" "$@" || log "[warn] $cmd failed"
  else
    log "[skip] $cmd not found"
  fi
}

# === Collect package lists ===
safe_run apt list --manual-installed > "$HOST/aptlist.txt"
safe_run apk list -I --manual > "$HOST/apklist.txt"
safe_run pacman -Qqe > "$HOST/paclist.txt"
safe_run yay -Qqm > "$HOST/aurlist.txt"
safe_run flatpak list --app --columns=application > "$HOST/flatpaklist.txt"
safe_run uv tool list | awk '!/- /' > "$HOST/uvlist.txt"

for file in "$HOST"/*.txt; do
  [[ -s "$file" ]] || continue
  if head -n 1 "$file" | grep -q '^\['; then
    tmpfile="$(mktemp)"
    tail -n +2 "$file" > "$tmpfile" && mv "$tmpfile" "$file"
    log "Cleaned header from $(basename "$file")"
  fi
done

# === Commit + push if changes ===
if ! git diff --quiet || ! git diff --cached --quiet; then
  git add -A
  git commit -m "Auto-sync: $(date '+%Y-%m-%d %H:%M:%S')"
  git push
  log "Committed and pushed updates."
else
  log "No changes detected."
fi

end_log
