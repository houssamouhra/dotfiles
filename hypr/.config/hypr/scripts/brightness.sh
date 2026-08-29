#!/usr/bin/env bash

set -u

CACHE_DIR="$HOME/.cache"
CACHE_FILE="$CACHE_DIR/ddc_brightness"

ICON_DIR="/usr/share/icons/Adwaita/symbolic/status"

STEP=5
DDC_BUS=3
DDC_VCP=10

# DDCUTIL Cache
init_cache() {
  mkdir -p "$CACHE_DIR"

  if [[ ! -f "$CACHE_FILE" ]]; then
    local value

    value=$(
      ddcutil --bus="$DDC_BUS" getvcp "$DDC_VCP" 2>/dev/null |
        grep -oP 'current value\s*=\s*\K[0-9]+'
    )

    [[ -z "$value" ]] && value=50

    printf '%s\n' "$value" >"$CACHE_FILE"
  fi
}

get_ddc_brightness() {
  cat "$CACHE_FILE"
}

set_ddc_brightness() {
  printf '%s\n' "$1" >"$CACHE_FILE"
}

# Monitor Detection
has_external_monitor() {
  ddcutil detect 2>/dev/null | grep -q "Display 1"
}

# Brightness
get_laptop_brightness() {
  printf "%.0f\n" "$(brillo -G)"
}

get_external_brightness() {
  get_ddc_brightness
}

get_brightness() {
  if has_external_monitor; then
    get_external_brightness
  else
    get_laptop_brightness
  fi
}

increase_laptop_brightness() {
  brillo -q -A "$STEP"
}

decrease_laptop_brightness() {
  brillo -q -U "$STEP"
}

increase_external_brightness() {
  local current new

  current=$(get_ddc_brightness)
  new=$((current + STEP))

  ((new > 100)) && new=100

  ddcutil \
    --bus="$DDC_BUS" \
    setvcp "$DDC_VCP" "$new" \
    --noverify \
    --sleep-multiplier=0.1 \
    >/dev/null 2>&1 &

  set_ddc_brightness "$new"
}

decrease_external_brightness() {
  local current new

  current=$(get_ddc_brightness)
  new=$((current - STEP))

  ((new < 0)) && new=0

  ddcutil \
    --bus="$DDC_BUS" \
    setvcp "$DDC_VCP" "$new" \
    --noverify \
    --sleep-multiplier=0.1 \
    >/dev/null 2>&1 &

  set_ddc_brightness "$new"
}

# Icon
get_icon() {
  printf '%s\n' "$ICON_DIR/display-brightness-symbolic.svg"
}

# Notification
notify_user() {
  local current icon

  current="$1"
  icon=$(get_icon)

  notify-send \
    -e \
    -h "string:x-canonical-private-synchronous:brightness_notif" \
    -h "int:value:$current" \
    -u low \
    -i "$icon" \
    "Brightness: ${current}%"
}

# Initialize
init_cache

case "${1:-}" in

--get)
  get_brightness
  ;;

--inc)
  if has_external_monitor; then
    # Increase both displays
    increase_laptop_brightness
    increase_external_brightness

    current=$(get_laptop_brightness)
  else
    increase_laptop_brightness
    current=$(get_laptop_brightness)
  fi

  notify_user "$current"
  ;;

--dec)
  if has_external_monitor; then
    # Decrease both displays
    decrease_laptop_brightness
    decrease_external_brightness

    current=$(get_laptop_brightness)
  else
    decrease_laptop_brightness
    current=$(get_laptop_brightness)
  fi

  notify_user "$current"
  ;;

*)
  printf 'Usage: %s {--get|--inc|--dec}\n' "$0" >&2
  exit 1
  ;;

esac
