if ! (( $+commands[zoxide] )); then
  print "The zoxide command was not found on your path.\n"
  case "$(uname -s)" in
      Darwin)
        read -q "?Do you want to install it with homebrew? " || return -1
        print ''
        brew install "zoxide"
        ;;
      *)
        ;;
  esac
fi
eval "$(zoxide init zsh)"
