function activate_aws() {
  if ! type aws >/dev/null; then
    read -q '?aws cli is not on the path, do you want to install it? ' || return 1
    updateawscli
  fi

  autoload -Uz bashcompinit && bashcompinit

  complete -C aws_completer aws

  alias awsume=". awsume"
}

function updateawscli() {
  curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "AWSCLIV2.pkg"
  sudo installer -pkg AWSCLIV2.pkg -target /
  rm AWSCLIV2.pkg
}