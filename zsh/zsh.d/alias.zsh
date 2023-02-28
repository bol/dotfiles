# Query JSON
# Use gojq instead of regular jq as the original has broken base64 handling and is no longer maintained.
# This also gives us YAML support
# https://github.com/stedolan/jq/issues/1931
alias jq='gojq'

# Colorize JSON
alias jc="bat --language JSON --theme 'Solarized (dark)' --style=plain"

# Query YAML
alias yq='gojq --yaml-output --yaml-input'
# Convert JSON to YAML
alias j2y='gojq --yaml-output'
# Colorize YAML
alias yc="bat --language YAML --theme 'Solarized (dark)' --style=plain"

case "$(uname -s)" in
    Darwin)
        alias ls="ls -G"
        # Use GNU grep intead of Apples outdated BSD version
        alias grep="ggrep --color=auto"
        ;;
    *)
        alias ls="ls --color=auto"
        alias grep="grep --color=auto"
        ;;
esac
