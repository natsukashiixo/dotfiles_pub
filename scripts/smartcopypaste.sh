#!/bin/sh

key=$1
terminal_class=$2

active_class=$(hyprctl activewindow -j | jq -r '.class')

if [ "$active_class" = "$terminal_class" ]; then
    shortcut="CTRL_SHIFT,$key,"
else
    shortcut="CTRL,$key,"
fi

hyprctl dispatch sendshortcut "$shortcut"
