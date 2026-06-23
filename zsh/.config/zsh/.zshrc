# Load modular configs
for f in history keybinds aliases fzf highlighting; do
    [[ -f "${ZSH_CONFIG_DIR:?}/$f.zsh" ]] && source "$ZSH_CONFIG_DIR/$f.zsh"
done

# Enable precmd/exec hooks
autoload -U add-zsh-hook

# Load plugins via Antidote
export ANTIDOTE_ZSH="$XDG_CONFIG_HOME/.antidote/antidote.zsh"

[[ -f "$ANTIDOTE_ZSH" ]] && source "$ANTIDOTE_ZSH"

command -v antidote >/dev/null 2>&1 || return

plugin_list="$ZSH_PLUGIN_DIR/.zsh_plugins.txt"
plugin_cache="$ZSH_PLUGIN_DIR/plugins.zsh"

[[ -f "$plugin_list" ]] || return

if [[ ! -f "$plugin_cache" || "$plugin_list" -nt "$plugin_cache" ]]; then
    antidote bundle < "$plugin_list" > "$plugin_cache"
fi
source "$plugin_cache"

# Starship prompt lazy load
_starship_lazy() {
    unfunction _starship_lazy
    eval "$(starship init zsh)"
}
add-zsh-hook precmd _starship_lazy

# SSH Agent / Keychain
_ssh_agent_lazy() {
    if [[ -n "$SSH_AUTH_SOCK" && -S "$SSH_AUTH_SOCK" ]] &&
    ssh-add -l >/dev/null 2>&1; then
        echo "SSH agent already active"
        return 0
    fi

    [[ -f ~/.keychain/"$HOST"-sh ]] && source ~/.keychain/"$HOST"-sh
    eval "$(keychain --eval --quiet --nogui --timeout 480 ~/.ssh/id_ed25519)" &&
    echo "SSH agent started"
}

# zoxide integration
z() {
    unset -f z
    eval "$(zoxide init zsh)"
    z "$@"
}

# fnm lazy load
_fnm_lazy_load() {
    if [[ -f package.json ]]; then

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
        [[ -f "$ZSH_PLUGIN_DIR/colored-man-pages.plugin.zsh" ]] && source "$ZSH_PLUGIN_DIR/colored-man-pages.plugin.zsh"
        zsh_first_prompt_loaded=1
    fi
}
add-zsh-hook precmd colored_man_pages
