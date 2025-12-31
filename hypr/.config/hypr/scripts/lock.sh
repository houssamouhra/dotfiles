#!/bin/bash

# Detect primary/active monitor
ACTIVE_MONITOR=$(hyprctl monitors | grep "Monitor" | grep -v "disabled" | awk '{print $2; exit}')

# Choose config based on monitor
if [[ "$ACTIVE_MONITOR" == "eDP-1" ]]; then
    CONFIG="$HOME/.config/hypr/hyprlock-laptop.conf"
else
    CONFIG="$HOME/.config/hypr/hyprlock-external.conf"
fi

export MONITOR="$ACTIVE_MONITOR"

# Run hyprlock with chosen config
hyprlock -c "$CONFIG"
