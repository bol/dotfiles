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
    local line untracked ahead behind ab
    local -a gitstatus

    while IFS=$'\n' read -r line; do
        if [[ $line == '# branch.ab '* ]]; then
            ab=${line#\# branch.ab }
            ahead=${ab%% *}
            behind=${ab##* }
            ahead=${ahead#+}
            behind=${behind#-}
            (( ahead > 0 )) && gitstatus+=( "%F{019}↑${ahead}" )
            (( behind > 0 )) && gitstatus+=( "%F{124}↓${behind}" )
            continue
        fi

        if [[ $line == '? '* ]]; then
            untracked='yes'
        fi
    done < <(git status --porcelain=2 --branch 2> /dev/null)

    [[ -n $untracked ]] && hook_com[unstaged]+='%F{241}…%f'
    hook_com[misc]+=${(j:/:)gitstatus}
}

add-zsh-hook -Uz precmd vcs_info

function k8s_info() {
  local current_cluster current_namespace current_context current_state

  if ! (( $+commands[kubectl] )); then
    current_cluster=''
    current_namespace=''
  elif current_state=$(kubectl config view --minify --output 'jsonpath={.current-context}{"\t"}{..namespace}' 2>/dev/null); then
    IFS=$'\t' read -r current_cluster current_namespace <<< "${current_state}"
  else
    current_cluster=''
    current_namespace=''
  fi

  # Shorten full EKS cluster ARNs to only the name
  if [[ ${current_cluster} != '' && ${current_cluster[1,11]} = 'arn:aws:eks' ]]; then
    current_cluster="${current_cluster##*:cluster/}"
  fi

  if [[ -z "$current_cluster" ]]; then
    current_context='<none>'
  elif [[ -z "$current_namespace" || "$current_namespace" = 'default' ]]; then
    current_context="$current_cluster"
  else
    current_context="$current_cluster:$current_namespace"
  fi

  psvar[2]="${current_context}"
}

add-zsh-hook -Uz precmd k8s_info

function aws_info() {
  local aws_profile aws_prompt_profile expiration
  aws_profile=${AWS_PROFILE:-default}

#  Session expiration calculation is too costly to use in prompt. The AWS cli command takes 300ms to parse a 1k TOML file on my recent M2 MBP.

#  local ts=$(aws configure get "${aws_profile}".x_session_expires)
#  local tss=${ts:0:-3}${ts:(-2)}
#
#  expiration=$(strftime -r '%FT%T%z' ${tss:-1970-01-01T00:0000})
#
#  if [[ $EPOCHSECONDS -ge $expiration ]]; then
#    aws_prompt_profile="%F{239}<expired>"
#  else
    aws_prompt_profile="${aws_profile:-default}"
#  fi

  psvar[1]="${aws_prompt_profile}"
}

add-zsh-hook -Uz precmd aws_info

NEWLINE=$'\n'
PROMPT='%K{239}%F{244}%K{244}%F{214}%F{239}%1v%K{239}%F{244} %K{239}%F{244}%K{244}%F{021}☸%F{239}%2v%K{239}%F{244} %2~ ${vcs_info_msg_0_} %F{239}%k${NEWLINE}%f%k '
