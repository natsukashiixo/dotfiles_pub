#!/usr/bin/env bash
set -euo pipefail

cd /mnt/raid/mycode/dotfiles_pub/hinata
rsync -a --delete --update --no-links $HOME/.zshrc ./
rsync -a --delete --update --no-links --exclude-from='.gitignore' $HOME/.config/ .config/
rsync -a --delete --update --no-links --exclude-from='.gitignore' /etc/greetd/ greetd/

# commit + push if changed
if ! git diff --quiet || ! git diff --cached --quiet; then
  git add .
  git commit -m "Auto-sync: $(date '+%Y-%m-%d %H:%M:%S')"
  git push
fi
