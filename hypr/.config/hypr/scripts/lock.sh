#!/usr/bin/env bash

set -euo pipefail

if hyprctl monitors | grep -q "^Monitor HDMI-A-1 "; then
  exec hyprlock -c ~/.config/hypr/hyprlock/external.conf
else
  exec hyprlock -c ~/.config/hypr/hyprlock/laptop.conf
fi
