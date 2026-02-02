#!/usr/bin/env python3

from __future__ import annotations

import argparse
import json
import mimetypes
import random
import subprocess
from pathlib import Path
import os
import sys

# ----------------------------
# Constants / defaults
# ----------------------------

DEFAULT_SOURCES = {
    "horiz": Path("/home/ntsu/wallpapers/vtubers/horiz__resized"),
    "vert": Path("/home/ntsu/wallpapers/vtubers/vert__resized"),
}

CACHE_VERSION = 1


# ----------------------------
# Helpers
# ----------------------------

def is_image(path: Path) -> bool:
    mime, _ = mimetypes.guess_type(path)
    return mime is not None and mime.startswith("image/")


def get_cache_file(screen_name: str) -> Path:
    cache_base = Path(
        os.environ.get(
            "XDG_CACHE_HOME",
            Path.home() / ".cache",
        )
    )
    cache_dir = cache_base / "wallpaper_randomizer"
    cache_dir.mkdir(parents=True, exist_ok=True)
    return cache_dir / f"{screen_name}.json"


def load_cache(cache_file: Path) -> dict | None:
    if not cache_file.exists():
        return None
    try:
        with cache_file.open("r", encoding="utf-8") as f:
            return json.load(f)
    except Exception:
        return None


def save_cache(cache_file: Path, data: dict) -> None:
    with cache_file.open("w", encoding="utf-8") as f:
        json.dump(data, f, indent=2)


def build_wallpaper_queue(source_folder: Path) -> list[str]:
    wallpapers = [
        str(p)
        for p in source_folder.iterdir()
        if p.is_file() and is_image(p)
    ]
    random.shuffle(wallpapers)
    return wallpapers


def set_wallpaper_hyprpaper(image_path: str, screen_name: str) -> None:
    wp_args = f"{screen_name},{image_path}"
    subprocess.run(
        ["hyprctl", "hyprpaper", "wallpaper", f"{wp_args}"],
        check=False,
    )

def get_monitor(screen_arg: str) -> str:
    if screen_arg == "vert":
        return "HDMI-A-1"
    return "DP-1"


# ----------------------------
# Main
# ----------------------------

def main() -> None:
    parser = argparse.ArgumentParser(description="Random wallpaper selector with persistent cache")
    parser.add_argument(
        "screen_name",
        choices=("horiz", "vert"),
        help="Screen name (used for cache separation)",
    )
    parser.add_argument(
        "--source-folder",
        type=Path,
        help="Override wallpaper source folder",
    )
    parser.add_argument(
        "--force-reset",
        action="store_true",
        help="Discard existing cache and reshuffle",
    )
    parser.add_argument(
        "--print",
        dest="do_print",
        action="store_true",
        help="Print wallpaper path instead of calling hyprpaper",
    )

    args = parser.parse_args()

    cache_file = get_cache_file(args.screen_name)
    cache = None if args.force_reset else load_cache(cache_file)

    # ------------------------------------
    # Determine source folder
    # ------------------------------------

    if args.source_folder:
        source_folder = args.source_folder
    elif cache and "source_folder" in cache:
        source_folder = Path(cache["source_folder"])
    else:
        source_folder = DEFAULT_SOURCES[args.screen_name]

    if not source_folder.exists():
        print(f"Source folder does not exist: {source_folder}", file=sys.stderr)
        sys.exit(1)

    # ------------------------------------
    # Initialize or refresh queue
    # ------------------------------------

    if (
        cache is None
        or cache.get("version") != CACHE_VERSION
        or cache.get("source_folder") != str(source_folder)
        or not cache.get("queue")
    ):
        queue = build_wallpaper_queue(source_folder)
        if not queue:
            print(f"No images found in {source_folder}", file=sys.stderr)
            sys.exit(1)

        cache = {
            "version": CACHE_VERSION,
            "source_folder": str(source_folder),
            "queue": queue,
        }

    # ------------------------------------
    # Pop next wallpaper
    # ------------------------------------

    next_wallpaper = cache["queue"].pop(0)

    # If queue depleted, rebuild with same source
    if not cache["queue"]:
        cache["queue"] = build_wallpaper_queue(source_folder)

    save_cache(cache_file, cache)

    # ------------------------------------
    # Output or apply
    # ------------------------------------

    if args.do_print:
        print(next_wallpaper)
    else:
        set_wallpaper_hyprpaper(next_wallpaper, get_monitor(args.screen_name))


if __name__ == "__main__":
    main()
