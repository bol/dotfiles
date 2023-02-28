

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
