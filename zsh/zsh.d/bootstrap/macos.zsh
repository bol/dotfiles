function __setup_macos() {
  [[ -e /opt/homebrew/bin/brew ]] && eval "$(/opt/homebrew/bin/brew shellenv)"
  if ! (( $+commands[brew] )); then
    read -q "?The brew command was not found on your path. Do you want to install it? " || return -1
    print ''
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
  export HOMEBREW_NO_AUTO_UPDATE=1
  export HOMEBREW_NO_ANALYTICS=1
  export HOMEBREW_NO_ENV_HINTS=1

  # Install utilities
  __ensure_package_is_installed coreutils
  __ensure_package_is_installed openssl
  __ensure_package_is_installed grep

  # Prefer OpenSSL over the Apple LibreSSL
  [[ -e /opt/homebrew/opt/openssl/bin ]] && path=('/opt/homebrew/opt/openssl/bin' $path)
  # Prefer Homebrew OpenSSH over the Apple package version
  [[ -e /opt/homebrew/opt/openssh/bin ]] && path=('/opt/homebrew/opt/openssh/bin' $path)
  # Prefer GNU coreutils over the Apple BSD ones
  [[ -e /opt/homebrew/opt/coreutils/libexec/gnubin ]] && path=('/opt/homebrew/opt/coreutils/libexec/gnubin' $path)
}

[[ "$(uname -s)" == "Darwin" ]] && __setup_macos
