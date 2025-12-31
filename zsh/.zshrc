# PURE PROMPT
fpath+=($HOME/.config/pure)
autoload -U promptinit; promptinit
prompt pure

# DEFAULT EDITORS
export EDITOR="nvim"
export VISUAL="nvim"

# ZINIT PLUGIN MANAGER
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [[ ! -d $ZINIT_HOME ]]; then
  mkdir -p "$(dirname $ZINIT_HOME)"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi
source "$ZINIT_HOME/zinit.zsh"

# PATHS
export PATH="$HOME/.cargo/bin:$PATH"       # Cargo
export PATH="$HOME/scripts:$PATH"          # Personal scripts

# Linuxbrew
if [[ -x /home/linuxbrew/.linuxbrew/bin/brew ]]; then
  export HOMEBREW_PREFIX="/home/linuxbrew/.linuxbrew"
  export PATH="$HOMEBREW_PREFIX/bin:$HOMEBREW_PREFIX/sbin:$PATH"
fi

# PNPM
export PNPM_HOME="$HOME/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# COMPLETIONS
autoload -Uz compinit
compinit -C  # use cached completion dump

# HISTORY & KEYBINDINGS
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
setopt sharehistory hist_ignore_all_dups appendhistory

bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward

# SYNTAX HIGHLIGHTING
zinit ice wait lucid atload"
  FAST_HIGHLIGHT_STYLES[single-hyphen-option]='none'
  FAST_HIGHLIGHT_STYLES[double-hyphen-option]='none'
  FAST_HIGHLIGHT_STYLES[path]='none'
  FAST_HIGHLIGHT_STYLES[path-to-dir]='none'
  FAST_HIGHLIGHT_STYLES[path_pathseparator]='none'
  FAST_HIGHLIGHT_STYLES[assign]='none'
"
zinit load zdharma-continuum/fast-syntax-highlighting

# PLUGINS
zinit ice wait lucid
zinit light zsh-users/zsh-autosuggestions

zinit ice wait lucid
zinit light zsh-users/zsh-completions

# ZOXIDE
eval "$(zoxide init zsh)"

# NVM
export NVM_DIR="$HOME/.nvm"

_nvm_load() {
  unset -f nvm node npm npx
  source "$NVM_DIR/nvm.sh"
}

nvm()  { _nvm_load; nvm "$@"; }
node() { _nvm_load; node "$@"; }
npm()  { _nvm_load; npm "$@"; }
npx()  { _nvm_load; npx "$@"; }

# FZF
# Lazy-load fzf
_fzf_lazy() {
  unfunction fzf
  eval "$(fzf --zsh)"
  fzf "$@"
}
fzf() { _fzf_lazy "$@"; }

# FZF Theme
export FZF_DEFAULT_OPTS=" \
--color=bg+:#313244,bg:#1E1E2E,spinner:#F5E0DC,hl:#F38BA8 \
--color=fg:#CDD6F4,header:#F38BA8,info:#CBA6F7,pointer:#F5E0DC \
--color=marker:#B4BEFE,fg+:#CDD6F4,prompt:#CBA6F7,hl+:#F38BA8 \
--color=selected-bg:#45475A \
--color=border:#6C7086,label:#CDD6F4"

# Use fd instead of fzf
export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"

_fzf_compgen_path() { fd --hidden --exclude .git . "$1" }
_fzf_compgen_dir()  { fd --type=d --hidden --exclude .git . "$1" }

# fzf-git.sh lazy
_git_lazy() {
  unfunction git
  source ~/fzf-git.sh/fzf-git.sh
  git "$@"
}
git() { _git_lazy "$@" }

show_file_or_dir_preview="if [ -d {} ]; then eza --tree --color=always {} | head -200; else bat -n --color=always --line-range :500 {}; fi"

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

# BAT
export BAT_THEME='Catppuccin Mocha'

# ALIASES
alias bye='sudo shutdown -h now'
alias ls="eza --icons=always"
alias grep='grep --color=auto'
alias loop='sudo reboot'
alias fonts='fc-list -f "%{family}\n"'
alias pacup='pkgs=$(pacman -Qdtq); [ -n "$pkgs" ] && sudo pacman -Rns $pkgs || echo "No orphan packages to remove."'
alias update='sudo pacman -Syu'
alias tasks='btm'
alias n='nvim'
alias mediainfo='mediainfo --Inform="Audio;Bitrate: %BitRate% kb/s | %SamplingRate% %Hz | %BitDepth%-bit\n"'
