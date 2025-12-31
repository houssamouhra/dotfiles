uptime_s=$(cut -d' ' -f1 /proc/uptime | awk '{printf "%.0f",$1}')
printf "%02d:%02d\n" $((uptime_s/3600)) $(((uptime_s%3600)/60))
