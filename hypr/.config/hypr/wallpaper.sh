#!/bin/bash

# --- CONFIG ---
WALLPAPER_DIR="$HOME/wallpapers/Catppuccin"
CAVA_CONFIG="$HOME/.config/cava/config"

# --- MENU FUNCTION ---
menu() {
    find "$WALLPAPER_DIR" -type f \
        \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.jpeg" -o -iname "*.gif" \) |
        awk '{print "img:"$0}'
}

# --- MAIN LOGIC ---
main() {
    choice=$(menu | wofi \
        -c ~/.config/wofi/wallpaper \
        -s ~/.config/wofi/style-wallpaper.css \
        --show dmenu --prompt "Select Wallpaper:" -n)

    selected_wallpaper=$(echo "$choice" | sed 's/^img://')

    # >>> 1. Apply wallpaper
    swww img "$selected_wallpaper" \
        --transition-type any \
        --transition-fps 60 \
        --transition-duration 0.5

    # >>> 2. Generate Pywal theme
    wal -i "$selected_wallpaper" --suppress-term --suppress-tmux -q
    

    # >>> 5. SwayNC theme reload
    swaync-client --reload-css

    # >>> 6. Reload Hyprland so borders update
    hyprctl reload

    # >>> 7. Update CAVA gradient colors
    color1=$(grep -oP "color2='\K[^']+" ~/.cache/wal/colors.sh)
    color2=$(grep -oP "color3='\K[^']+" ~/.cache/wal/colors.sh)

    sed -i "s/^gradient_color_1 = .*/gradient_color_1 = '$color1'/" "$CAVA_CONFIG"
    sed -i "s/^gradient_color_2 = .*/gradient_color_2 = '$color2'/" "$CAVA_CONFIG"

    pkill -USR2 cava 2>/dev/null

    # >>> 8. Save last wallpaper for restore
    cp "$selected_wallpaper" "$HOME/wallpapers/pywallpaper.jpg"
}

main
