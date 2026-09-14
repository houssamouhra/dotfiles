#!/usr/bin/env bash

set -u

ICON="/usr/share/icons/Adwaita/symbolic/status/display-brightness-symbolic.svg"

STEP=5

get_brightness() {
  brightnessctl -m |
    awk -F, '{gsub(/%/, "", $4); print $4}'
}

change_brightness() {
  local direction="$1"
  brightnessctl -q set "${STEP}%${direction}"
}

notify_user() {
  local brightness="$1"

  notify-send \
    -e \
    -h "string:x-canonical-private-synchronous:brightness_notif" \
    -h "int:value:$brightness" \
    -u low \
    -i "$ICON" \
    "Brightness: ${brightness}%"
}

case "${1:-}" in

--get)
  get_brightness
  ;;

--inc)
  change_brightness "+"
  notify_user "$(get_brightness)"
  ;;

--dec)
  change_brightness "-"
  notify_user "$(get_brightness)"
  ;;

*)
  printf 'Usage: %s {--get|--inc|--dec}\n' "$0" >&2
  exit 1
  ;;

esac
