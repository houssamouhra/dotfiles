# XDG base directories
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_BIN_HOME="$HOME/.local/bin"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_CONFIG_DIR="$ZDOTDIR/config"
export XDG_PLUGIN_DIR="$ZDOTDIR/plugins"

# Tools configuration directories
export STARSHIP_CONFIG="$XDG_CONFIG_HOME/starship/starship.toml"
export CARGO_BIN_HOME="$HOME/.cargo/bin"
export PNPM_HOME="$XDG_DATA_HOME/pnpm"

# Default editor, terminal, and pagers
export EDITOR=nvim
export VISUAL=$EDITOR
export PAGER=less
export MANPAGER=$PAGER

# Cursor theme and size
export XCURSOR_THEME=Bibata-Modern-Classic
export XCURSOR_SIZE=22
export GTK_CURSOR_THEME=$XCURSOR_THEME

# PATH setup
# make path unique and global
typeset -gU path

path=(
    $XDG_BIN_HOME
    $CARGO_BIN_HOME
    $PNPM_HOME
    $path
)
