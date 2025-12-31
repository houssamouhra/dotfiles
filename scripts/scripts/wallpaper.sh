#!/bin/bash

WALLPAPER_DIR="$HOME/wallpapers/walls"
CAVA_CONFIG="$HOME/.config/cava/config"

get_random_wallpaper() {
    find "$WALLPAPER_DIR" -type f \
        \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.jpeg" -o -iname "*.gif" \) |
        shuf -n 1
}

menu_select_wallpaper() {
    # Launch Wofi menu
    choice=$(find "$WALLPAPER_DIR" -type f \
        \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.jpeg" -o -iname "*.gif" \) |
        awk '{print "img:"$0}' |
        wofi -c ~/.config/wofi/wallpaper \
             -s ~/.config/wofi/style-wallpaper.css \
             --show dmenu --prompt "Select Wallpaper:" -n)

    echo "$choice" | sed 's/^img://'
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

    echo "$selected_wallpaper" > "$HOME/wallpapers/.last_wallpaper"
}

# Default behavior: menu or manual
if [ "$1" == "manual" ]; then
    wp=$(get_random_wallpaper)
    apply_wallpaper "$wp"
else
    wp=$(menu_select_wallpaper)
    apply_wallpaper "$wp"
fi

