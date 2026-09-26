#!/usr/bin/env bash

WALLPAPER=$(cat ~/.cache/wallpapers/last_wallpaper)
swaylock --image "$WALLPAPER" "$@"
