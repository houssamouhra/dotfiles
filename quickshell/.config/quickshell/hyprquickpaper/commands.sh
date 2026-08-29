#!/usr/bin/env bash

set -euo pipefail

WALLPAPER_DIR="$HOME/wallpapers"
WALLPAPER_CACHE="$HOME/.cache/wallpapers"
LAST_WALLPAPER="$WALLPAPER_CACHE/last_wallpaper"
CAVA_CONFIG="$HOME/.config/cava/config"
WAL_COLORS="$HOME/.cache/wal/colors.sh"

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

update_cava() {
  local color1 color2

  [[ -f "$WAL_COLORS" ]] || {
    log "Pywal colors file not found"
    return 0
  }

  [[ -f "$CAVA_CONFIG" ]] || {
    log "Cava config not found"
    return 0
  }

  color1=$(grep -oP "color2='\K[^']+" "$WAL_COLORS")
  color2=$(grep -oP "color3='\K[^']+" "$WAL_COLORS")

  sed -i \
    "s/^gradient_color_1 = .*/gradient_color_1 = '$color1'/" \
    "$CAVA_CONFIG"

  sed -i \
    "s/^gradient_color_2 = .*/gradient_color_2 = '$color2'/" \
    "$CAVA_CONFIG"

  pkill -USR2 cava 2>/dev/null || true
}

apply_wallpaper() {
  local wallpaper="$1"

  if [[ ! -f "$wallpaper" ]]; then
    log "Wallpaper not found: $wallpaper"
    return 1
  fi

  log "Generating Pywal colors..."
  wal -i "$wallpaper" -s

  log "Applying wallpaper..."
  awww img "$wallpaper" \
    --transition-type random \
    --transition-duration 1 \
    --transition-fps 144

  log "Updating Cava colors..."
  update_cava

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
