#!/bin/bash

# Default bell sound
SOUND="/usr/share/sounds/freedesktop/stereo/bell.oga"

# Play asynchronously so it doesn’t block tmux
paplay "$SOUND" &

