#!/usr/bin/env bash

POWER_MENU="rofi-power-menu"
FUZZEL_CONFIG="$HOME/.config/fuzzel/power.ini"
CHOICES="shutdown/reboot/suspend/logout"

selected=$(
  "$POWER_MENU" --choices "$CHOICES" |
    sed 's/\x00.*$//' |
    grep '<span' |
    sed -E 's/<[^>]+>//g' |
    sed $'s/\u200e//g; s/\u2068//g; s/\u2069//g; s/\u200b//g' |
    fuzzel \
      --dmenu \
      --config "$FUZZEL_CONFIG"
)

[ -z "$selected" ] && exit 0

case "$selected" in
*"Shut down"*) choice="shutdown" ;;
*"Reboot"*) choice="reboot" ;;
*"Suspend"*) choice="suspend" ;;
*"Log out"*) choice="logout" ;;
*) exit 1 ;;
esac

confirm=$(
  printf 'yes\nno\n' |
    fuzzel \
      --dmenu \
      --config "$FUZZEL_CONFIG" \
      --placeholder "" \
      --prompt "$selected? "
)

[ "$confirm" = "yes" ] || exit 0

case "$choice" in
shutdown)
  systemctl poweroff
  ;;
reboot)
  systemctl reboot
  ;;
suspend)
  systemctl suspend
  ;;
logout)
  hyprctl dispatch exit
  ;;
esac
