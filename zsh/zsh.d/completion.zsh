zinit ice lucid wait blockf
zinit light "zsh-users/zsh-completions"
zstyle ':completion:*' menu select

zinit ice lucid wait blockf
zinit light "greymd/docker-zsh-completion"

zinit ice lucid wait blockf
zinit snippet "https://raw.githubusercontent.com/bazelbuild/bazel/master/scripts/zsh_completion/_bazel"

autoload -Uz compinit && compinit
