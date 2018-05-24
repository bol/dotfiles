fpath=(${0:a:h}/functions $fpath)
autoload -Uz compinit && compinit

zstyle :compinstall filename '/home/bol/.zshrc'
zstyle ':completion:*' menu select
setopt COMPLETE_ALIASES
