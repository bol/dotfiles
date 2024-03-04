HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=10000

## History command configuration
setopt extended_history       # record timestamp of command in HISTFILE
setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_dups       # ignore duplicated commands history list
setopt hist_ignore_space      # ignore commands that start with space
setopt hist_verify            # show command with history expansion to user before running it
setopt inc_append_history     # add commands to HISTFILE in order of execution
setopt share_history          # share command history data

# Use Atuin if installed, otherwise fallback to zsh native history
if [[ $commands[atuin] ]]; then
  ATUIN_NOBIND=1 zinit load atuinsh/atuin
  bindkey -M emacs '^r' atuin-search
  bindkey -M viins '^r' atuin-search-viins
  bindkey -M vicmd '/' atuin-search
  bindkey -M vicmd 'k' atuin-up-search-vicmd
else
  zinit ice wait lucid blockf
  zinit light zdharma-continuum/history-search-multi-word
fi
