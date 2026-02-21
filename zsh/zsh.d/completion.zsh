zinit ice lucid wait blockf
zinit light "zsh-users/zsh-completions"

typeset -g __zsh_completion_cache_dir="${XDG_CACHE_HOME:-${HOME}/.cache}/zsh/compcache"

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{[:lower:]}={[:upper:]}' 'r:|[._-]=* r:|=*'

if [[ -d "${__zsh_completion_cache_dir}" ]] || mkdir -p "${__zsh_completion_cache_dir}" 2>/dev/null; then
  zstyle ':completion:*' use-cache on
  zstyle ':completion:*' cache-path "${__zsh_completion_cache_dir}"
else
  zstyle ':completion:*' use-cache off
fi

autoload -Uz compinit && compinit
