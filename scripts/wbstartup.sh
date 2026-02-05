#!/usr/bin/env bash
set -euo pipefail

: "${XDG_RUNTIME_DIR:?XDG_RUNTIME_DIR not set}"

targetdir="$XDG_RUNTIME_DIR/wbhandler"
DELAY=1800
mkdir -p "$targetdir"

# clean the slate
killall waybar_auto_hide 2>/dev/null || true
killall waybar 2>/dev/null || true

while pgrep -x waybar >/dev/null; do
  sleep 0.05
done

# set up fresh state
hyprctl dispatch exec "~/.config/waybar/scripts/waybar_auto_hide --side bottom"
hyprctl dispatch exec "~/scripts/wblaunchwrap.sh bottom $targetdir/bottom_waybar.pid"
sleep 0.1
hyprctl dispatch exec "~/scripts/wblaunchwrap.sh top $targetdir/top_waybar.pid"
