#!/usr/bin/env bash

killall waybar_auto_hide 2>/dev/null
killall waybar 2>/dev/null

hyprctl dispatch exec "~/.config/waybar/scripts/waybar_auto_hide --side bottom &" >/dev/null 2>&1

hyprctl dispatch exec "waybar -c ~/.config/waybar/bottombar.json -s ~/.config/waybar/styling/bottombar.css &" >/dev/null 2>&1
hyprctl dispatch exec "waybar -c ~/.config/waybar/topbar.json    -s ~/.config/waybar/styling/topbar.css &" >/dev/null 2>&1
