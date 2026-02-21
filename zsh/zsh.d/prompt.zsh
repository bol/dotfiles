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
zstyle ':vcs_info:*' check-for-changes false
zstyle ':vcs_info:*' stagedstr '%F{018}●'
zstyle ':vcs_info:*' unstagedstr '%F{136}✚'
zstyle ':vcs_info:*' formats       '%K{239}%F{244}%K{244}%F{92}%F{022}%b%m%c%u%K{239}%F{244}'
zstyle ':vcs_info:*' actionformats '%K{239}%F{244}%K{244}%F{022}%b%m%c%u%F{244}|%F{088}%a%K{239}%F{244}'
zstyle ':vcs_info:git*+set-message:*' hooks git-status

function +vi-git-status(){
    local line ab ahead behind status_xy
    local staged unstaged untracked
    local -a gitstatus

    # Escape branch/action data from git so prompt escape sequences stay literal.
    hook_com[branch]=${hook_com[branch]//\%/%%}
    hook_com[action]=${hook_com[action]//\%/%%}

    while IFS=$'\n' read -r line; do
        case "${line}" in
            '# branch.ab '*)
                ab=${line#\# branch.ab }
                ahead=${ab%% *}
                behind=${ab##* }
                ahead=${ahead#+}
                behind=${behind#-}
                (( ahead > 0 )) && gitstatus+=( "%F{019}↑${ahead}" )
                (( behind > 0 )) && gitstatus+=( "%F{124}↓${behind}" )
                ;;
            '1 '*|'2 '*|'u '*)
                status_xy=${line[3,4]}
                [[ ${status_xy[1]} != '.' ]] && staged='yes'
                [[ ${status_xy[2]} != '.' ]] && unstaged='yes'
                ;;
            '? '*)
                untracked='yes'
                ;;
        esac
    done < <(git status --porcelain=2 --branch 2> /dev/null)

    [[ -n $staged ]] && hook_com[staged]='%F{018}●'
    if [[ -n $unstaged || -n $untracked ]]; then
        hook_com[unstaged]='%F{136}✚'
        [[ -n $untracked ]] && hook_com[unstaged]+='%F{241}…%f'
    fi
    hook_com[misc]+=${(j:/:)gitstatus}
}

add-zsh-hook -Uz precmd vcs_info

zmodload zsh/stat 2>/dev/null
typeset -g __k8s_prompt_cache_context='<none>'
typeset -g __k8s_prompt_cache_key=''

function __k8s_prompt_compute_cache_key() {
  local -a kube_files
  local -A stat_values
  local file key mtime_ns

  key="${KUBECONFIG:-<default>};"

  if [[ -n ${KUBECONFIG:-} ]]; then
    kube_files=("${(@s/:/)KUBECONFIG}")
  else
    kube_files=("${HOME}/.kube/config")
  fi

  for file in "${kube_files[@]}"; do
    if [[ -r "${file}" ]]; then
      if (( $+builtins[zstat] )) \
        && mtime_ns=$(zstat -F '%s.%N' +mtime -- "${file}" 2>/dev/null) \
        && zstat -H stat_values -- "${file}" 2>/dev/null; then
        key+="${file}:${mtime_ns}:${stat_values[size]};"
      else
        key+="${file}:nocache:${RANDOM};"
      fi
    else
      key+="${file}:missing;"
    fi
  done

  REPLY="${key}"
}

function k8s_info() {
  local current_cluster current_namespace current_context current_state cache_key

  if ! (( $+commands[kubectl] )); then
    __k8s_prompt_cache_context='<none>'
    __k8s_prompt_cache_key=''
    psvar[2]='<none>'
    return
  fi

  __k8s_prompt_compute_cache_key
  cache_key="${REPLY}"

  if [[ "${cache_key}" == "${__k8s_prompt_cache_key}" ]]; then
    psvar[2]="${__k8s_prompt_cache_context}"
    return
  fi

  __k8s_prompt_cache_key="${cache_key}"

  if current_state=$(kubectl config view --minify --output 'jsonpath={.current-context}{"\t"}{..namespace}' 2>/dev/null); then
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

  __k8s_prompt_cache_context="${current_context}"
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
