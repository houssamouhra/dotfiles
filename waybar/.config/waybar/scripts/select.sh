#!/usr/bin/env bash

WAYBAR_DIR="$HOME/.config/waybar"
STYLECSS="$WAYBAR_DIR/style.css"
THEMES="$WAYBAR_DIR/themes"

menu() {
    printf "clean"
}

apply_theme() {
    case "$1" in
        clean)
            cp "$THEMES/clean.css" "$STYLECSS"
            ;;
        *)
            exit 0
            ;;
    esac
}

reload_waybar() {
    pkill waybar
    sleep 0.15
    waybar &
}

main() {
    choice=$(menu | wofi \
        --show dmenu \
        --prompt " Waybar Theme " \
        -n)

    [ -z "$choice" ] && exit 0

    apply_theme "$choice"
    reload_waybar
}

main

