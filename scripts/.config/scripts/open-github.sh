#!/usr/bin/env bash

# Get pane path
pane_path=$(tmux display-message -p "#{pane_current_path}") || exit 1
cd "$pane_path" || exit 1

# Get git remote
url=$(git remote get-url origin 2>/dev/null)

# If not a git repo
if [[ -z "$url" ]]; then
    tmux display-message "Not a Git repo..."
    exit 0
fi

# Convert SSH → HTTPS
if [[ $url == git@github.com:* ]]; then
  url="${url#git@github.com:}"
  url="https://github.com/${url%.git}"
elif [[ $url == https://github.com/* ]]; then
  url="${url%.git}"
else
  exit 0
fi

# Open browser (Linux)
xdg-open "$url" >/dev/null 2>&1 &

