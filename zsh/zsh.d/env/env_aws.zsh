function __activate_homebrew_aws() {
  local brew_prefix="${HOMEBREW_PREFIX:-}"
  local aws_path

  if [[ -z "${brew_prefix}" ]] && (( $+commands[brew] )); then
    brew_prefix=$(brew --prefix) || return 1
  fi

  for aws_path in "${brew_prefix:-/opt/homebrew}/opt/awscli/bin" /usr/local/opt/awscli/bin; do
    if [[ -x "${aws_path}/aws" ]]; then
      # Prefer just this formula's commands over any older standalone install.
      path=("$aws_path" "${(@)path:#"$aws_path"}")
      rehash
      return 0
    fi
  done
  return 1
}

function activate_aws() {
  local aws_path aws_command completer

  if [[ "$(uname -s)" == "Darwin" ]]; then
    if ! __activate_homebrew_aws && ! (( $+commands[aws] )); then
      aws_path='/usr/local/bin'
      if [[ -x "${aws_path}/aws" ]] && (( ! $path[(Ie)$aws_path] )); then
        path=("$aws_path" $path)
      fi
    fi
  fi

  if ! (( $+commands[aws] )); then
    case "$(uname -s)" in
      Darwin)
        read -q '?aws cli is not on the path, do you want to install it using Homebrew? ' || return 1
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

  if ! (( $+commands[aws] )); then
    print "The aws command was not found after installation.\n"
    return 1
  fi

  # Keep the completer paired with the selected CLI when multiple installs exist.
  aws_command="${commands[aws]}"
  completer="${aws_command:h}/aws_completer"
  if [[ ! -x "${completer}" || "${completer:A:h}" != "${aws_command:A:h}" ]]; then
    completer="${aws_command:A:h}/aws_completer"
  fi
  if [[ -x "${completer}" ]]; then
    autoload -Uz bashcompinit && bashcompinit || return 1
    complete -C "${completer}" aws || return 1
  fi
  return 0
}

function updateawscli_macos() {
  if [[ "$(uname -s)" != 'Darwin' ]]; then
    print "This install/update helper only supports macOS.\n"
    return 1
  fi

  if ! (( $+commands[brew] )); then
    print "Homebrew is required to install or update aws cli on macOS. Install it from https://brew.sh first.\n"
    return 1
  fi

  # Automatic Homebrew metadata refresh is disabled by our macOS bootstrap.
  brew update || return 1
  if brew list --formula awscli >/dev/null 2>&1; then
    brew upgrade --formula awscli || return 1
  else
    brew install --formula awscli || return 1
  fi

  if ! __activate_homebrew_aws; then
    print "The Homebrew aws command was not found after installation.\n"
    return 1
  fi
  activate_aws
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
