function activate_aws() {
  aws_path='/usr/local/bin'
  if (( ! $path[(Ie)$aws_path])); then
    path+="$aws_path"
  fi

  if ! type aws >/dev/null; then
    read -q '?aws cli is not on the path, do you want to install it? ' || return 1
    updateawscli
  fi

  autoload -Uz bashcompinit && bashcompinit

  complete -C aws_completer aws
}

function updateawscli() {
  curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "AWSCLIV2.pkg"
  sudo installer -pkg AWSCLIV2.pkg -target /
  rm AWSCLIV2.pkg
}
