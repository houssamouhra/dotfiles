# Load modular configs
[[ -f "$XDG_CONFIG_DIR/history.zsh" ]] && source "$XDG_CONFIG_DIR/history.zsh"
[[ -f "$XDG_CONFIG_DIR/keybinds.zsh" ]] && source "$XDG_CONFIG_DIR/keybinds.zsh"
[[ -f "$XDG_CONFIG_DIR/aliases.zsh" ]] && source "$XDG_CONFIG_DIR/aliases.zsh"
[[ -f "$XDG_CONFIG_DIR/fzf.zsh" ]] && source "$XDG_CONFIG_DIR/fzf.zsh"
[[ -f "$XDG_CONFIG_DIR/highlighting.zsh" ]] && source "$XDG_CONFIG_DIR/highlighting.zsh"

# Enable precmd/exec hooks
autoload -U add-zsh-hook

# Load plugins via Antidote
source ~/.antidote/antidote.zsh
zsh_plugins="$XDG_PLUGIN_DIR/.zsh_plugins"
if [[ ! -f "${zsh_plugins}.zsh" || "$XDG_PLUGIN_DIR/.zsh_plugins.txt" -nt "${zsh_plugins}.zsh" ]]; then
    antidote bundle < "$XDG_PLUGIN_DIR/.zsh_plugins.txt" > "${zsh_plugins}.zsh"
fi
source "${zsh_plugins}.zsh"

# Starship prompt lazy load
_starship_lazy() {
    unfunction _starship_lazy
    eval "$(command starship init zsh)"
}
add-zsh-hook precmd _starship_lazy

# SSH Agent / Keychain
_ssh_agent_lazy() {
    if [[ -n "$SSH_AUTH_SOCK" && -S "$SSH_AUTH_SOCK" ]] &&
    ssh-add -l >/dev/null 2>&1; then
        return 0
    fi
    [[ -f ~/.keychain/"$HOST"-sh ]] && source ~/.keychain/"$HOST"-sh
    eval "$(keychain --eval --quiet --nogui --timeout 480 ~/.ssh/id_ed25519)"
}

# zoxide integration
z() {
    unset -f z
    eval "$(zoxide init zsh)"
    z "$@"
}

# fnm lazy load
_fnm_lazy_load() {
    if [[ -f package.json \
       || -f .nvmrc \
       || -d node_modules ]]; then

        eval "$(fnm env)" 2>/dev/null  || return
        add-zsh-hook -d chpwd _fnm_lazy_load
    fi
}
_fnm_lazy_load
add-zsh-hook chpwd _fnm_lazy_load

# fnm manual activation
fnm-on() {
    eval "$(fnm env)" 2>/dev/null
    echo "Node activated"
}

# Colored man pages lazy load
typeset -g zsh_first_prompt_loaded=0

colored_man_pages() {
    if (( zsh_first_prompt_loaded == 0 )); then
        autoload -U colors && colors
        [[ -f "$XDG_PLUGIN_DIR/colored-man-pages.plugin.zsh" ]] && source "$XDG_PLUGIN_DIR/colored-man-pages.plugin.zsh"
        zsh_first_prompt_loaded=1
    fi
}
add-zsh-hook precmd colored_man_pages
