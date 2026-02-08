#!/bin/bash

pkill -x radeontop 2>/dev/null

LOCK="/tmp/waybar-gpu.lock"

exec 9>"$LOCK" || exit 1
flock -n 9 || exit 0
trap "pkill -P $$ radeontop" EXIT

radeontop -d - | while read -r line; do
    gpu=$(echo "$line" | awk -F'[, ]+' '
      {for(i=1;i<=NF;i++) if($i=="gpu"){gsub("%","",$(i+1)); printf "%d\n", $(i+1)+0.5}}')

    vram=$(echo "$line" | awk -F'[, ]+' '{for(i=1;i<=NF;i++) if($i=="vram"){print $(i+2)}}')
    mclk=$(echo "$line" | awk -F'[, ]+' '{for(i=1;i<=NF;i++) if($i=="mclk"){print $(i+2)}}')
    sclk=$(echo "$line" | awk -F'[, ]+' '{for(i=1;i<=NF;i++) if($i=="sclk"){print $(i+2)}}')

    [ -n "$gpu" ] &&
        echo "{\"text\":\"$gpu\", \"tooltip\":\"VRAM: $vram\nMCLK: $mclk\nSCLK: $sclk\"}"
done
