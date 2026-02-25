#!/usr/bin/env bash
set -euo pipefail

MOUNTPOINT="$HOME/HeyNoteRemote"

if mount | grep -q "$MOUNTPOINT"; then
  exit 0
fi

mkdir -p "$MOUNTPOINT"

sshfs heynote-vps:notes "$MOUNTPOINT" -o reconnect
