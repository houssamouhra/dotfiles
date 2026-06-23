# Requires colors autoload.
# See termcap(5).

# Set up once, and then reuse. This way it supports user overrides after the
# plugin is loaded.
typeset -AHg less_termcap
less_termcap[me]="${reset_color}"

# Bold & blinking text (e.g., headings or important keywords)
less_termcap[mb]="${fg_bold[magenta]}"
less_termcap[md]="${fg_bold[magenta]}"

# Standout mode (e.g., highlighted selections)
less_termcap[so]="${fg_bold[yellow]}${bg[black]}"
less_termcap[se]="${reset_color}"

# Underlining (e.g., links, man page sections)
less_termcap[us]="${fg_bold[blue]}"
less_termcap[ue]="${reset_color}"

# Optional extra: standout for options/flags
# This will make -f / --help really pop
less_termcap[op]="${fg_bold[orange]}"

# Handle $0 according to the standard:
# https://zdharma-continuum.github.io/Zsh-100-Commits-Club/Zsh-Plugin-Standard.html
0="${${ZERO:-${0:#$ZSH_ARGZERO}}:-${(%):-%N}}"
0="${${(M)0:#/*}:-$PWD/$0}"

# Absolute path to this file's directory.
typeset -g __colored_man_pages_dir="${0:A:h}"

function colored() {
    local -a environment

    # Convert associative array to plain array of NAME=VALUE items.
    local k v
    for k v in "${(@kv)less_termcap}"; do
        environment+=( "LESS_TERMCAP_${k}=${v}" )
    done

    # Prefer `less` whenever available, since we specifically configured
    # environment for it.
    environment+=( PAGER="${commands[less]:-$PAGER}" )
    environment+=( GROFF_NO_SGR=1 )

    # See ./nroff script.
    if [[ "$OSTYPE" = solaris* ]]; then
        environment+=( PATH="${__colored_man_pages_dir}:$PATH" )
    fi

    command env "${environment[@]}" "$@"
}

# Colorize man and dman/debman (from debian-goodies)
function man \
    dman \
    debman {
    colored $0 "$@"
}
