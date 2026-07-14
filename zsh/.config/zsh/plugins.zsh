# Clone a plugin on first use (if missing) and source its
# standard <repo>.plugin.zsh entry point.
_zplugin_load() {
    local owner=$1
    local repo=$2
    local mode=$3
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

    # Verify the plugin provides the expected entry point
    if [[ ! -r $entry ]]; then
        print -u2 "Missing plugin entry: $entry"
        return 1
    fi

    # Defer plugin loading with zsh-defer
    if [[ $mode == defer ]]; then
        (( $+functions[zsh-defer] )) || {
            print -u2 "'defer' mode requires zsh-defer"
            return 1
        }

        zsh-defer source "$entry"
    else
        source "$entry"
    fi
}

# Update all installed plugin repositories
zplugin-update() {
    local dir

    # Iterate over plugin directories only
    for dir in "$ZSH_PLUGIN_DIR"/*(/); do
        [[ -d $dir/.git ]] || continue

        print "Updating ${dir:t}..."
        git -C "$dir" pull --ff-only
    done
}

# Load plugins
_zplugin_load romkatv zsh-defer
_zplugin_load mattmc3 ez-compinit
_zplugin_load zsh-users zsh-completions
_zplugin_load aloxaf fzf-tab defer
_zplugin_load zsh-users zsh-autosuggestions defer
_zplugin_load zsh-users zsh-history-substring-search defer
_zplugin_load houssamouhra colored-man-pages defer
_zplugin_load zdharma-continuum fast-syntax-highlighting defer
