setopt PROMPT_SUBST

gitstatus_stop 'MY_PROMPT' 2>/dev/null
gitstatus_start -s -1 -u -1 -c -1 -d -1 -e 'MY_PROMPT'

git_prompt() {
    [[ $VCS_STATUS_RESULT == ok-sync ]] || return

    local -a segments

    ((VCS_STATUS_NUM_STAGED)) && segments+=("+${VCS_STATUS_NUM_STAGED}")
    ((VCS_STATUS_NUM_UNSTAGED)) && segments+=("!${VCS_STATUS_NUM_UNSTAGED}")
    ((VCS_STATUS_NUM_UNTRACKED)) && segments+=("?${VCS_STATUS_NUM_UNTRACKED}")
    ((deleted = VCS_STATUS_NUM_STAGED_DELETED + VCS_STATUS_NUM_UNSTAGED_DELETED))
    ((deleted)) && segments+=("✘${deleted}")
    ((VCS_STATUS_NUM_CONFLICTED)) && segments+=("=${VCS_STATUS_NUM_CONFLICTED}")
    ((VCS_STATUS_STASHES)) && segments+=("\$${VCS_STATUS_STASHES}")
    ((VCS_STATUS_COMMITS_AHEAD)) && segments+=("⇡${VCS_STATUS_COMMITS_AHEAD}")
    ((VCS_STATUS_COMMITS_BEHIND)) && segments+=("⇣${VCS_STATUS_COMMITS_BEHIND}")

    local ref=$VCS_STATUS_LOCAL_BRANCH

    [[ -z $ref && -n $VCS_STATUS_TAG ]] && ref="#$VCS_STATUS_TAG"
    [[ -z $ref ]] && ref="@${VCS_STATUS_COMMIT[1,8]}"

    printf "%%F{green}󰘬 %s%%f" "$ref"

    (($#segments)) && printf " %%B%%F{red}[%s]%%f%%b" "${(j: :)segments}"
}

path_prompt() {
    local path

    if [[ $VCS_STATUS_RESULT == ok-sync ]]; then

        if [[ $VCS_STATUS_WORKDIR != $_LAST_WORKTREE ]]; then
            _REPO_NAME=${VCS_STATUS_WORKDIR:t}
            _LAST_WORKTREE=$VCS_STATUS_WORKDIR
        fi

        if [[ $PWD == $VCS_STATUS_WORKDIR ]]; then
            printf "󰇘/%s" "$_REPO_NAME"
            return
        fi

        path="$_REPO_NAME/${PWD#$VCS_STATUS_WORKDIR/}"
    else
        path="${(%):-%~}"
    fi

    local parts=(${(s:/:)path})

    if (($#parts <= 2)); then
        printf "%s" "$path"
    else
        printf "󰇘/%s/%s" "${parts[-2]}" "${parts[-1]}"
    fi
}

precmd() {
    if gitstatus_query 'MY_PROMPT'; then
        GIT_INFO=$(git_prompt)
    else
        GIT_INFO=""
    fi

    if [[ ${_LAST_PWD-} != $PWD ]]; then
        PATH_INFO=$(path_prompt)
        _LAST_PWD=$PWD
    fi
}

PROMPT='
%F{blue}${PATH_INFO}%f ${GIT_INFO}
%F{magenta}➜%f '
