#!/usr/bin/env bash

set -euo pipefail

SCREENSHOT_DIR="$HOME/Pictures/Screenshots"
mkdir -p "$SCREENSHOT_DIR"

timestamp() {
  date +%Y%m%d_%H%M%S
}

notify() {
  local title="$1"
  local body="$2"
  local icon="${3:-}"

  if [[ -n "$icon" && -f "$icon" ]]; then
    notify-send -i "$icon" "$title" "$body"
  else
    notify-send "$title" "$body"
  fi
}

case "${1:-}" in
# Region → clipboard
region)
  if grim -g "$(slurp)" - | wl-copy; then
    notify "Screenshot" "Region copied to clipboard"
  else
    notify "Screenshot" "Region selection cancelled"
  fi
  ;;

# Active window → file
window)
  file="$SCREENSHOT_DIR/$(timestamp).png"

  if grim -g "$(hyprctl activewindow -j | jq -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"')" "$file"; then
    notify "Screenshot" "Window saved" "$file"
  else
    notify "Screenshot" "Failed to capture window"
  fi
  ;;

# Current monitor → file
output | monitor)
  file="$SCREENSHOT_DIR/$(timestamp).png"

  if grim -o "$(hyprctl monitors -j | jq -r '.[] | select(.focused) | .name')" "$file"; then
    notify "Screenshot" "Monitor saved" "$file"
  else
    notify "Screenshot" "Failed to capture monitor"
  fi
  ;;

*)
  echo "Usage: $0 {region|window|output}"
  exit 1
  ;;
esac
