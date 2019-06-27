HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=${HISTSIZE}

setopt hist_ignore_all_dups
setopt append_history

zplugin load zdharma/history-search-multi-word