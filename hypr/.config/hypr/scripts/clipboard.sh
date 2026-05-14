#!/bin/bash

theme="$HOME/.config/rofi/clipboard.rasi"

selected=$(
  cliphist list |
    sed 's/^[0-9]\+\s//' |
    rofi -dmenu -i -p "󰅌 Clipboard:" -theme "$theme"
)

[ -z "$selected" ] && exit 0

cliphist list |
  grep -F "$selected" |
  cliphist decode |
  wl-copy
