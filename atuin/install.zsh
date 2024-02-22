link_conf $1/config.toml $HOME/.config/atuin/config.toml

if ! (($+commands[atuin])); then
    print "The atuin command was not found on your path.\n"
    case "$(uname -s)" in
        Darwin)
          read -q "?Do you want to install it from homebrew? " || return 1
          print ''
          brew install atuin
            ;;
        *)  ;;
  esac
fi
