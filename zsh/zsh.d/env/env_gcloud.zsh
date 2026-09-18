function __gcloud_sdk_root() {
  local sdk_root
  REPLY=''

  if (( $+commands[gcloud] )); then
    REPLY="${commands[gcloud]:A:h:h}"
    return 0
  fi

  for sdk_root in "$HOME/google-cloud-sdk" "${HOMEBREW_PREFIX:-/opt/homebrew}/share/google-cloud-sdk" /usr/local/share/google-cloud-sdk; do
    if [[ -x "${sdk_root}/bin/gcloud" ]]; then
      REPLY="${sdk_root:A}"
      return 0
    fi
  done
  return 1
}

function activate_gcloud() {
  local sdk_root gcloud_path

  if ! __gcloud_sdk_root; then
    case "$(uname -s)" in
      Darwin)
        read -q '?gcloud cli is not on the path, do you want to install it using Homebrew? ' || return 1
        print ''
        updategcloudcli_macos || return 1
        ;;
      Linux)
        print "The gcloud command was not found on your path.\n"
        print_linux_gcloudcli_install_hint
        return 1
        ;;
      *)
        print "Unsupported platform for gcloud cli bootstrap: $(uname -s)\n"
        return 1
        ;;
    esac

    if ! __gcloud_sdk_root; then
      print "The gcloud command was not found after installation.\n"
      return 1
    fi
  fi

  sdk_root="${REPLY}"
  # Homebrew links the core commands; extra SDK components need this path too.
  gcloud_path="${sdk_root}/bin"
  if (( ! $path[(Ie)$gcloud_path] )); then
    path=("$gcloud_path" $path)
  fi
  if [[ -r "${sdk_root}/completion.zsh.inc" ]]; then
    source "${sdk_root}/completion.zsh.inc" || return 1
  fi
  return 0
}

function updategcloudcli_macos() {
  local sdk_root brew_prefix

  if [[ "$(uname -s)" != 'Darwin' ]]; then
    print "This install/update helper only supports macOS.\n"
    return 1
  fi

  if __gcloud_sdk_root; then
    sdk_root="${REPLY}"
  fi
  if (( $+commands[brew] )); then
    brew_prefix=$(brew --prefix) || return 1
  fi

  if [[ -n "${sdk_root}" ]]; then
    if [[ -n "${brew_prefix}" && "${sdk_root}" == "${brew_prefix:A}/share/google-cloud-sdk" ]]; then
      brew update || return 1
      brew upgrade --cask gcloud-cli
    else
      "${sdk_root}/bin/gcloud" components update
    fi
    return $?
  fi

  if [[ -z "${brew_prefix}" ]]; then
    print "Homebrew is required to install gcloud on macOS. Install it from https://brew.sh first.\n"
    return 1
  fi

  # Automatic Homebrew metadata refresh is disabled by our macOS bootstrap.
  brew update || return 1
  brew install --cask gcloud-cli || return 1
  rehash
}

function print_linux_gcloudcli_install_hint() {
  print "Configure Google's package repository first; see:\n  https://cloud.google.com/sdk/docs/install\n"
  if (( $+commands[apt] )); then
    print "Then install with:\n  sudo apt update && sudo apt install google-cloud-cli\n"
  elif (( $+commands[dnf] )); then
    print "Then install with:\n  sudo dnf install google-cloud-cli\n"
  elif (( $+commands[yum] )); then
    print "Then install with:\n  sudo yum install google-cloud-cli\n"
  else
    print "Follow the official instructions above for your distribution.\n"
  fi
}
