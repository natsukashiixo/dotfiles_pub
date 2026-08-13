#!/bin/bash

set -euo pipefail

modfolder="/mnt/raid/balatromods"

#in case script is invoked from outside of expected folder
cd $modfolder

TAG=$(curl -sS https://api.github.com/repos/NeatsTopFoo/Cirno_TV-And-Friends/releases/latest | jq -r '.tag_name')
curl -OL "https://github.com/NeatsTopFoo/Cirno_TV-And-Friends/releases/download/${TAG}/Cirno_TV-And-Friends.zip"

latestversion=$(realpath "./Cirno_TV-And-Friends.zip")
echo "downloaded Cirno and Friends version $TAG to $latestversion"

rm -rf "$modfolder/steamsymlink/Mods/Cirno_TV-And-Friends"
unzip "$latestversion" -d "$modfolder/steamsymlink/Mods/"
rm -f {"$modfolder/steamsymlink/Mods/Cirno_TV-And-Friends.zip","$latestversion"}
echo "script done, enjoy gaem"
