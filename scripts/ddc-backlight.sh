#!/usr/bin/env bash
# Usage: ddc-backlight.sh <brightness% 0-100>

BRIGHT="$1"
for disp in 1 2; do
  for attempt in {1..3}; do
    ddcutil --display "$disp" setvcp 10 "$BRIGHT" 2>/dev/null && break
    sleep 0.3
  done
done
