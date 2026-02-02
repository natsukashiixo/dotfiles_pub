#!/usr/bin/env python3

from __future__ import annotations

import argparse
import subprocess
import os


def main() -> None:

    parser = argparse.ArgumentParser(description='wrapper for swapping between wallpaper modes')
    parser.add_argument(
    'mode',
    choices=('vtuber', 'idol', 'normie', 'movie'),
    help='required arg for which mode'
    )

    args = parser.parse_args()

    MODE_MAP = {
    "vtuber": "vtubers",
    "idol": "imas",
    "normie": "normie",
    "movie": "fallback",
    }
    target = MODE_MAP[args.mode]

    horiz_path = os.path.expanduser(f'~/wallpapers/{target}/horiz__resized/')
    vert_path = os.path.expanduser(f'~/wallpapers/{target}/vert__resized/')

    subprocess.run([
    "/home/ntsu/scripts/wallpaper_random.py",
    "horiz",
    "--force-reset",
    "--source-folder",
    str(horiz_path),
    ], check=True)

    subprocess.run([
    "/home/ntsu/scripts/wallpaper_random.py",
    "vert",
    "--force-reset",
    "--source-folder",
    str(vert_path),
    ], check=True)


if __name__ == "__main__":
    main()
