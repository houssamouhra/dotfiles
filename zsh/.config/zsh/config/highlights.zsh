typeset -gA FAST_HIGHLIGHT_STYLES

# Minimal syntax highlights
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
FAST_HIGHLIGHT_STYLES[commandseparator]='fg=240'
FAST_HIGHLIGHT_STYLES[reserved-word]='fg=13'

# History substring configuration
HISTORY_SUBSTRING_SEARCH_ENSURE_UNIQUE=1
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND='bold,underline'
