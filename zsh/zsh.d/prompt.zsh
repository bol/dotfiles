setopt prompt_subst
autoload -Uz add-zsh-hook

# Colors are 256-bit color
# Refer to chart here: https://upload.wikimedia.org/wikipedia/commons/1/15/Xterm_256color_chart.svg

# The private use Unicode symbols are picked from Powerline extra symbols,
# Prompt is intended to be used with a font that supports them.
# https://github.com/ryanoasis/powerline-extra-symbols

# Fancy git info
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' stagedstr '%F{018}●'
zstyle ':vcs_info:*' unstagedstr '%F{136}✚'
zstyle ':vcs_info:*' formats       '%K{239}%F{244}%K{244}%F{92}%F{022}%b%m%c%u%K{239}%F{244}'
zstyle ':vcs_info:*' actionformats '%K{239}%F{244}%K{244}%F{022}%b%m%c%u%F{244}|%F{088}%a%K{239}%F{244}'
zstyle ':vcs_info:git*+set-message:*' hooks git-status

function +vi-git-status(){
    local untracked ahead behind
    local -a gitstatus

    ahead=$(git rev-list ${hook_com[branch]}@{upstream}..HEAD 2>/dev/null | wc -l)
    (( $ahead )) && gitstatus+=( "%F{019}↑${ahead}" )

    behind=$(git rev-list HEAD..${hook_com[branch]}@{upstream} 2>/dev/null | wc -l)
    (( $behind )) && gitstatus+=( "%F{124}↓${behind}" )


    while IFS=$'\n' read line; do
        if [[ "$line" =~ '^\?\? ' ]]; then
            [[ -n $untracked ]] && continue || untracked='yes'
        fi
    done <<(git status --porcelain 2> /dev/null)

    [[ -n $untracked ]] && hook_com[unstaged]+='%F{241}…%f'
    hook_com[misc]+=${(j:/:)gitstatus}
}

add-zsh-hook -Uz precmd vcs_info

function k8s_info() {
  current_context=$(kubectl config current-context 2>/dev/null || echo '<none>')
  k8s_prompt="%K{239}%F{244}%K{244}%F{021}☸%F{239}${current_context}%K{239}%F{244}"
}

add-zsh-hook -Uz precmd k8s_info

NEWLINE=$'\n'
PROMPT='${k8s_prompt} %2~ ${vcs_info_msg_0_} %F{239}%k${NEWLINE}%f%k '