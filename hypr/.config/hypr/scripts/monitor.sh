#!/bin/bash

# Laptop screen
LAPTOP="eDP-1"

# Get number of connected monitors
MONITORS=$(hyprctl monitors | grep "Monitor" | wc -l)

if [ "$MONITORS" -gt 1 ]; then
    # External monitor connected → disable laptop screen
    hyprctl keyword monitor "$LAPTOP,disable"
else
    # Only laptop screen → enable it
    hyprctl keyword monitor "$LAPTOP,preferred,auto,1"
fi
