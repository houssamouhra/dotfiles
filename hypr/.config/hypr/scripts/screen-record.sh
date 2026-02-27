#!/usr/bin/env bash

PID_FILE="/tmp/screenrec.pid"
VIDEO_DIR="$HOME/Videos"
mkdir -p "$VIDEO_DIR"

if [ -f "$PID_FILE" ] && kill -0 "$(cat "$PID_FILE")" 2>/dev/null; then
	kill -INT "$(cat "$PID_FILE")"
	rm -f "$PID_FILE"
	notify-send "Recording stopped"
else
	TIMESTAMP=$(date +%Y-%m-%d_%H-%M-%S)
	OUTPUT="$VIDEO_DIR/recording_$TIMESTAMP.mkv"
	SYSTEM_MONITOR="bluez_output.1C:6E:4C:B1:91:E4" # your audio device

	wf-recorder -f "$OUTPUT" -a "$SYSTEM_MONITOR" &
	echo $! >"$PID_FILE"
	notify-send "Recording started → $OUTPUT"
fi
