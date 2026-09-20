#!/usr/bin/env bash

# Tell mpc to use your socket
export MPD_HOST="/run/user/1000/mpd.socket"

status=$(mpc status 2>/dev/null | sed -n '2p')
title=$(mpc current -f "%title%" 2>/dev/null)

case "$status" in
*"[playing]"*) icon="  " ;;
*"[paused]"*) icon=" " ;;
*) icon="" ;;
esac

if [ -n "$title" ]; then
  echo "$icon$title"
else
  echo "$icon"
fi
