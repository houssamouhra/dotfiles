#!/usr/bin/env bash

selected=$(tmux list-sessions -F "#{session_name}" |
	fzf --preview "tmux list-windows -t {}")

[ -n "$selected" ] && tmux switch-client -t "$selected" 2>/dev/null || tmux attach -t "$selected"
