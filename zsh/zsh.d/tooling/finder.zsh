__ensure_package_is_installed fzf || return 0
eval "$(fzf --zsh)"

# Primitive visual file manager
function fm() {
    fzf \
      --preview 'bat --line-range=:200 {}' --preview-window '~3' \
      --multi --bind 'enter:become(nvim {+})' \
      --bind 'ctrl-h:become(hexdump -C {})'
}
