#!/usr/bin/env bash

# NVIDIA
if command -v nvidia-smi >/dev/null 2>&1; then
  util=$(nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits 2>/dev/null | head -n1)
  [ -n "$util" ] && { echo "${util}%"; exit 0; }
fi

# AMD
if [ -r /sys/class/drm/card0/device/gpu_busy_percent ]; then
  util=$(cat /sys/class/drm/card0/device/gpu_busy_percent 2>/dev/null)
  [ -n "$util" ] && { echo "${util}%"; exit 0; }
fi

# Intel (optional, falls intel_gpu_top installiert)
if command -v intel_gpu_top >/dev/null 2>&1; then
  util=$(intel_gpu_top -J -s 200 2>/dev/null | awk -F'[,:}]' '/"Render/"{gsub(/ /,"",$3); print int($3)"%"; exit}')
  [ -n "$util" ] && { echo "${util}"; exit 0; }
fi

# Wenn alles fehlschlägt
echo "N/A"

