#!/bin/bash

iDIR="$HOME/.config/swaync/icons"
CACHE_FILE="$HOME/.cache/ddc_brightness"
notification_timeout=1000
MIN_BRIGHTNESS=10

# ====================== INIT CACHE ======================
init_cache() {
  if [ ! -f "$CACHE_FILE" ]; then
    val=$(ddcutil getvcp 10 2>/dev/null | grep -oP 'current value\s*=\s*\K[0-9]+')
    [ -z "$val" ] && val=50
    echo "$val" >"$CACHE_FILE"
  fi
}

get_cached() {
  cat "$CACHE_FILE"
}

set_cached() {
  echo "$1" >"$CACHE_FILE"
}

# ====================== DETECTION ======================
if ddcutil detect 2>/dev/null | grep -q "Display 1"; then
  use_ddcutil=true
  ddc_bus=3
  init_cache
else
  use_ddcutil=false
fi

# ====================== ICON ======================
get_icon() {
  if [ "$current" -le 20 ]; then
    icon="$iDIR/brightness-20.png"
  elif [ "$current" -le 40 ]; then
    icon="$iDIR/brightness-40.png"
  elif [ "$current" -le 60 ]; then
    icon="$iDIR/brightness-60.png"
  elif [ "$current" -le 80 ]; then
    icon="$iDIR/brightness-80.png"
  else
    icon="$iDIR/brightness-100.png"
  fi
}

# ====================== NOTIFY ======================
notify_user() {
  notify-send -e \
    -h string:x-canonical-private-synchronous:brightness_notif \
    -h int:value:"$current" \
    -u low \
    -i "$icon" \
    "Brightness : $current%"
}

# ====================== MAIN ======================
case "$1" in
"--get")
  if [ "$use_ddcutil" = true ]; then
    get_cached
  else
    brightnessctl -m | cut -d, -f4
  fi
  ;;

"--inc")
  if [ "$use_ddcutil" = true ]; then
    current=$(get_cached)
    new=$((current + 10))
    [ "$new" -gt 100 ] && new=100

    ddcutil --bus="$ddc_bus" setvcp 10 "$new" \
      --noverify --sleep-multiplier=0.1 >/dev/null 2>&1 &

    set_cached "$new"
    current=$new
  else
    brightnessctl set "+10%"
    current=$(brightnessctl -m | cut -d, -f4 | tr -cd '0-9')
  fi

  get_icon
  notify_user
  ;;

"--dec")
  if [ "$use_ddcutil" = true ]; then
    current=$(get_cached)
    new=$((current - 10))
    [ "$new" -lt "$MIN_BRIGHTNESS" ] && new="$MIN_BRIGHTNESS"

    ddcutil --bus="$ddc_bus" setvcp 10 "$new" \
      --noverify --sleep-multiplier=0.1 >/dev/null 2>&1 &

    set_cached "$new"
    current=$new
  else
    brightnessctl set "10%-"
    current=$(brightnessctl -m | cut -d, -f4 | tr -cd '0-9')
  fi

  get_icon
  notify_user
  ;;

*)
  if [ "$use_ddcutil" = true ]; then
    get_cached
  else
    brightnessctl -m | cut -d, -f4
  fi
  ;;
esac
