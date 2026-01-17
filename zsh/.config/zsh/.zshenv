# XDG base dirs
export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}
export XDG_DATA_HOME=${XDG_DATA_HOME:-$HOME/.local/share}
export XDG_CACHE_HOME=${XDG_CACHE_HOME:-$HOME/.cache}
export STARSHIP_CONFIG="$XDG_CONFIG_HOME/starship/starship.toml"

# no deduplicate paths 
typeset -gU path fpath

# Tool paths
export PNPM_HOME="$HOME/.local/share/pnpm"
export HOMEBREW_PREFIX="/home/linuxbrew/.linuxbrew"
export FNM_PATH="$HOME/.local/share/fnm"

path=(
  $HOME/.cargo/bin
  $HOME/.config/scripts
  $PNPM_HOME
  $HOMEBREW_PREFIX
  $path
)

typeset -gA FAST_HIGHLIGHT_STYLES 2>/dev/null || true

# Minimal syntax highlighting
FAST_HIGHLIGHT_STYLES[default]='none'          
FAST_HIGHLIGHT_STYLES[arg0]='none'              
FAST_HIGHLIGHT_STYLES[path]='none'             
FAST_HIGHLIGHT_STYLES[path-to-dir]='none'     
FAST_HIGHLIGHT_STYLES[path_pathseparator]='none'
FAST_HIGHLIGHT_STYLES[single-hyphen-option]='none'
FAST_HIGHLIGHT_STYLES[double-hyphen-option]='none'
FAST_HIGHLIGHT_STYLES[back-dollar-quote]='none'
FAST_HIGHLIGHT_STYLES[globbing]='none'
FAST_HIGHLIGHT_STYLES[globbing-ext]='none'

# Subtle useful highlights
FAST_HIGHLIGHT_STYLES[commandseparator]='fg=8'
FAST_HIGHLIGHT_STYLES[reserved-word]='fg=8'

# Cursor
export XCURSOR_THEME="Breeze"
export XCURSOR_SIZE="24"

# Editors
export EDITOR="nvim"
export VISUAL="nvim"

