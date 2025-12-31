#!/usr/bin/env bash

# Find Spotify-like player
PLAYER="spotify"

# Check if Spotify is running
playerctl -p "$PLAYER" status &>/dev/null || exit 0

# If Spotify isn't running, exit silently
[ -z "$PLAYER" ] && exit 0

status=$(playerctl -p "$PLAYER" status 2>/dev/null) || exit 0
title=$(playerctl -p "$PLAYER" metadata xesam:title 2>/dev/null)
artist=$(playerctl -p "$PLAYER" metadata xesam:artist 2>/dev/null)

case "$status" in
  Playing) icon=" ";;
  Paused)  icon="";;
  *) exit 0 ;;
esac

if [[ -n "$title" ]]; then
  echo "$icon $title"
else
  echo "$icon"
fi
