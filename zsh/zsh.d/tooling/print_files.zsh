__ensure_package_is_installed bat

export MANPAGER="sh -c 'col -bx | bat -l man -p'"

alias cat='bat --paging=never'
