setopt prompt_subst

# Fancy git info on the right hand side
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' stagedstr '%F{4}●'
zstyle ':vcs_info:*' unstagedstr '%F{3}✚'
zstyle ':vcs_info:*' formats       '%F{92}%F{64}%b%m%c%u'
zstyle ':vcs_info:*' actionformats '%F{64}%b%m%c%u%F{15}|%F{1}%a'
zstyle ':vcs_info:git*+set-message:*' hooks git-status

function +vi-git-status(){
    local untracked ahead behind
    local -a gitstatus

    ahead=$(git rev-list ${hook_com[branch]}@{upstream}..HEAD 2>/dev/null | wc -l)
    (( $ahead )) && gitstatus+=( "%F{12}↑${ahead}" )

    behind=$(git rev-list HEAD..${hook_com[branch]}@{upstream} 2>/dev/null | wc -l)
    (( $behind )) && gitstatus+=( "%F{9}↓${behind}" )


    while IFS=$'\n' read line; do
        if [[ "$line" =~ '^\?\? ' ]]; then
            [[ -n $untracked ]] && continue || untracked='yes'
        fi
    done <<(git status --porcelain 2> /dev/null)

    [[ -n $untracked ]] && hook_com[unstaged]+='%F{241}…%f'
    hook_com[misc]+=${(j:/:)gitstatus}
}

precmd () { vcs_info }

# Set normal, left hand prompt
PROMPT='%(?.%K{22}%F{249}.%K{88}%F{249})%3~ %(?.%F{22}.%F{88})%k%f '
RPROMPT='${vcs_info_msg_0_}'