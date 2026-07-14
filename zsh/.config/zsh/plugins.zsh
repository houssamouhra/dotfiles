# Clone a plugin on first use (if missing) and source its
# standard <repo>.plugin.zsh entry point.
load-plugin() {
    emulate -L zsh

    # Validate arguments
    (($# >= 2)) || {
        print -u2 -P "%F{red}usage: load-plugin <owner> <repo> [defer]%f"
        return 1
    }

    local owner=$1
    local repo=$2
    local mode=$3
    local dir="$ZSH_PLUGIN_DIR/$repo"
    local entry="$dir/$repo.plugin.zsh"

    # Clone the plugin if it's not installed
    if [[ ! -d $dir ]]; then
        local err

        mkdir -p "$ZSH_PLUGIN_DIR" || return
        print -P "%F{green}+%f Installing $repo..."

        if ! err=$(git clone --depth=1 \
            "https://github.com/$owner/$repo" "$dir" >/dev/null 2>&1); then
            rm -rf "$dir"
            print -u2 -P "%F{red}✗ Failed to install $repo%f"
            print -u2 -- "$err"
            return 1
        fi

        print -P "%F{green}✓ Installed $repo%f"
    fi

    # Verify the plugin provides the expected entry point
    if [[ ! -r $entry ]]; then
        print -u2 -P "%F{red}Missing plugin entry:%f $entry"
        return 1
    fi

    # Defer plugin loading with zsh-defer
    if [[ $mode == defer ]]; then
        (($+functions[zsh-defer])) || {
            print -u2 -P "%F{red}'defer' mode requires zsh-defer%f"
            return 1
        }

        zsh-defer source "$entry"
    else
        source "$entry"
    fi
}

# Update all installed plugin repositories
update-plugin() {
    emulate -L zsh

    local dir old new

    # Iterate over plugin directories only
    for dir in "$ZSH_PLUGIN_DIR"/*(/); do
        [[ -d $dir/.git ]] || continue

        old=$(git -C "$dir" rev-parse HEAD)

        printf "%-32s" "${dir:t}"

        if git -C "$dir" fetch --depth=1 origin >/dev/null 2>&1 &&
            git -C "$dir" reset --hard "@{u}" >/dev/null 2>&1; then

            new=$(git -C "$dir" rev-parse HEAD)

            if [[ $old == $new ]]; then
                print -P "%F{8}○ Already up to date%f"
            else
                print -P "%F{green}✓ Updated%f"
            fi
        else
            print -u2 -P "%F{red}✗ Failed to update%f"
        fi
    done
}

# Load plugins
load-plugin romkatv zsh-defer
load-plugin mattmc3 ez-compinit defer
load-plugin zsh-users zsh-completions defer
load-plugin aloxaf fzf-tab defer
load-plugin zsh-users zsh-autosuggestions defer
load-plugin zsh-users zsh-history-substring-search defer
load-plugin houssamouhra colored-man-pages defer
load-plugin zdharma-continuum fast-syntax-highlighting defer
