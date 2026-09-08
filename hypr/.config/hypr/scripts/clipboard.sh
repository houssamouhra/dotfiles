#!/usr/bin/env bash

FUZZEL_CONFIG="$HOME/.config/fuzzel/clipboard.ini"

while true; do
  selected=$(
    cliphist list |
      fuzzel \
        --dmenu \
        --config "$FUZZEL_CONFIG" \
        --placeholder "Browse clipboard  (Ctrl+X = delete)" \
        --with-nth 2
  )
  exit_code=$?

  # Cancelled (Esc) or empty → quit the whole menu
  if [[ $exit_code -eq 1 || $exit_code -eq 2 || -z "$selected" ]]; then
    exit 0
  fi

  # Ctrl+X → delete and stay in the menu
  if [[ $exit_code -eq 10 ]]; then
    full_line=$(cliphist list | grep -F "$selected" | head -n1)
    [[ -n "$full_line" ]] && printf '%s' "$full_line" | cliphist delete
    continue # ← go back to the menu
  fi

  # Normal Enter → copy and quit
  printf '%s' "$selected" | cliphist decode | wl-copy
  exit 0
done
