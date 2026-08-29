#!/usr/bin/env bash

set -e

ICON_DIR="/usr/share/icons/Adwaita/symbolic/status"
SOUND_SCRIPT="./Sounds.sh"

# Volume
get_volume() {
  local volume
  volume=$(pamixer --get-volume)
  if ((volume == 0)); then
    echo "Muted"
  else
    echo "${volume}%"
  fi
}

get_icon() {
  local volume muted
  volume=$(pamixer --get-volume)
  muted=$(pamixer --get-mute)

  if [[ "$muted" == "true" ]] || ((volume == 0)); then
    echo "$ICON_DIR/audio-volume-muted-symbolic.svg"
  elif ((volume <= 30)); then
    echo "$ICON_DIR/audio-volume-low-symbolic.svg"
  elif ((volume <= 60)); then
    echo "$ICON_DIR/audio-volume-medium-symbolic.svg"
  else
    echo "$ICON_DIR/audio-volume-high-symbolic.svg"
  fi
}

notify_user() {
  local volume icon
  volume=$(pamixer --get-volume)
  icon=$(get_icon)

  if ((volume == 0)) || [[ "$(pamixer --get-mute)" == "true" ]]; then
    notify-send \
      -e \
      -h string:x-canonical-private-synchronous:volume_notif \
      -u low \
      -i "$icon" \
      "Volume: Muted"
  else
    notify-send \
      -e \
      -h int:value:"$volume" \
      -h string:x-canonical-private-synchronous:volume_notif \
      -u low \
      -i "$icon" \
      "Volume: ${volume}%"
    "$SOUND_SCRIPT" --volume
  fi
}

inc_volume() {
  [[ "$(pamixer --get-mute)" == "true" ]] && pamixer -u
  pamixer -i 5
  notify_user
}

dec_volume() {
  [[ "$(pamixer --get-mute)" == "true" ]] && pamixer -u
  pamixer -d 5
  notify_user
}

toggle_mute() {
  if [[ "$(pamixer --get-mute)" == "true" ]]; then
    pamixer -u
    notify-send -e -u low -i "$(get_icon)" "Volume Switched ON"
  else
    pamixer -m
    notify-send -e -u low -i "$(get_icon)" "Volume Switched OFF"
  fi
}

# Microphone
get_mic_volume() {
  local volume
  volume=$(pamixer --default-source --get-volume)
  if ((volume == 0)); then
    echo "Muted"
  else
    echo "${volume}%"
  fi
}

get_mic_icon() {
  local volume muted
  volume=$(pamixer --default-source --get-volume)
  muted=$(pamixer --default-source --get-mute)

  if [[ "$muted" == "true" ]] || ((volume == 0)); then
    echo "$ICON_DIR/microphone-sensitivity-muted-symbolic.svg"
  elif ((volume <= 30)); then
    echo "$ICON_DIR/microphone-sensitivity-low-symbolic.svg"
  elif ((volume <= 60)); then
    echo "$ICON_DIR/microphone-sensitivity-medium-symbolic.svg"
  else
    echo "$ICON_DIR/microphone-sensitivity-high-symbolic.svg"
  fi
}

notify_mic_user() {
  local volume icon
  volume=$(pamixer --default-source --get-volume)
  icon=$(get_mic_icon)

  notify-send \
    -e \
    -h int:value:"$volume" \
    -h string:x-canonical-private-synchronous:mic_notif \
    -u low \
    -i "$icon" \
    "Mic-Level: ${volume}%"
}

inc_mic_volume() {
  [[ "$(pamixer --default-source --get-mute)" == "true" ]] && pamixer --default-source -u
  pamixer --default-source -i 5
  notify_mic_user
}

dec_mic_volume() {
  [[ "$(pamixer --default-source --get-mute)" == "true" ]] && pamixer --default-source -u
  pamixer --default-source -d 5
  notify_mic_user
}

toggle_mic() {
  if [[ "$(pamixer --default-source --get-mute)" == "true" ]]; then
    pamixer --default-source -u
    notify-send -e -u low -i "$(get_mic_icon)" "Mic Switched ON"
  else
    pamixer --default-source -m
    notify-send -e -u low -i "$(get_mic_icon)" "Mic Switched OFF"
  fi
}

case "$1" in
--get) get_volume ;;
--inc) inc_volume ;;
--dec) dec_volume ;;
--toggle) toggle_mute ;;
--toggle-mic) toggle_mic ;;
--get-icon) get_icon ;;
--get-mic-icon) get_mic_icon ;;
--mic-inc) inc_mic_volume ;;
--mic-dec) dec_mic_volume ;;
*) get_volume ;;
esac
