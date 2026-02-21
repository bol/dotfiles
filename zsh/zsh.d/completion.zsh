zinit ice lucid wait blockf
zinit light "zsh-users/zsh-completions"

typeset -g __zsh_completion_cache_dir="${XDG_CACHE_HOME:-${HOME}/.cache}/zsh/compcache"
typeset -g __zsh_completion_dir="${XDG_CACHE_HOME:-${HOME}/.cache}/zsh/completions"

function __ensure_zsh_completion_dir() {
  if ! [[ -d "${__zsh_completion_dir}" ]] && ! mkdir -p "${__zsh_completion_dir}" 2>/dev/null; then
    print "Failed to create zsh completion directory ${__zsh_completion_dir}.\n"
    return 1
  fi
  if (( ${fpath[(Ie)${__zsh_completion_dir}]} == 0 )); then
    fpath=("${__zsh_completion_dir}" $fpath)
  fi
}

function __zsh_completion_file_for() {
  local command_name="$1"
  __ensure_zsh_completion_dir || return 1
  REPLY="${__zsh_completion_dir}/_${command_name}"
}

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{[:lower:]}={[:upper:]}' 'r:|[._-]=* r:|=*'

if [[ -d "${__zsh_completion_cache_dir}" ]] || mkdir -p "${__zsh_completion_cache_dir}" 2>/dev/null; then
  zstyle ':completion:*' use-cache on
  zstyle ':completion:*' cache-path "${__zsh_completion_cache_dir}"
else
  zstyle ':completion:*' use-cache off
fi

autoload -Uz compinit && compinit
