#!/usr/bin/env bash

CATEGORIES=(WORK NVIM WASTE STOP)

BLOCKED_DOMAINS=(
    "www.youtube.com"
    "www.reddit.com"
    "www.x.com"
    "www.linkedin.com"
)

selected=$(printf "%s\n" "${CATEGORIES[@]}" | fzf --bind 'q:abort') || exit 0

update_tmux_status() {
    [[ -z "$TMUX" ]] && return

    local category="$1"
    local total=""

    [[ "$category" != "STOP" ]] &&
        total=$(timew | awk '/^ *Total/ {print $NF}')

    tmux set -g @time_category "$category"
    tmux set -g @time_total "$total"
}

block_sites() {
    sudo -n true 2>/dev/null || sudo -v
    for domain in "${BLOCKED_DOMAINS[@]}"; do
        sudo hostess add "$domain" 127.0.0.1 >/dev/null 2>&1 || true
    done
}

unblock_sites() {
    sudo -n true 2>/dev/null || sudo -v
    for domain in "${BLOCKED_DOMAINS[@]}"; do
        sudo hostess rm "$domain" >/dev/null 2>&1 || true
    done
}

case "$selected" in
STOP)
    timew stop >/dev/null 2>&1
    update_tmux_status ""
    unblock_sites
    ;;
WASTE)
    timew stop >/dev/null 2>&1
    timew start "$selected"
    update_tmux_status "$selected"
    unblock_sites
    ;;
WORK | NVIM)
    timew stop >/dev/null 2>&1
    timew start "$selected"
    update_tmux_status "$selected"
    block_sites
    ;;
esac
