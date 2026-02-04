#!/usr/bin/env bash
set -euo pipefail

bar="$1"        # top | bottom
signal="$2"     # SIGRTMIN | RTMIN
value="$3"      # integer

: "${XDG_RUNTIME_DIR:?XDG_RUNTIME_DIR not set}"

case "$bar" in
  top|bottom) ;;
  *)
    echo "Invalid bar: $bar (expected top|bottom)" >&2
    exit 1
    ;;
esac

[[ "$value" =~ ^[0-9]+$ ]] || {
  echo "Signal value must be numeric" >&2
  exit 1
}

pidfile="$XDG_RUNTIME_DIR/wbhandler/${bar}_waybar.pid"

if [[ -r $pidfile ]] && kill -0 "$(cat "$pidfile")" 2>/dev/null; then
  kill "-SIGRTMIN+$value" "$(cat "$pidfile")"
else
  echo "Waybar ($bar) not running or stale PID" >&2
fi
