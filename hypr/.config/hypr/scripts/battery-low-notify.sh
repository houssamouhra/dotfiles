#!/usr/bin/env bash

# CONFIGURATION
BATTERY="BAT0"
CHECK_INTERVAL=120
COOLDOWN=900 # 15 min per threshold

NOTIFY_TITLE="Battery Low!"
NOTIFY_URGENCY="critical"
NOTIFY_CMD="/usr/bin/notify-send"

NOTIFY_MSG_20="Battery at {PERCENT}% — better plug in soon!"
NOTIFY_MSG_12="Battery at {PERCENT}% — connect charger soon!"
NOTIFY_MSG_10="Only {PERCENT}% battery left — plug in NOW!"

SOUND="$HOME/.config/waybar/sounds/low-battery.mp3"

# LOGIC
declare -A last_notified
THRESHOLDS=(20 12 10)

while true; do
	if [[ ! -d "/sys/class/power_supply/$BATTERY" ]]; then
		echo "Error: Battery $BATTERY not found" >&2
		sleep 60
		continue
	fi

	capacity=$(cat "/sys/class/power_supply/$BATTERY/capacity" 2>/dev/null)
	status=$(cat "/sys/class/power_supply/$BATTERY/status" 2>/dev/null)

	# Skip if invalid read or already charging/full
	[[ -z "$capacity" || "$status" = "Charging" || "$status" = "Full" ]] && {
		sleep "$CHECK_INTERVAL"
		continue
	}

	current_time=$(date +%s)

	for thresh in "${THRESHOLDS[@]}"; do
		if ((capacity <= thresh)); then
			last=${last_notified[$thresh]:-0}

			if ((last + COOLDOWN < current_time)); then
				# Select message based on threshold
				case $thresh in
				10) msg="${NOTIFY_MSG_10//"{PERCENT}"/$capacity}" ;;
				12) msg="${NOTIFY_MSG_12//"{PERCENT}"/$capacity}" ;;
				20) msg="${NOTIFY_MSG_20//"{PERCENT}"/$capacity}" ;;
				*) msg="Battery at ${capacity}% (level $thresh)" ;;
				esac

				"$NOTIFY_CMD" \
					-u "$NOTIFY_URGENCY" \
					-a "battery-notify" \
					-i "battery-low-symbolic" \
					"$NOTIFY_TITLE" \
					"$msg"

				# Play sound for all levels
				[[ -f "$SOUND" ]] && paplay --volume=60000 "$SOUND" &>/dev/null &

				last_notified[$thresh]=$current_time
			fi
		fi
	done

	sleep "$CHECK_INTERVAL"
done
