# Zsh plugin manager
source ~/.antidote/antidote.zsh

zsh_plugins="${ZDOTDIR:-$HOME}/.zsh_plugins"

if [[ ! -f "${zsh_plugins}.zsh" ]] || [[ "${zsh_plugins}.txt" -nt "${zsh_plugins}.zsh" ]]; then
  antidote bundle < "${zsh_plugins}.txt" > "${zsh_plugins}.zsh"
fi

source "${zsh_plugins}.zsh"

# Starship
_starship_lazy() {
  unfunction _starship_lazy
  eval "$(command starship init zsh)"
}
autoload -Uz add-zsh-hook
add-zsh-hook precmd _starship_lazy

# Keychain / ssh-agent
_ssh_agent_lazy() {
  if [[ -n "$SSH_AUTH_SOCK" && -S "$SSH_AUTH_SOCK" ]]; then
    return 0
  fi

  if [[ -f ~/.keychain/$HOST-sh ]]; then
    source ~/.keychain/$HOST-sh
  fi

  if [[ -z "$SSH_AUTH_SOCK" || ! -S "$SSH_AUTH_SOCK" ]]; then
    eval "$(keychain --eval --quiet --nogui --timeout 480 ~/.ssh/id_ed25519)"
  fi
}

# zoxide
z() {
  unset -f z
  eval "$(zoxide init zsh)"
  z "$@"
}

# fnm
_fnm_lazy_load() {
  if [[ -f package.json || -d node_modules || -f .nvmrc ]]; then
    eval "$(fnm env)" 2>/dev/null
    add-zsh-hook -d precmd _fnm_lazy_load
  fi
}
autoload -Uz add-zsh-hook
add-zsh-hook precmd _fnm_lazy_load

# Manual fnm trigger
fnm-on() {
  eval "$(fnm env)" 2>/dev/null
  echo "Node activated"
}

# pnpm
pnpm() {
  unfunction pnpm
  [ -f "$PNPM_HOME/pnpm.sh" ] && source "$PNPM_HOME/pnpm.sh"
  pnpm "$@"
}

# HISTORY & KEYBINDINGS
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
setopt sharehistory hist_ignore_all_dups appendhistory
setopt hist_reduce_blanks hist_verify inc_append_history

bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward

# fd
export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"

_fzf_compgen_path() { fd --hidden --exclude .git . "$1" }
_fzf_compgen_dir()  { fd --type=d --hidden --exclude .git . "$1" }

# fzf-git.sh
git() {
  unfunction git
  if [[ -f ~/fzf-git/fzf-git.sh ]]; then
    source ~/fzf-git/fzf-git.sh
  fi
  command git "$@"
}

show_file_or_dir_preview='
if [ -d {} ]; then
  eza --tree --color=always {} | head -200
else
  bat -n --color=always --line-range :500 {}
fi
'

export FZF_CTRL_T_OPTS="--preview '$show_file_or_dir_preview'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"

_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd)           fzf --preview 'eza --tree --color=always {} | head -200' "$@" ;;
    export|unset) fzf --preview "eval 'echo \${}'"         "$@" ;;
    ssh)          fzf --preview 'dig {}'                   "$@" ;;
    *)            fzf --preview "$show_file_or_dir_preview" "$@" ;;
  esac
}

# fzf
_fzf_init() {
  unfunction _fzf_init 2>/dev/null
  command -v fzf >/dev/null || return 1
  eval "$(command fzf --zsh)"
}

# Lazy bind Ctrl+T
_fzf_file_widget_lazy() {
  _fzf_init
  zle fzf-file-widget
}
zle -N _fzf_file_widget_lazy
bindkey '^T' _fzf_file_widget_lazy

# Lazy bind Alt+C
_fzf_cd_widget_lazy() {
  _fzf_init
  zle fzf-cd-widget
}

zle -N _fzf_cd_widget_lazy
bindkey '^[c' _fzf_cd_widget_lazy   # Alt+C

# Load aliases
source "$ZDOTDIR/aliases.zsh" 2>/dev/null || true
