#!/usr/bin/env bash

set -euo pipefail

WALLPAPER_DIR="$HOME/Pictures/walls"
WALLPAPER_CACHE="$HOME/.cache/wallpapers"
LAST_WALLPAPER="$WALLPAPER_CACHE/last_wallpaper"

mkdir -p "$WALLPAPER_CACHE"

log() {
  printf '[wallpaper] %s\n' "$*" >&2
}

get_random_wallpaper() {
  local wallpapers=()

  while IFS= read -r -d '' wallpaper; do
    wallpapers+=("$wallpaper")
  done < <(
    find -L "$WALLPAPER_DIR" \
      -type f \
      \( \
      -iname "*.jpg" \
      -o -iname "*.jpeg" \
      -o -iname "*.png" \
      -o -iname "*.gif" \
      \) \
      -print0
  )

  if [[ ${#wallpapers[@]} -eq 0 ]]; then
    log "No wallpapers found in $WALLPAPER_DIR"
    return 1
  fi

  printf '%s\n' "${wallpapers[RANDOM % ${#wallpapers[@]}]}"
}

apply_wallpaper() {
  local wallpaper="$1"

  if [[ ! -f "$wallpaper" ]]; then
    log "Wallpaper not found: $wallpaper"
    return 1
  fi

  log "Applying wallpaper..."
  awww img "$wallpaper" \
    --transition-type random \
    --transition-duration 1 \
    --transition-fps 144

  printf '%s\n' "$wallpaper" >"$LAST_WALLPAPER"

  log "Wallpaper applied successfully"
}

case "${1:-}" in
random)
  wallpaper="$(get_random_wallpaper)"
  apply_wallpaper "$wallpaper"
  ;;

"")
  log "Usage: $0 <wallpaper> | random"
  exit 1
  ;;

*)
  apply_wallpaper "$1"
  ;;
esac
