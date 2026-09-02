#!/usr/bin/env bash

FUZZEL_CONFIG="$HOME/.config/fuzzel/clipboard.ini"

mapfile -t entries < <(cliphist list)

display=$(
  printf '%s\n' "${entries[@]}" |
    sed 's/^[^	]*	//' |
    fuzzel \
      --dmenu \
      --config "$FUZZEL_CONFIG" \
      --placeholder "Browse clipboard" \
      --index
)

[ -z "$display" ] && exit 0

index="${display%%$'\t'*}"

printf '%s\n' "${entries[$index]}" | cliphist decode | wl-copy
