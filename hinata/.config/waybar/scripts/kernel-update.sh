#!/usr/bin/env bash

set -euo pipefail

KERNEL_PKG=$(
  pacman -Qoq "/usr/lib/modules/$(uname -r)" \
  | grep -v -- '-headers$' \
  | head -n 1
)

# Is a kernel update available?
if checkupdates 2>/dev/null | awk '{print $1}' | grep -qx "$KERNEL_PKG"; then
    echo '{"text":"Update kernel pls","class":"update"}'
    exit 0
fi

# Installed kernel version (pkgver only)
installed=$(pacman -Q "$KERNEL_PKG" | awk '{print $2}' | cut -d- -f1)

# Running kernel version (strip Arch suffix)
running=$(uname -r | sed 's/-arch.*//')

installed=${installed%%.arch*}
running=${running%%-*}

# Reboot required
if [[ "$installed" != "$running" ]]; then
    echo '{"text":"Reboot pls","class":"reboot"}'
fi
