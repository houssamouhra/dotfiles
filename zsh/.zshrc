# Enable Powerlevel10k instant prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Disable Oh-My-Zsh auto update
DISABLE_AUTO_UPDATE=true

# Zinit Plugin Manager
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [[ ! -d $ZINIT_HOME ]]; then
  mkdir -p "$(dirname $ZINIT_HOME)"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi
source "$ZINIT_HOME/zinit.zsh"

# Disable Oh-My-Zsh syntax highlighting
unset ZSH_HIGHLIGHT_HIGHLIGHTERS
ZSH_HIGHLIGHT_HIGHLIGHTERS=()

# Cargo
export PATH="$HOME/.cargo/bin:$PATH"

# Oh-My-Zsh base
export ZSH="$HOME/.oh-my-zsh"
source $ZSH/oh-my-zsh.sh

# Environment setup
if [ -f ~/.brew_env ]; then
  source ~/.brew_env
else
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)" && \
  /home/linuxbrew/.linuxbrew/bin/brew shellenv >~/.brew_env
fi

# NVM setup
export NVM_DIR="$HOME/.nvm"
if [ -s "$NVM_DIR/nvm.sh" ]; then
  source "$NVM_DIR/nvm.sh"
fi
if [ -s "$NVM_DIR/bash_completion" ]; then
  source "$NVM_DIR/bash_completion"
fi


# # Use ssh-agent + manual unlock once per session
# if ! pgrep -u "$USER" ssh-agent >/dev/null 2>&1; then
#   eval "$(ssh-agent -s)" >/dev/null 2>&1
# fi

# ssh-add -l >/dev/null 2>&1 || ssh-add ~/.ssh/id_ed25519 >/dev/null 2>&1

# ---- PinkCodes Completion Menu Styling ----
# Remove Completion Inline Highlighting
zstyle -d ':completion:*' list-colors

autoload -Uz compinit
compinit -C  # use cached completion dump

# Powerlevel10k theme
zinit ice depth=1; 
zinit light romkatv/powerlevel10k
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

# History & Keybindings
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
setopt sharehistory hist_ignore_all_dups appendhistory

bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward

# MISC
alias ls='ls --color=auto'
export BROWSER="brave-browser"

# pnpm
export PNPM_HOME="/home/houssam/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# Load fast-syntax-highlighting with overrides
zinit ice wait lucid atload"
  FAST_HIGHLIGHT_STYLES[single-hyphen-option]='none'
  FAST_HIGHLIGHT_STYLES[double-hyphen-option]='none'
  FAST_HIGHLIGHT_STYLES[path]='none'
  FAST_HIGHLIGHT_STYLES[path-to-dir]='none'
  FAST_HIGHLIGHT_STYLES[path_pathseparator]='none'
  FAST_HIGHLIGHT_STYLES[assign]='none'
"
zinit load zdharma-continuum/fast-syntax-highlighting

# Plugins
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-completions

