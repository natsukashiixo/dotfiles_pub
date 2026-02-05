#!/usr/bin/env python3
# -*- coding: utf-8 -*-

from __future__ import annotations

import argparse
import os
import subprocess
import sys
from pathlib import Path
from time import time

def main() -> None:
    parser = argparse.ArgumentParser(
        description="Wrapper for swapping between wallpaper modes"
    )
    parser.add_argument(
        "mode",
        choices=("vtuber", "idol", "normie", "movie"),
        help="Which wallpaper mode to activate",
    )
    args = parser.parse_args()

    MODE_MAP = {
        "vtuber": "vtubers",
        "idol": "imas",
        "normie": "normie",
        "movie": "fallback",
    }
    target = MODE_MAP[args.mode]

    horiz_path = Path(os.path.expanduser(f"~/wallpapers/{target}/horiz__resized"))
    vert_path = Path(os.path.expanduser(f"~/wallpapers/{target}/vert__resized"))

    # Resolve the timer file location
    xdg_runtime = os.getenv("XDG_RUNTIME_DIR")
    if not xdg_runtime:
        sys.stderr.write("Error: $XDG_RUNTIME_DIR is not set.\n")
        sys.exit(1)

    timer_path = Path(xdg_runtime) / "wphandler" / "wallpapertimer"

    # Ensure the directory exists and touch the timer file
    timer_path.parent.mkdir(parents=True, exist_ok=True)
    timer_path.touch(exist_ok=True)

    # Run the wallpaper generators
    subprocess.run(
        [
            "/home/ntsu/scripts/wallpaper_random.py",
            "horiz",
            "--force-reset",
            "--source-folder",
            str(horiz_path),
        ],
        check=True,
    )
    subprocess.run(
        [
            "/home/ntsu/scripts/wallpaper_random.py",
            "vert",
            "--force-reset",
            "--source-folder",
            str(vert_path),
        ],
        check=True,
    )

    # Write the next trigger time (now + 1800 s) to the timer file
    next_ts = int(time()) + 1800
    timer_path.write_text(str(next_ts))

if __name__ == "__main__":
    main()
