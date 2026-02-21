function activate_aws() {
  if [[ "$(uname -s)" == "Darwin" ]]; then
    local aws_path='/usr/local/bin'
    if (( ! $path[(Ie)$aws_path] )); then
      path=("$aws_path" $path)
    fi
  fi

  if ! (( $+commands[aws] )); then
    case "$(uname -s)" in
      Darwin)
        read -q '?aws cli is not on the path, do you want to install it using the official AWS package? ' || return 1
        print ''
        updateawscli_macos || return 1
        ;;
      Linux)
        print "The aws command was not found on your path.\n"
        print_linux_awscli_install_hint
        return 1
        ;;
      *)
        print "Unsupported platform for aws cli bootstrap: $(uname -s)\n"
        return 1
        ;;
    esac
  fi

  if (( $+commands[aws_completer] )); then
    autoload -Uz bashcompinit && bashcompinit
    complete -C aws_completer aws
  fi
}

function updateawscli_macos() {
  local tmpdir pkg
  tmpdir=$(mktemp -d "${TMPDIR:-/tmp}/awscliv2.XXXXXX") || return 1
  pkg="${tmpdir}/AWSCLIV2.pkg"

  curl -fLsS "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "${pkg}" || {
    rm -rf "${tmpdir}"
    return 1
  }

  if [[ ! -s "${pkg}" ]]; then
    rm -rf "${tmpdir}"
    return 1
  fi

  sudo installer -pkg "${pkg}" -target / || {
    rm -rf "${tmpdir}"
    return 1
  }

  rm -rf "${tmpdir}"
}

function print_linux_awscli_install_hint() {
  if (( $+commands[apt] )); then
    print "Install with your distro package manager, e.g.:\n  sudo apt install awscli\n"
  elif (( $+commands[dnf] )); then
    print "Install with your distro package manager, e.g.:\n  sudo dnf install awscli2\n"
  elif (( $+commands[yum] )); then
    print "Install with your distro package manager, e.g.:\n  sudo yum install awscli\n"
  elif (( $+commands[pacman] )); then
    print "Install with your distro package manager, e.g.:\n  sudo pacman -S aws-cli-v2\n"
  elif (( $+commands[zypper] )); then
    print "Install with your distro package manager, e.g.:\n  sudo zypper install aws-cli\n"
  else
    print "Install aws cli using your distro package manager.\n"
  fi
}
