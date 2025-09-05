#!/usr/bin/env bash

# Check if kernel is upgradable
updates=$(yay -Qua 2>/dev/null | grep -c "^linux-bazzite-bin")

# Extract numbers from installed package version (drop pkgrel)
installed=$(pacman -Q linux-bazzite-bin | awk '{print $2}' | sed 's/-[0-9]\+$//' | grep -oE '[0-9]+')

# Extract numbers from running kernel version
running=$(uname -r | grep -oE '[0-9]+' | head -n 4) # limit to major.minor.patch.build

# Convert both to a comparable form (dot-separated)
installed_ver=$(echo "$installed" | paste -sd.)
running_ver=$(echo "$running" | paste -sd.)

# Compare
if [[ "$updates" -gt 0 ]]; then
    echo '{"text": "Update kernel pls", "class": "update"}'
elif [[ "$installed_ver" != "$running_ver" ]]; then
    echo '{"text": "Reboot pls", "class": "reboot"}'
fi

