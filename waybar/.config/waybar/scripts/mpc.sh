#!/usr/bin/env bash
export MPD_HOST="/run/user/1000/mpd.socket"
exec mpc "$@"
