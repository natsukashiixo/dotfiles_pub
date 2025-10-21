#!/usr/bin/env bash
set -euo pipefail

export HOST="${HOST:-$(cat /etc/hostname)}"
export CODEDIR="/mnt/raid/mycode"
export DOTSREPO="$CODEDIR/dotfiles_pub/"

#=== Set up logging ===
source ~/scripts/lib/logging.sh
start_log

cd "$DOTSREPO"

mkdir -p scripts

rsync -a --update --no-links "$HOME/scripts/" "scripts/"
rsync -a --delete --update --no-links "$HOME/.zshrc" "$HOST/"
rsync -a --delete --update --no-links --exclude-from='.gitignore' "$HOME/.config/" "$HOST/.config/"
rsync -a --delete --update --no-links --exclude-from='.gitignore' "/etc/greetd/" "$HOST/greetd/"

if ! git diff --quiet || ! git diff --cached --quiet; then
  git add -A
  git commit -m "Auto-sync: $(date '+%Y-%m-%d %H:%M:%S')"
  git push
  log "Committed and pushed updates."
else
  log "No changes detected."
fi

end_log
