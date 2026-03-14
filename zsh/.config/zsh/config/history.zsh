HISTSIZE=100000
HISTFILE="$XDG_CACHE_HOME/zsh_history"
SAVEHIST=$HISTSIZE
setopt sharehistory hist_ignore_all_dups appendhistory
setopt hist_reduce_blanks hist_verify inc_append_history
