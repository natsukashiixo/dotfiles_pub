#!/usr/bin/env bash
set -euo pipefail

bar="$1"        # top | bottom
pidfile="$2"

XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"

case "$bar" in
  top)
    config="$XDG_CONFIG_HOME/waybar/topbar.json"
    style="$XDG_CONFIG_HOME/waybar/styling/topbar.css"
    ;;
  bottom)
    config="$XDG_CONFIG_HOME/waybar/bottombar.json"
    style="$XDG_CONFIG_HOME/waybar/styling/bottombar.css"
    ;;
  *)
    echo "Invalid param. Accepted values: top | bottom" >&2
    exit 1
    ;;
esac

mkdir -p "$(dirname "$pidfile")"

waybar -c "$config" -s "$style" &
pid=$!

echo "$pid" > "$pidfile"

exit 0
