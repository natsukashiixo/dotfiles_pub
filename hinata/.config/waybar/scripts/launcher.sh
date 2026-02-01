#!/bin/sh
set -e

case "$1" in
  browser)
    app="$(xdg-settings get default-web-browser)"
    ;;
  filemanager)
    app="$(xdg-mime query default inode/directory)"
    ;;
  editor)
    app="$(xdg-mime query default text/plain)"
    ;;
 terminal)
    app="$(xdg-mime query default x-scheme-handler/terminal)"
    ;;
  *)
    exit 1
    ;;
esac

[ -n "$app" ] && gtk-launch "$app"
