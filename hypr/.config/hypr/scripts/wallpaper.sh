#!/bin/bash

WALLPAPER_DIR="$HOME/wallpapers/"
CAVA_CONFIG="$HOME/.config/cava/config"

get_random_wallpaper() {
    find "$WALLPAPER_DIR" -type f \
        \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.gif" \) \
        -print0 | shuf -z -n 1 | tr -d '\0'
}

menu_select_wallpaper() {
    local choice
    choice=$(
        find $WALLPAPER_DIR -type f \( -iname "*.jpg" -o -iname "*.png" \) |
            while read -r img; do printf '%s\x00icon\x1f%s\n' "$(basename "$img")" "$img"; done |
            rofi -dmenu -i -p "Select Wallpaper" -theme ~/.config/rofi/minimal/wallpaper.rasi -show-icons
    )

    [ -z "$choice" ] && return 1

    find "$WALLPAPER_DIR" -type f -name "$choice" -print -quit || echo ""
}

apply_wallpaper() {
    local selected_wallpaper="$1"

    swww img "$selected_wallpaper" \
        --transition-type any \
        --transition-fps 60 \
        --transition-duration 0.5

    # Apply pywal but exclude terminal
    wal -i "$selected_wallpaper" -s

    local color1 color2
    color1=$(grep -oP "color2='\K[^']+" ~/.cache/wal/colors.sh)
    color2=$(grep -oP "color3='\K[^']+" ~/.cache/wal/colors.sh)

    sed -i "s/^gradient_color_1 = .*/gradient_color_1 = '$color1'/" "$CAVA_CONFIG"
    sed -i "s/^gradient_color_2 = .*/gradient_color_2 = '$color2'/" "$CAVA_CONFIG"

    pkill -USR2 cava 2>/dev/null
    pkill -USR2 swaync 2>/dev/null

    echo "$selected_wallpaper" >"$HOME/wallpapers/.last_wallpaper"
}

# Default behavior: menu or manual
if [ "$1" == "manual" ]; then
    wp=$(get_random_wallpaper)
    apply_wallpaper "$wp"
else
    wp=$(menu_select_wallpaper)
    apply_wallpaper "$wp"
fi
