#!/usr/bin/env bash

set -u

BATTERY="BAT0"
BATTERY_PATH="/sys/class/power_supply/$BATTERY"
CHECK_INTERVAL=120
COOLDOWN=900
WARNING_TITLE="Battery Low!"
NOTIFY_URGENCY="critical"
ICON_DIR="/usr/share/icons/Adwaita/symbolic/status"
SOUND="$HOME/.config/waybar/sounds/low-battery.mp3"
SOUND_CMD="/usr/bin/pw-play"

ENABLE_AUTO_SUSPEND=true
SUSPEND_THRESHOLD=5

declare -A MESSAGES=(
  [20]="Battery at {PERCENT}% — better plug in soon!"
  [12]="Battery at {PERCENT}% — connect charger soon!"
  [10]="Only {PERCENT}% battery left — plug in NOW!"
)

declare -A last_notified=()

# Battery Icon
get_battery_icon() {
  local capacity="$1"
  local status="$2"
  local level

  # Charging
  if [[ "$status" == "Charging" ]]; then
    if ((capacity >= 100)); then
      echo "$ICON_DIR/battery-level-100-charged-symbolic.svg"
      return
    fi

    level=$(((capacity / 10) * 10))

    echo "$ICON_DIR/battery-level-${level}-charging-symbolic.svg"
    return
  fi

  # Fully charged
  if [[ "$status" == "Full" ]] || ((capacity >= 100)); then
    echo "$ICON_DIR/battery-level-100-charged-symbolic.svg"
    return
  fi

  # Very low battery
  if ((capacity <= 10)); then
    echo "$ICON_DIR/battery-caution-symbolic.svg"
    return
  fi

  # Normal battery levels
  level=$(((capacity / 10) * 10))

  echo "$ICON_DIR/battery-level-${level}-symbolic.svg"
}

# Notification
send_notification() {
  local threshold="$1"
  local capacity="$2"
  local message="${MESSAGES[$threshold]}"
  local icon

  message="${message//\{PERCENT\}/$capacity}"

  icon=$(get_battery_icon "$capacity" "Discharging")

  notify-send \
    -u "$NOTIFY_URGENCY" \
    -a "battery-notify" \
    -i "$icon" \
    "$WARNING_TITLE" \
    "$message"
}

# Sound
play_sound() {
  [[ -f "$SOUND" ]] || return
  [[ -x "$SOUND_CMD" ]] || return

  "$SOUND_CMD" "$SOUND" &>/dev/null &
}

# Suspend
suspend_system() {
  notify-send \
    -u critical \
    -a "battery-notify" \
    -i "$ICON_DIR/battery-caution-symbolic.svg" \
    "Critical Battery" \
    "System suspending to prevent shutdown..."

  sleep 5

  systemctl suspend
}

# Notification State
reset_notifications() {
  last_notified=()
}

get_threshold() {
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

should_notify() {
  local threshold="$1"
  local current_time="$2"
  local last_time="${last_notified[$threshold]:-0}"

  ((current_time - last_time >= COOLDOWN))
}

# Validation
if [[ ! -d "$BATTERY_PATH" ]]; then
  printf 'Error: Battery "%s" not found.\n' "$BATTERY" >&2
  exit 1
fi

# Main Loop
while true; do
  capacity=$(<"$BATTERY_PATH/capacity")
  status=$(<"$BATTERY_PATH/status")

  # Validate capacity
  if [[ ! "$capacity" =~ ^[0-9]+$ ]]; then
    sleep "$CHECK_INTERVAL"
    continue
  fi

  # Charging / Full
  if [[ "$status" == "Charging" || "$status" == "Full" ]]; then
    reset_notifications
    sleep "$CHECK_INTERVAL"
    continue
  fi

  # Only process discharging state
  if [[ "$status" != "Discharging" ]]; then
    sleep "$CHECK_INTERVAL"
    continue
  fi

  current_time=$(date +%s)
  threshold=$(get_threshold "$capacity")

  # Low battery notification
  if ((threshold > 0)) &&
    should_notify "$threshold" "$current_time"; then

    send_notification "$threshold" "$capacity"
    play_sound

    last_notified[$threshold]="$current_time"
  fi

  # Automatic suspend
  if [[ "$ENABLE_AUTO_SUSPEND" == true ]] &&
    ((capacity <= SUSPEND_THRESHOLD)); then

    suspend_system

    # Prevent immediately suspending again after resume
    reset_notifications
  fi

  sleep "$CHECK_INTERVAL"
done
