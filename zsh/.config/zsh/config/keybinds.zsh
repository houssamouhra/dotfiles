bindkey -e

# Cursor movement
bindkey '^a' beginning-of-line
bindkey '^e' end-of-line
bindkey '^j' backward-char
bindkey '^k' forward-char

# Editing
bindkey '^w' backward-kill-word
bindkey '^u' backward-kill-line
bindkey '^_' undo

# History
bindkey '^[[A' history-beginning-search-backward
bindkey '^[[B' history-beginning-search-forward
bindkey '^P' history-substring-search-up
bindkey '^N' history-substring-search-down

# Shortcuts
bindkey -s '^f' 'tmux-sessionizer\n'

# History substring configuration
HISTORY_SUBSTRING_SEARCH_ENSURE_UNIQUE=1
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND='bold,underline'
