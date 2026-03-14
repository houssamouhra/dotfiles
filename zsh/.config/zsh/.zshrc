# Load configs
[[ -f "$XDG_CONFIG_DIR/history.zsh" ]] && source "$XDG_CONFIG_DIR/history.zsh"
[[ -f "$XDG_CONFIG_DIR/keybinds.zsh" ]] && source "$XDG_CONFIG_DIR/keybinds.zsh"
[[ -f "$XDG_CONFIG_DIR/aliases.zsh" ]] && source "$XDG_CONFIG_DIR/aliases.zsh"
[[ -f "$XDG_CONFIG_DIR/fzf.zsh" ]] && source "$XDG_CONFIG_DIR/fzf.zsh"
[[ -f "$XDG_CONFIG_DIR/highlighting.zsh" ]] && source "$XDG_CONFIG_DIR/highlighting.zsh"

# Load plugins
source ~/.antidote/antidote.zsh
zsh_plugins="$XDG_PLUGIN_DIR/.zsh_plugins"
if [[ ! -f "${zsh_plugins}.zsh" || "$XDG_PLUGIN_DIR/.zsh_plugins.txt" -nt "${zsh_plugins}.zsh" ]]; then
  antidote bundle < "$XDG_PLUGIN_DIR/.zsh_plugins.txt" > "${zsh_plugins}.zsh"
fi
source "${zsh_plugins}.zsh"
autoload -Uz add-zsh-hook

# Starship
_starship_lazy() {
  unfunction _starship_lazy
  eval "$(command starship init zsh)"
}
autoload -Uz add-zsh-hook
add-zsh-hook precmd _starship_lazy

# Keychain / ssh-agent
_ssh_agent_lazy() {
  if [[ -n "$SSH_AUTH_SOCK" && -S "$SSH_AUTH_SOCK" ]] &&
     ssh-add -l >/dev/null 2>&1; then
    return 0
  fi
  [[ -f ~/.keychain/"$HOST"-sh ]] && source ~/.keychain/"$HOST"-sh
  eval "$(keychain --eval --quiet --nogui --timeout 480 ~/.ssh/id_ed25519)"
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
  fi
}
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

# Clear screen but keep current command buffer
clear-screen-and-scrollback() {
  echoti civis >"$TTY"
  printf '\033[H\033[2J\033[3J' >"$TTY"
  echoti cnorm >"$TTY"
  zle redisplay
}
zle -N clear-screen-and-scrollback
bindkey '^Xl' clear-screen-and-scrollback
