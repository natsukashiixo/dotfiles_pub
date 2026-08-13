#!/usr/bin/env bash

set -euo pipefail

echo "mods on server but not on client:"
echo ""

unfiltered=$(grep -vFf <(find /home/ntsu/.local/share/atlauncher/instances/AlltheMonsATMons/mods -maxdepth 1 -type f -printf "%f\n") ~/Projects/servermods.txt)

filtered=$(echo "$unfiltered" | sed '/^\(tectonic\|Terralith\|Chunky\|lithostitched\)/d')

echo "$filtered"
