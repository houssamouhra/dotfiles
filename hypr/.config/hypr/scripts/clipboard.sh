#!/bin/bash

theme="$HOME/.config/rofi/clipboard.rasi"

selected=$(
  cliphist list |
    rofi -dmenu \
      -display-columns 2 \
      -i \
      -p "󰅌 Clipboard:" \
      -theme "$theme"
)

[ -z "$selected" ] && exit 0

printf '%s' "$selected" | cliphist decode | wl-copy
