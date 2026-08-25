setopt prompt_subst
autoload -Uz add-zsh-hook

# Colors are 256-bit color
# Refer to chart here: https://upload.wikimedia.org/wikipedia/commons/1/15/Xterm_256color_chart.svg

# Prompt favors text-first signals and conservative symbols so it remains readable
# across terminal/font combinations.

# Fancy git info
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' check-for-changes false
zstyle ':vcs_info:*' stagedstr '+'
zstyle ':vcs_info:*' unstagedstr '~'
zstyle ':vcs_info:*' formats       '%K{239}%F{208}git%f%k:%b%m%c%u'
zstyle ':vcs_info:*' actionformats '%K{239}%F{208}git%f%k:%b%m%c%u|%a'
zstyle ':vcs_info:git*+set-message:*' hooks git-status

function +vi-git-status(){
    local line ab ahead behind status_xy
    local staged unstaged
    local branch_for_var action_for_var misc_for_var git_raw git_display
    local -a gitstatus

    __prompt_middle_ellipsis "${hook_com[branch]}" 32
    hook_com[branch]="${REPLY}"
    __prompt_middle_ellipsis "${hook_com[action]}" 32
    hook_com[action]="${REPLY}"

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
                (( ahead > 0 )) && gitstatus+=( "↑${ahead}" )
                (( behind > 0 )) && gitstatus+=( "↓${behind}" )
                ;;
            '1 '*|'2 '*|'u '*)
                status_xy=${line[3,4]}
                [[ ${status_xy[1]} != '.' ]] && staged='yes'
                [[ ${status_xy[2]} != '.' ]] && unstaged='yes'
                ;;
        esac
    done < <(git status --porcelain=2 --branch -uno 2> /dev/null)

    [[ -n $staged ]] && hook_com[staged]=' +'
    if [[ -n $unstaged ]]; then
        hook_com[unstaged]=' ~'
    fi
    (( ${#gitstatus[@]} > 0 )) && hook_com[misc]+=" ${(j:/:)gitstatus}"

    branch_for_var="${hook_com[branch]//%%/%}"
    action_for_var="${hook_com[action]//%%/%}"
    misc_for_var="${hook_com[misc]## }"
    git_raw="${branch_for_var}"
    if [[ -n "${action_for_var}" ]]; then
      git_raw+="|${action_for_var}"
    fi
    if [[ -n "${misc_for_var}" ]]; then
      git_raw+=" ${misc_for_var}"
    fi
    if [[ -n "${hook_com[staged]}" ]]; then
      git_raw+=" +"
    fi
    if [[ -n "${hook_com[unstaged]}" ]]; then
      git_raw+=" ~"
    fi

    if [[ -n "${git_raw}" ]]; then
      git_display="git:${git_raw}"
      __prompt_git_raw="${git_raw}"
      __prompt_git_display="${git_display}"
    else
      __prompt_git_raw='<none>'
      __prompt_git_display='<none>'
    fi
}

add-zsh-hook -Uz precmd vcs_info

function prompt_git_status_info() {
  if [[ -n "${vcs_info_msg_0_}" ]]; then
    psvar[5]="${__prompt_git_raw}"
    psvar[6]="${__prompt_git_display}"
  else
    __prompt_git_raw='<none>'
    __prompt_git_display='<none>'
    psvar[5]='<none>'
    psvar[6]='<none>'
  fi
}

add-zsh-hook -Uz precmd prompt_git_status_info

zmodload zsh/stat 2>/dev/null
typeset -g __k8s_prompt_cache_context='<none>'
typeset -g __k8s_prompt_cache_key=''
typeset -g __prompt_git_raw='<none>'
typeset -g __prompt_git_display='<none>'
typeset -g __prompt_aws_available=0
typeset -g __prompt_k8s_available=0

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
    __prompt_k8s_available=0
    psvar[2]=''
    return
  fi

  __prompt_k8s_available=1
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

  if ! (( $+commands[aws] )); then
    __prompt_aws_available=0
    psvar[1]=''
    return
  fi

  __prompt_aws_available=1
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

# Optional explicit overrides, intended for local customization in ~/.zshrc_local.
# Patterns use zsh glob syntax and are evaluated case-insensitively.
typeset -ga __prompt_risk_prod_aws_overrides=()
typeset -ga __prompt_risk_stage_aws_overrides=()
typeset -ga __prompt_risk_dev_aws_overrides=()
typeset -ga __prompt_risk_prod_k8s_overrides=()
typeset -ga __prompt_risk_stage_k8s_overrides=()
typeset -ga __prompt_risk_dev_k8s_overrides=()

function __prompt_middle_ellipsis() {
  local text max_len remaining keep_left keep_right
  local left_part right_part

  text="${1:-}"
  max_len="${2:-32}"

  if (( ${#text} <= max_len )); then
    REPLY="${text}"
    return
  fi

  if (( max_len <= 3 )); then
    REPLY="${text[1,max_len]}"
    return
  fi

  remaining=$(( max_len - 3 ))
  keep_left=$(( remaining / 2 ))
  keep_right=$(( remaining - keep_left ))

  left_part=''
  right_part=''
  (( keep_left > 0 )) && left_part="${text[1,keep_left]}"
  (( keep_right > 0 )) && right_part="${text[-keep_right,-1]}"

  REPLY="${left_part}...${right_part}"
}

typeset -g __prompt_risk_badge='[UNK]'
typeset -g __prompt_risk_label='UNK'

function __prompt_matches_any_pattern() {
  local value patterns_name pattern

  value="${1:-}"
  patterns_name="${2:-}"

  for pattern in "${(@P)patterns_name}"; do
    [[ -z "${pattern}" ]] && continue
    if [[ "${value}" == ${~${pattern:l}} ]]; then
      return 0
    fi
  done

  return 1
}

function __prompt_context_risk_level() {
  local source value lowered normalized token prev_token
  local has_negated_prod has_private has_managed has_saas has_psaas
  local prod_overrides stage_overrides dev_overrides
  local -a tokens

  source="${1:-}"
  value="${2:-}"
  lowered="${value:l}"

  case "${source}" in
    aws)
      prod_overrides='__prompt_risk_prod_aws_overrides'
      stage_overrides='__prompt_risk_stage_aws_overrides'
      dev_overrides='__prompt_risk_dev_aws_overrides'
      ;;
    k8s)
      prod_overrides='__prompt_risk_prod_k8s_overrides'
      stage_overrides='__prompt_risk_stage_k8s_overrides'
      dev_overrides='__prompt_risk_dev_k8s_overrides'
      ;;
    *)
      REPLY='unk'
      return
      ;;
  esac

  if [[ -z "${lowered}" || "${lowered}" == '<none>' || "${lowered}" == 'default' ]]; then
    REPLY='unk'
    return
  fi

  if __prompt_matches_any_pattern "${lowered}" "${prod_overrides}"; then
    REPLY='prod'
    return
  fi
  if __prompt_matches_any_pattern "${lowered}" "${stage_overrides}"; then
    REPLY='stage'
    return
  fi
  if __prompt_matches_any_pattern "${lowered}" "${dev_overrides}"; then
    REPLY='dev'
    return
  fi

  has_negated_prod=0
  if [[ "${lowered}" =~ '(^|[^[:alnum:]])non[-_ ]?(prod|production|live)($|[^[:alnum:]])' ]]; then
    has_negated_prod=1
  fi

  normalized="${lowered//[^[:alnum:]]/ }"
  tokens=(${=normalized})

  has_private=0
  has_managed=0
  has_saas=0
  has_psaas=0

  prev_token=''
  for token in "${tokens[@]}"; do
    case "${token}" in
      nonprod|nonproduction|nonlive)
        has_negated_prod=1
        ;;
      private)
        has_private=1
        ;;
      managed)
        has_managed=1
        ;;
      saas)
        has_saas=1
        ;;
      psaas)
        has_psaas=1
        ;;
    esac

    case "${token}" in
      prod|production|live)
        if [[ "${prev_token}" != 'non' && "${prev_token}" != 'no' && "${prev_token}" != 'not' ]] && (( ! has_negated_prod )); then
          REPLY='prod'
          return
        fi
        ;;
      stage|staging|preprod|preproduction|uat)
        REPLY='stage'
        return
        ;;
    esac

    if [[ "${token}" =~ '^prod[0-9]+$' ]] && (( ! has_negated_prod )); then
      REPLY='prod'
      return
    fi
    if [[ "${token}" =~ '^(stage|preprod)[0-9]+$' ]]; then
      REPLY='stage'
      return
    fi

    prev_token="${token}"
  done

  for token in "${tokens[@]}"; do
    case "${token}" in
      dev|development|sandbox|test|qa|local)
        REPLY='dev'
        return
        ;;
    esac

    if [[ "${token}" =~ '^(dev|test|qa|sandbox|local)[0-9]+$' ]]; then
      REPLY='dev'
      return
    fi
  done

  if (( ! has_negated_prod )) && (( has_psaas || (has_private && has_saas) || (has_managed && has_saas) )); then
    REPLY='prod'
    return
  fi

  REPLY='unk'
}

function prompt_risk_info() {
  local aws_level k8s_level level
  local label color
  local aws_context k8s_context

  if (( ! __prompt_aws_available && ! __prompt_k8s_available )); then
    __prompt_risk_badge=''
    __prompt_risk_label=''
    return
  fi

  aws_context="${psvar[1]}"
  k8s_context="${psvar[2]}"

  __prompt_context_risk_level 'aws' "${aws_context}"
  aws_level="${REPLY}"
  __prompt_context_risk_level 'k8s' "${k8s_context}"
  k8s_level="${REPLY}"

  if [[ "${aws_level}" == 'prod' || "${k8s_level}" == 'prod' ]]; then
    level='prod'
  elif [[ "${aws_level}" == 'stage' || "${k8s_level}" == 'stage' ]]; then
    level='stage'
  elif [[ "${aws_level}" == 'dev' || "${k8s_level}" == 'dev' ]]; then
    level='dev'
  else
    level='unk'
  fi

  case "${level}" in
    prod)
      label='PROD'
      color='160'
      ;;
    stage)
      label='PREPROD'
      color='178'
      ;;
    dev)
      label='NONPROD'
      color='70'
      ;;
    *)
      label='UNK'
      color='245'
      ;;
  esac

  __prompt_risk_badge="%B%F{${color}}${label}%f%b"
  __prompt_risk_label="${label}"
}

add-zsh-hook -Uz precmd prompt_risk_info

function prompt_context_display_info() {
  local aws_context k8s_context

  aws_context="${psvar[1]:-}"
  if [[ -n "${aws_context}" ]]; then
    if [[ "${aws_context}" == 'paycontrol-'* ]]; then
      aws_context="${aws_context#paycontrol-}"
    fi
    if [[ "${aws_context}" == *'-admin' ]]; then
      aws_context="${aws_context%-admin}"
    fi
  fi
  psvar[3]="${aws_context}"

  k8s_context="${psvar[2]:-}"
  if [[ -n "${k8s_context}" && "${k8s_context}" == *':paycontrol' ]]; then
    k8s_context="${k8s_context%:paycontrol}"
  fi
  psvar[4]="${k8s_context}"
}

add-zsh-hook -Uz precmd prompt_context_display_info

function __wezterm_set_user_var() {
  local name value encoded
  name="${1}"
  value="${2:-}"

  if ! (( $+commands[base64] )); then
    return
  fi

  encoded="$(printf '%s' "${value}" | base64 | tr -d '\r\n')"
  printf "\033]1337;SetUserVar=%s=%s\007" "${name}" "${encoded}"
}

function __prompt_json_escape() {
  local value char escaped code
  local -i index

  value="${1:-}"
  escaped=''

  for (( index = 1; index <= ${#value}; index++ )); do
    char="${value[index]}"
    case "${char}" in
      '"') char='\"' ;;
      '\') char='\\' ;;
      $'\b') char='\b' ;;
      $'\f') char='\f' ;;
      $'\n') char='\n' ;;
      $'\r') char='\r' ;;
      $'\t') char='\t' ;;
      *)
        if [[ "${char}" == [[:cntrl:]] ]]; then
          printf -v code '%d' "'${char}"
          if (( code < 32 )); then
            printf -v char '\\u%04x' "${code}"
          fi
        fi
        ;;
    esac
    escaped+="${char}"
  done

  REPLY="${escaped}"
}

function wezterm_shell_context() {
  local aws_display k8s_display git_display risk

  if [[ -z "${WEZTERM_PANE:-}" && "${TERM_PROGRAM:-}" != 'WezTerm' ]]; then
    return
  fi

  __prompt_json_escape "${psvar[6]:-${psvar[5]:-<none>}}"
  git_display="${REPLY}"
  __prompt_json_escape "${psvar[3]:-${psvar[1]:-}}"
  aws_display="${REPLY}"
  __prompt_json_escape "${psvar[4]:-${psvar[2]:-}}"
  k8s_display="${REPLY}"
  __prompt_json_escape "${__prompt_risk_label}"
  risk="${REPLY}"

  __wezterm_set_user_var 'SHELL_CONTEXT' \
    "{\"version\":1,\"git\":\"${git_display}\",\"aws\":\"${aws_display}\",\"k8s\":\"${k8s_display}\",\"risk\":\"${risk}\"}"
}

add-zsh-hook -Uz precmd wezterm_shell_context

NEWLINE=$'\n'
PROMPT='%F{111}%3~%f${NEWLINE}%K{238}%B%F{81} %(!.#.>) %f%b%k '
RPROMPT=''
