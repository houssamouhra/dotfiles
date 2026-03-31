#!/bin/bash

WALLPAPER_DIR="$HOME/wallpapers/"
LAST_WALLPAPER="$WALLPAPER_DIR/.last_wallpaper"
CACHE_FILE="$HOME/.cache/wallpapers.list"
CAVA_CONFIG="$HOME/.config/cava/config"

generate_cache() {
  find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.gif" \) |
    sort >"$CACHE_FILE.tmp" && mv "$CACHE_FILE.tmp" "$CACHE_FILE" || {
    rm -f "$CACHE_FILE.tmp" "$CACHE_FILE"
    echo "Failed to generate wallpaper cache!" >&2
    return 1
  }
}

get_random_wallpaper() {
  if [[ ! -f "$CACHE_FILE" || "$WALLPAPER_DIR" -nt "$CACHE_FILE" ]]; then
    generate_cache || return 1
  fi

  mapfile -t files <"$CACHE_FILE"
  ((${#files[@]} == 0)) && return 1

  printf '%s\n' "${files[RANDOM%${#files[@]}]}"
}

menu_select_wallpaper() {
  if [[ ! -f "$CACHE_FILE" || "$WALLPAPER_DIR" -nt "$CACHE_FILE" ]]; then
    generate_cache || return 1
  fi

  while IFS= read -r img; do
    printf '%s\x00icon\x1f%s\n' "$img" "$img"
  done <"$CACHE_FILE" |
    rofi -dmenu -i -p "Select Wallpaper" \
      -theme ~/.config/rofi/minimal/wallpaper.rasi \
      -show-icons
}

apply_wallpaper() {
  local selected_wallpaper="$1"
  local mode="$2"

  [ -z "$selected_wallpaper" ] && return

  if [[ "$mode" == "restore" ]]; then
    sleep 0.08
    awww img "$selected_wallpaper"
  else
    awww img "$selected_wallpaper" \
      --transition-type fade \
      --transition-step 20 \
      --transition-fps 144

    # wal + swaync in background
    (
      wal -i "$selected_wallpaper" -s >/dev/null 2>&1 &&
        swaync-client -rs
    ) &
  fi

  # Always save the last wallpaper
  echo "$selected_wallpaper" >"$LAST_WALLPAPER"
}

# Main logic
if [[ "$1" == "restore" ]]; then
  if [ -f "$LAST_WALLPAPER" ] && [ -s "$LAST_WALLPAPER" ]; then
    wp=$(<"$LAST_WALLPAPER")
    wp="${wp%%$'\n'}"
    [[ ! -f "$wp" ]] && wp=$(get_random_wallpaper) || true
  else
    wp=$(get_random_wallpaper) || {
      echo "No wallpapers available!" >&2
      exit 1
    }
  fi
elif [[ "$1" == "manual" ]]; then
  wp=$(get_random_wallpaper) || {
    echo "No wallpapers available!" >&2
    exit 1
  }
else
  # menu mode
  wp=$(menu_select_wallpaper)
fi

[[ -n "$wp" ]] && apply_wallpaper "$wp" "$1"
