0=${${(M)${0::=${(%):-%x}}:#/*}:-$PWD/$0}

link_conf "$1/git.d" "$HOME/.git.d"
copy_conf "$1/gitconfig.ini" "$HOME/.gitconfig"
