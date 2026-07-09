#!/usr/bin/env bash

ROFI_THEME="$HOME/.config/rofi/clipboard.rasi"

selected=$(
  cliphist list |
    rofi \
      -dmenu \
      -display-columns 2 \
      -i \
      -p "󰅌 Clipboard" \
      -theme "$ROFI_THEME"
)

[ -z "$selected" ] && exit 0

printf '%s' "$selected" | cliphist decode | wl-copy
