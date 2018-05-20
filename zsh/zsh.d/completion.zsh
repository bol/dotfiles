autoload -Uz compinit && compinit

zstyle :compinstall filename '/home/bol/.zshrc'
zstyle ':completion:*' rehash true
zstyle ':completion:*' menu select
setopt COMPLETE_ALIASES
