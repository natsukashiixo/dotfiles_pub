#!/usr/bin/env bash
set -eo pipefail

ARG="$1"

# for initial run

if [ ! -f "$XDG_RUNTIME_DIR/wphandler/wallpapertimer" ]; then
    mkdir -p "$XDG_RUNTIME_DIR/wphandler/"
    touch "$XDG_RUNTIME_DIR/wphandler/wallpapertimer"
    echo "0" > "$XDG_RUNTIME_DIR/wphandler/wallpapertimer"
fi

# If the current time is past the stored timestamp,
# or the script was called with --force, rotate the wallpaper.
if [ -f "$XDG_RUNTIME_DIR/wphandler/wallpapertimer" ] && \
   [ "$(date +%s)" -ge "$(cat "$XDG_RUNTIME_DIR/wphandler/wallpapertimer")" ] || \
   [[ $ARG == --force ]]; then
    /home/ntsu/scripts/wallpaper_random.py horiz >/dev/null 2>&1
    /home/ntsu/scripts/wallpaper_random.py vert  >/dev/null 2>&1
    # Set the next trigger time to 30 minutes (1800 seconds) from now
    echo $(( $(date +%s) + 1800 )) > "$XDG_RUNTIME_DIR/wphandler/wallpapertimer"
fi

exit 0
