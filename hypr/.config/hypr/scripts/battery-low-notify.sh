#!/usr/bin/env bash

set -uo pipefail

# CONFIGURATION
BATTERY="BAT0"

CHECK_INTERVAL=120
COOLDOWN=900 # 15 min

NOTIFY_TITLE="Battery Low!"
NOTIFY_URGENCY="critical"

NOTIFY_CMD="/usr/bin/notify-send"

SOUND="$HOME/.config/waybar/sounds/low-battery.mp3"
SOUND_CMD="/usr/bin/pw-play"

# Optional: auto suspend at critical level
ENABLE_AUTO_SUSPEND=true
SUSPEND_THRESHOLD=5

# Threshold messages
declare -A MESSAGES=(
  [20]="Battery at {PERCENT}% — better plug in soon!"
  [12]="Battery at {PERCENT}% — connect charger soon!"
  [10]="Only {PERCENT}% battery left — plug in NOW!"
)

# STATE
declare -A last_notified

# HELPERS
battery_path="/sys/class/power_supply/$BATTERY"

send_notification() {
  local threshold="$1"
  local capacity="$2"

  local message="${MESSAGES[$threshold]}"
  message="${message//\{PERCENT\}/$capacity}"

  "$NOTIFY_CMD" \
    -u "$NOTIFY_URGENCY" \
    -a "battery-notify" \
    -i "battery-low-symbolic" \
    "$NOTIFY_TITLE" \
    "$message"
}

play_sound() {
  [[ -f "$SOUND" ]] || return 0
  [[ -x "$SOUND_CMD" ]] || return 0

  "$SOUND_CMD" "$SOUND" &>/dev/null &
}

suspend_system() {
  notify-send \
    -u critical \
    -a "battery-notify" \
    "Critical Battery" \
    "System suspending to prevent shutdown..."

  sleep 5

  systemctl suspend
}

reset_notifications() {
  last_notified=()
}

get_battery_level() {
  local capacity="$1"

  if ((capacity <= 10)); then
    echo 10
  elif ((capacity <= 12)); then
    echo 12
  elif ((capacity <= 20)); then
    echo 20
  else
    echo 0
  fi
}

# VALIDATION
if [[ ! -d "$battery_path" ]]; then
  echo "Error: Battery '$BATTERY' not found." >&2
  exit 1
fi

# MAIN LOOP
while true; do
  capacity=$(<"$battery_path/capacity")
  status=$(<"$battery_path/status")

  # Reset state while charging/full
  if [[ "$status" == "Charging" || "$status" == "Full" ]]; then
    reset_notifications
    sleep "$CHECK_INTERVAL"
    continue
  fi

  # Skip invalid reads
  if [[ -z "$capacity" ]]; then
    sleep "$CHECK_INTERVAL"
    continue
  fi

  current_time=$(date +%s)

  level=$(get_battery_level "$capacity")

  # No active threshold
  if ((level == 0)); then
    sleep "$CHECK_INTERVAL"
    continue
  fi

  last_time=${last_notified[$level]:-0}

  if ((current_time - last_time >= COOLDOWN)); then
    send_notification "$level" "$capacity"
    play_sound

    last_notified[$level]=$current_time
  fi

  # Emergency suspend
  if [[ "$ENABLE_AUTO_SUSPEND" == true ]] &&
    ((capacity <= SUSPEND_THRESHOLD)); then
    suspend_system
  fi

  sleep "$CHECK_INTERVAL"
done
