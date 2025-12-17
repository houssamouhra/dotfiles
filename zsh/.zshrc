# ~/.zshrc

eval "$(starship init zsh)"

# Zinit Plugin Manager
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [[ ! -d $ZINIT_HOME ]]; then
  mkdir -p "$(dirname $ZINIT_HOME)"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi
source "$ZINIT_HOME/zinit.zsh"

# Cargo
export PATH="$HOME/.cargo/bin:$PATH"

# Read script from this path
export PATH="$HOME/.local/bin:$PATH"

autoload -Uz compinit
compinit -C  # use cached completion dump

# History & Keybindings
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
setopt sharehistory hist_ignore_all_dups appendhistory

bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward

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

# Linuxbrew
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# pnpm
export PNPM_HOME="/home/houssam/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# NVM setup
export NVM_DIR="$HOME/.nvm"
if [ -s "$NVM_DIR/nvm.sh" ]; then
  source "$NVM_DIR/nvm.sh"
fi
if [ -s "$NVM_DIR/bash_completion" ]; then
  source "$NVM_DIR/bash_completion"
fi

# aliases
alias bye='sudo shutdown -h now'
alias fonts='fc-list -f "%{family}\n"'
alias pacup='sudo pacman -Rns $(pacman -Qdtq)'
alias tasks='btm'
alias n='nvim'


# pnpm
export PNPM_HOME="/home/houssam/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

