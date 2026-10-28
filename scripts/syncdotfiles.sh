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

export DOTSREPO="$CODEDIR/dotfiles_pub/"
mkdir -p "$DOTSREPO"

#=== Set up logging ===
source ~/scripts/lib/logging.sh
start_log

cd "$DOTSREPO"

if ! [[ -d ".git/" ]]; then
  git clone git@ntsu-deploy:natsukashiixo/dotfiles_pub.git .
fi
git pull

mkdir -p scripts

rsync -a --update --no-links "$HOME/scripts/" "scripts/"
rsync -a --delete --update --no-links "$HOME/.zshrc" "$HOST/"
# .gitignore is an allowlist (`**/.config/*`, then `!**/.config/<name>` per synced entry). rsync matches
# patterns relative to ~/.config/, so --exclude-from can't use it; build the include rules from the `!` lines.
config_filters=()
while IFS= read -r name; do
  config_filters+=(--include="/$name" --include="/$name/***")
done < <(sed -nE 's#^!\*\*/?\.config/([^/]+)/?$#\1#p' .gitignore)

if (( ${#config_filters[@]} == 0 )); then
  # with no includes, --delete-excluded would empty $HOST/.config and the commit would delete every tracked config
  log "No !**/.config/<name> lines in .gitignore; skipping the .config sync."
else
  # --delete-excluded also clears anything outside the allowlist that older runs copied in
  rsync -a --delete --delete-excluded --update --no-links "${config_filters[@]}" --exclude='*' "$HOME/.config/" "$HOST/.config/"
fi
if [ -d "/etc/greetd" ]; then
  rsync -a --delete --update --no-links --exclude-from='.gitignore' "/etc/greetd/" "$HOST/greetd/"
fi

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
