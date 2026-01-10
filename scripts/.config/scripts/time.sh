#!/bin/bash

CATEGORIES=(
    "WORK"
    "NVIM"
	"WASTE" 
	"STOP"
)

BLOCKED_DOMAINS=(
  "www.youtube.com"
  "www.reddit.com"
  "www.x.com"
  "www.linkedin.com"
)

selected=$(printf "%s\n" "${CATEGORIES[@]}" | sk --margin 10% --color="bw" --bind 'q:abort') || exit 0

# ---------- VALIDATION ----------
is_valid_category=false
for c in "${CATEGORIES[@]}"; do
  [[ "$selected" == "$c" ]] && is_valid_category=true
done

[[ "$is_valid_category" == false ]] && exit 1

# Functions

update_tmux_status() {
  local category="$1"
  local total=""

  if [[ "$category" != "STOP" ]]; then
    total=$(timew | awk '/^ *Total/ {print $NF}')
  fi

  tmux set -g @time_category "$category"
  tmux set -g @time_total "$total"
}

block_sites() {
  sudo -v
  for domain in "${BLOCKED_DOMAINS[@]}"; do
    sudo hostess add "$domain" 127.0.0.1 >/dev/null 2>&1 || true
  done
}

unblock_sites() {
  sudo -v
  for domain in "${BLOCKED_DOMAINS[@]}"; do
    sudo hostess rm "$domain" >/dev/null 2>&1 || true
  done
}

# ---------- CATEGORY DISPATCH ----------
case "$selected" in
  STOP)
    timew stop >/dev/null 2>&1 
    tmux set -g @time_category ""
    ~/.config/scripts/bell.sh
    unblock_sites
    exit 0
    ;;
  WASTE)
    timew start "$selected" >/dev/null 2>&1
        tmux set -g @time_category "WASTE" 
	~/.config/scripts/bell.sh
	unblock_sites
	;;
  WORK|NVIM)
    timew start "$selected" >/dev/null 2>&1
    tmux set -g @time_category "WORK"
    ~/.config/scripts/bell.sh
    block_sites
    ;;
esac

update_tmux_status "$selected"
