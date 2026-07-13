# Plugins
_zplugin_load() {
    local owner=$1
    local repo=$2
    local dir="$ZSH_PLUGIN_DIR/$repo"
    local entry="$dir/$repo.plugin.zsh"

    if [[ ! -d $dir ]]; then
        mkdir -p "$ZSH_PLUGIN_DIR"
        print "Installing $repo..."

        if ! git clone --depth=1 "https://github.com/$owner/$repo" "$dir"; then
            print -u2 "Failed to install $repo"
            return 1
        fi
    fi

    if [[ ! -r $entry ]]; then
        print -u2 "Missing plugin entry: $entry"
        return 1
    fi

    source "$entry"
}

zplugin-update() {
    local dir

    for dir in "$ZSH_PLUGIN_DIR"/*(/); do
        [[ -d $dir/.git ]] || continue

        print "Updating ${dir:t}..."
        git -C "$dir" pull --ff-only
    done
}

_zplugin_load zsh-users zsh-completions
_zplugin_load mattmc3 ez-compinit
_zplugin_load aloxaf fzf-tab
_zplugin_load zsh-users zsh-autosuggestions
_zplugin_load zsh-users zsh-history-substring-search
_zplugin_load houssamouhra colored-man-pages
_zplugin_load zdharma-continuum fast-syntax-highlighting
