#!/bin/bash

WALLPAPER_DIR="$HOME/wallpapers/"
WALL_PALETTE="$HOME/.cache/wal/colors.sh"
CAVA_CONFIG="$HOME/.config/cava/config"
LAST_WALLPAPER="$WALLPAPER_DIR/.last_wallpaper"

get_random_wallpaper() {
  find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.gif" \) | shuf -n 1
}

menu_select_wallpaper() {
  find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.png" \) -print0 |
    while IFS= read -r -d '' img; do
      printf '%s\x00icon\x1f%s\n' "$img" "$img"
    done |
    rofi -dmenu -i -p "Select Wallpaper" \
      -theme ~/.config/rofi/minimal/wallpaper.rasi \
      -show-icons
}

apply_wallpaper() {
  local selected_wallpaper="$1"

  [ -z "$selected_wallpaper" ] && return

  awww img "$selected_wallpaper" \
    --transition-type fade \
    --transition-step 20 \
    --transition-fps 144

  # Apply pywal but exclude terminal
  wal -i "$selected_wallpaper" -s

  local color1 color2
  color1=$(grep -oP "color2='\K[^']+" "$WALL_PALETTE")
  color2=$(grep -oP "color3='\K[^']+" "$WALL_PALETTE")

  sed -i "s/^gradient_color_1 = .*/gradient_color_1 = '$color1'/" "$CAVA_CONFIG"
  sed -i "s/^gradient_color_2 = .*/gradient_color_2 = '$color2'/" "$CAVA_CONFIG"

  pkill -USR2 cava 2>/dev/null
  pkill -USR2 swaync 2>/dev/null

  echo "$selected_wallpaper" >"$LAST_WALLPAPER"
}

if [ "$1" == "restore" ]; then
  if [ -f "$LAST_WALLPAPER" ]; then
    wp=$(cat "$LAST_WALLPAPER")
  else
    wp=$(get_random_wallpaper)
  fi

elif [ "$1" == "manual" ]; then
  wp=$(get_random_wallpaper)

else
  wp=$(menu_select_wallpaper)
fi

[ -n "$wp" ] && apply_wallpaper "$wp"
