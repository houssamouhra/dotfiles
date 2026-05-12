#!/bin/bash
set -euo pipefail

WALLPAPER_DIR="$HOME/wallpapers"
CACHE_DIR="$HOME/.cache/wallpapers"
CACHE_FILE="$CACHE_DIR/wallpapers.list"
LAST_WALLPAPER="$CACHE_DIR/last_wallpaper"
CAVA_CONFIG="$HOME/.config/cava/config"
ROFI_THEME="$HOME/.config/rofi/wallpaper.rasi"

mkdir -p "$CACHE_DIR"

log() {
  printf '[wallpaper] %s\n' "$*"
}

generate_cache() {
  log "Generating wallpaper cache..."

  find "$WALLPAPER_DIR" \
    -type f \
    \( \
    -iname "*.jpg" \
    -o -iname "*.jpeg" \
    -o -iname "*.png" \
    -o -iname "*.gif" \
    \) |
    sort >"$CACHE_FILE.tmp"

  mv "$CACHE_FILE.tmp" "$CACHE_FILE"
}

ensure_cache() {
  if [[ ! -f "$CACHE_FILE" ]] ||
    find "$WALLPAPER_DIR" -type f -newer "$CACHE_FILE" | grep -q .; then
    generate_cache
  fi
}

select_wallpaper() {
  ensure_cache

  local selected

  selected=$(
    while IFS= read -r img; do
      printf '%s\x00icon\x1f%s\n' "$img" "$img"
    done <"$CACHE_FILE" |
      rofi \
        -dmenu \
        -i \
        -p "Wallpaper" \
        -theme "$ROFI_THEME" \
        -show-icons
  ) || return 1

  [[ -n "$selected" ]] || return 1

  printf '%s\n' "$selected"
}

generate_cava_theme() {
  local color1 color2

  pkill -USR2 cava || true
  color1=$(grep -oP "color2='\K[^']+" ~/.cache/wal/colors.sh)
  color2=$(grep -oP "color3='\K[^']+" ~/.cache/wal/colors.sh)

  sed -i "s/^gradient_color_1 = .*/gradient_color_1 = '$color1'/" "$CAVA_CONFIG"
  sed -i "s/^gradient_color_2 = .*/gradient_color_2 = '$color2'/" "$CAVA_CONFIG"
  pkill -USR2 cava 2>/dev/null
}

apply_wal() {
  local wallpaper="$1"

  if [[ ! -f "$wallpaper" ]]; then
    log "Error: Wallpaper not found: $wallpaper"
    return 1
  fi

  log "Applying pywal theme..."
  wal -i "$wallpaper" -s

  generate_cava_theme
  swaync-client -rs >/dev/null 2>&1 || true
}

set_wallpaper() {
  local wallpaper="$1"
  local mode="${2:-normal}"

  [[ -z "$wallpaper" ]] && return 1

  log "Setting wallpaper: $wallpaper"

  if [[ "$mode" == "restore" ]]; then
    awww img "$wallpaper"
  else
    awww img "$wallpaper" \
      --transition-type fade \
      --transition-duration 1 \
      --transition-fps 144
  fi

  apply_wal "$wallpaper"

  printf '%s\n' "$wallpaper" >"$LAST_WALLPAPER"
}

get_random_wallpaper() {
  ensure_cache

  mapfile -t wallpapers <"$CACHE_FILE"
  [[ ${#wallpapers[@]} -eq 0 ]] && return 1

  printf '%s\n' "${wallpapers[RANDOM % ${#wallpapers[@]}]}"
}

restore_wallpaper() {
  if [[ -s "$LAST_WALLPAPER" ]]; then
    local wallpaper
    wallpaper="$(<"$LAST_WALLPAPER")"

    if [[ -f "$wallpaper" ]]; then
      printf '%s\n' "$wallpaper"
      return
    fi
  fi

  get_random_wallpaper
}

main() {
  local wallpaper=""

  case "${1:-menu}" in
  restore)
    wallpaper="$(restore_wallpaper)"
    set_wallpaper "$wallpaper" "restore"
    ;;

  manual)
    wallpaper="$(get_random_wallpaper)"
    set_wallpaper "$wallpaper" "normal"
    ;;

  menu)
    wallpaper="$(select_wallpaper || true)"
    [[ -n "$wallpaper" ]] && set_wallpaper "$wallpaper" "normal"
    ;;

  *)
    echo "Usage: $0 [restore|manual|menu]"
    exit 1
    ;;
  esac
}

main "$@"
