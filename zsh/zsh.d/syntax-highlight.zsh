typeset -gA FAST_HIGHLIGHT_STYLES
# Keep interactive comments readable on dark terminals.
FAST_HIGHLIGHT_STYLES[comment]='fg=250'
FAST_HIGHLIGHT_STYLES[freecomment]='fg=250'

zinit ice wait lucid
zinit light zdharma-continuum/fast-syntax-highlighting
