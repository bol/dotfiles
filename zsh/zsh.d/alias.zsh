(( $+aliases[run-help] )) && unalias run-help
autoload -Uz run-help

# Selenized: improve readability for special dircolors entries.
__ls_colors_selenized_fix='ow=1;7;34:st=30;44:su=30;41'
if [[ ":${LS_COLORS:-}:" != *":${__ls_colors_selenized_fix}:"* ]]; then
  export LS_COLORS="${LS_COLORS:+${LS_COLORS}:}${__ls_colors_selenized_fix}"
fi
unset __ls_colors_selenized_fix

alias ls="ls --color=auto"
alias grep="grep --color=auto"
