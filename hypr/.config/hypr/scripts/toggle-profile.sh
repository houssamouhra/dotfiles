#!/usr/bin/env bash

set -euo pipefail

STATE="$HOME/.cache/hyprmon-profile"

current="$(cat "$STATE" 2>/dev/null || echo laptop)"

case "$current" in
laptop)
  hyprmon -profile docked
  echo docked >"$STATE"
  ;;
docked)
  hyprmon -profile laptop
  echo laptop >"$STATE"
  ;;
esac
