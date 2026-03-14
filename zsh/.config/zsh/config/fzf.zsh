# FZF unified preview function: directories -> tree, files -> bat
FZF_PREVIEW="--preview '$XDG_CONFIG_HOME/fzf/preview.sh {}'"
export FZF_DEFAULT_OPTS_FILE="$XDG_CONFIG_HOME/fzf/config"
export FZF_CTRL_T_OPTS="$FZF_PREVIEW \
--multi \
--bind 'ctrl-o:execute(nvim {+})+abort'" 
export FZF_ALT_C_OPTS="$FZF_PREVIEW"
export FZF_CTRL_R_OPTS="\
--height ${FZF_TMUX_HEIGHT:-50%} \
--reverse \
--scheme=history \
--exact \
--ansi \
--inline-info"

# Initialize fzf 
_fzf_init() {
  (( $+commands[fzf] )) || return
  (( $+functions[fzf-file-widget] )) && return
  eval "$(fzf --zsh)"
}

# Lazy loader for fzf
_fzf_history_lazy() {
  _fzf_init
  fzf-history-widget() {
    local selected ret=0
    setopt localoptions pipefail no_aliases 2>/dev/null 

    selected=$(
      fc -lnr 1 |
      awk '!seen[$0]++' |
      FZF_DEFAULT_OPTS="${FZF_DEFAULT_OPTS:-} ${FZF_CTRL_R_OPTS}" \
      fzf +m --query "$LBUFFER"
    )

    ret=$?
    [[ -z "$selected" ]] && { zle redisplay; return $ret; }

    LBUFFER="$selected"
    zle reset-prompt
  }

  zle -N fzf-history-widget
  zle fzf-history-widget
}
zle -N _fzf_history_lazy
bindkey '^R' _fzf_history_lazy

# Lazy bind Ctrl+T
_fzf_file_widget_lazy() {
  _fzf_init
  zle fzf-file-widget
}
zle -N _fzf_file_widget_lazy
bindkey '^T' _fzf_file_widget_lazy  # Ctlr+t

# Lazy bind Alt+C
_fzf_cd_widget_lazy() {
  _fzf_init
  zle fzf-cd-widget
}
zle -N _fzf_cd_widget_lazy
bindkey '^[c' _fzf_cd_widget_lazy   # Alt+C

# Lazy git-fzf integration (only when git is called) 
git() {
  unfunction git 2>/dev/null
  local fzf_git="${HOME}/fzf-git/fzf-git.sh"
  [[ -f "$fzf_git" ]] && source "$fzf_git" 2>/dev/null
  command git "$@"
}

# fzf ssh
fzf_ssh() {
  local host
  host=$(awk '/^Host / && $2 != "*" {print $2}' ~/.ssh/config | fzf --preview 'dig {} +short; ping -c1 {} 2>/dev/null | head -1')
  [[ -n $host ]] && ssh "$host"
}
