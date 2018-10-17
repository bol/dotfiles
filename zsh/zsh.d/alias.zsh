case "$(uname -s)" in
    Darwin)
        alias ls="ls -G"
        alias grep="grep --color=auto"
        ;;
    *)
        alias ls="ls --color=auto"
        alias grep="grep --color=auto"
        ;;
esac