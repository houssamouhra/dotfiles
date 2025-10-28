# ======================================
# Fast minimal startup
# ======================================

# Enable Powerlevel10k instant prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Disable Oh My Zsh auto update
DISABLE_AUTO_UPDATE=true

# Oh My Zsh base
export ZSH="$HOME/.oh-my-zsh"
source $ZSH/oh-my-zsh.sh

# ======================================
# Environment setup
# ======================================
if [ -f ~/.brew_env ]; then
  source ~/.brew_env
else
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)" && \
  /home/linuxbrew/.linuxbrew/bin/brew shellenv >~/.brew_env
fi

# NVM setup
export NVM_DIR="$HOME/.nvm"
lazy_nvm() {
  unset -f node npm npx pnpm lazy_nvm
  [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" --no-use
  [ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"
}
for cmd in node npm npx pnpm; do
  eval "alias $cmd='lazy_nvm; $cmd'"
done


# ======================================
# Zinit & plugins
# ======================================
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [[ ! -d $ZINIT_HOME ]]; then
  mkdir -p "$(dirname $ZINIT_HOME)"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi
source "$ZINIT_HOME/zinit.zsh"

autoload -Uz compinit
compinit -C  # use cached completion dump

zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
wait

# Powerlevel10k theme 
zinit ice depth=1; zinit light romkatv/powerlevel10k
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

# ======================================
# History & Keybindings
# ======================================
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
setopt sharehistory hist_ignore_all_dups appendhistory
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward

# ======================================
# Completions & FZF (on-demand)
# ======================================
command -v fzf >/dev/null && eval "$(fzf --zsh)"
alias ls='ls --color=auto'
