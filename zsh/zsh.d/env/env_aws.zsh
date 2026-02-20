function activate_aws() {
  __ensure_package_is_installed aws awscli || return 1

  if ! (( $+commands[aws] )); then
    print "The aws command was not found on your path.\n"
    return 1
  fi

  autoload -Uz bashcompinit && bashcompinit

  complete -C aws_completer aws
}
