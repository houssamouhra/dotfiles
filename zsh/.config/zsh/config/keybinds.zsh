bindkey -e
bindkey "^a" beginning-of-line
bindkey "^e" end-of-line
bindkey '^j' backward-char
bindkey '^k' forward-char
bindkey '^w' backward-kill-word
bindkey '^u' backward-kill-line
bindkey '^_' undo
bindkey '^[[A' history-beginning-search-backward
bindkey '^[[B' history-beginning-search-forward
bindkey '^R' fzf-history-widget
bindkey -s ^f "tmux-sessionizer"
