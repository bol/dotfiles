__ensure_package_is_installed fzf || return 1

# Opinionated fzf defaults for an always-on, compact interface.
export FZF_DEFAULT_OPTS='--height 40% --tmux bottom,40% --layout reverse --border'

# Keep shell widgets and completion focused on relevant files.
typeset -g __fzf_walker_skip='.git,node_modules,target,.next,.turbo,.cache'
export FZF_CTRL_T_OPTS="--walker-skip ${__fzf_walker_skip} --preview 'bat --line-range=:200 {} 2>/dev/null || ls -la {}' --preview-window '~3' --bind 'ctrl-/:change-preview-window(down|hidden|)'"
export FZF_ALT_C_OPTS="--walker-skip ${__fzf_walker_skip} --preview 'ls -la {}'"
export FZF_COMPLETION_PATH_OPTS="--walker file,dir,follow,hidden --walker-skip ${__fzf_walker_skip}"
export FZF_COMPLETION_DIR_OPTS="--walker dir,follow,hidden --walker-skip ${__fzf_walker_skip}"

eval "$(fzf --zsh)"

# Primitive visual file manager
function fm() {
    fzf \
      --walker file,dir,follow,hidden --walker-skip "${__fzf_walker_skip}" \
      --preview 'bat --line-range=:200 {} 2>/dev/null || ls -la {}' --preview-window '~3' \
      --multi --bind 'enter:become(nvim {+})' \
      --bind 'ctrl-h:become(hexdump -C {})'
}
