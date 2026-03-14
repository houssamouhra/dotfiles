# XDG base dirs
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_CONFIG_DIR="$ZDOTDIR/config"
export XDG_PLUGIN_DIR="$ZDOTDIR/plugins"

# tools dir
export STARSHIP_CONFIG="$XDG_CONFIG_HOME/starship/starship.toml"
export PNPM_HOME="$XDG_DATA_HOME/pnpm"

# programs & terminal
export EDITOR="nvim"
export VISUAL="nvim"
export TERMINAL="ghostty"

# cursor 
export XCURSOR_THEME="Bibata-Modern-Classic" 
export XCURSOR_SIZE="22"
export GTK_CURSOR_THEME="$XCURSOR_THEME"

typeset -gU path

path=(
  $HOME/.cargo/bin
  $PNPM_HOME
  $HOME/.config/scripts
  $path
)
