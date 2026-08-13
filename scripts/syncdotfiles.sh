#!/usr/bin/env bash
set -euo pipefail

# === Environment setup ===
HOST="${HOST:-$(cat /etc/hostname)}"
XDG_PROJECTS_DIR="${XDG_PROJECTS_DIR:-$HOME/Projects}"

# check for local path
if [[ -d "/mnt/raid/mycode" ]]; then
  CODEDIR="/mnt/raid/mycode"
else
  CODEDIR="$XDG_PROJECTS_DIR"
fi

PKGDIR="$CODEDIR/packages"
mkdir -p "$PKGDIR/$HOST"
export DOTSREPO="$CODEDIR/dotfiles_pub/"

#=== Set up logging ===
source ~/scripts/lib/logging.sh
start_log

cd "$DOTSREPO"

if ! [[ -d ".git/" ]]; then
  git clone git@github.com:natsukashiixo/dotfiles_pub.git
fi
git pull

mkdir -p scripts

rsync -a --update --no-links "$HOME/scripts/" "scripts/"
rsync -a --delete --update --no-links "$HOME/.zshrc" "$HOST/"
rsync -a --delete --update --no-links --exclude-from='.gitignore' "$HOME/.config/" "$HOST/.config/"
rsync -a --delete --update --no-links --exclude-from='.gitignore' "/etc/greetd/" "$HOST/greetd/"

if ! git diff --quiet || ! git diff --cached --quiet; then
  git add -A
  git commit -m "Auto-sync: $(date '+%Y-%m-%d %H:%M:%S')"
  git pull --rebase
  git push
  log "Committed and pushed updates."
else
  log "No changes detected."
fi

end_log
