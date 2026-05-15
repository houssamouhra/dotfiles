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
  printf '[wallpaper] %s\n' "$*" >&2
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

start_awww_daemon() {
  local retries=20 # 2 sec
  local pid

  # Check if already running
  if pid=$(pgrep -x awww-daemon); then
    if awww query >/dev/null 2>&1; then
      return 0
    fi
    # Process exists but not responding → kill it
    log "awww-daemon is running but unresponsive, restarting..."
    kill -TERM "$pid" 2>/dev/null || true
    sleep 0.3
  fi

  log "Starting awww daemon..."

  # Start it and capture PID immediately
  if ! awww-daemon >/dev/null 2>&1 & then
    log "Failed to launch awww-daemon (command not found or permission error)"
    return 1
  fi
  pid=$!

  # Wait for it to become ready
  while ((retries-- > 0)); do
    if awww query >/dev/null 2>&1; then
      log "awww daemon started successfully (PID $pid)"
      return 0
    fi

    # Check if process died
    if ! kill -0 "$pid" 2>/dev/null; then
      log "awww daemon died immediately after starting"
      return 1
    fi

    sleep 0.1
  done

  log "awww daemon failed to initialize within timeout"
  kill -TERM "$pid" 2>/dev/null || true
  return 1
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

  swaync-client -rs >/dev/null 2>&1 || true
  generate_cava_theme
}

set_wallpaper() {
  local wallpaper="$1"
  local mode="${2:-normal}"

  [[ -z "$wallpaper" ]] && return 1

  log "Setting wallpaper: $wallpaper"

  if [[ "$mode" == "restore" ]]; then
    awww img "$wallpaper" \
      --transition-type none
  else
    awww img "$wallpaper" \
      --transition-type fade \
      --transition-duration 1 \
      --transition-fps 144
  fi

  printf '%s\n' "$wallpaper" >"$LAST_WALLPAPER"

  apply_wal "$wallpaper"
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

    log "Restoring wallpaper: $wallpaper"

    if [[ -f "$wallpaper" ]]; then
      printf '%s\n' "$wallpaper"
      return
    fi
  fi

  log "Falling back to random wallpaper"

  get_random_wallpaper
}

main() {
  local wallpaper=""

  start_awww_daemon

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
