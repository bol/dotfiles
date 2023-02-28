function activate_k8s() {
  if ! (( $+commands[kubectl] )); then
    print "The kubectl command was not found on your path.\n"
    case "$(uname -s)" in
        Darwin)
          read -q "?Do you want to install it from homebrew? " || return -1
          print ''
          brew install kubernetes-cli
            ;;
        *)
            ;;
    esac
  fi

  [[ $commands[kubectl] ]] && source <(kubectl completion zsh)

  alias k="kubectl"
  alias kg="kubectl get"
  alias kgj="kubectl get -o json"
  alias kgy="kubectl get -o yaml"
  alias kgl="kubectl get --show-labels"

  alias kn="kubectl neat"


  [[ -d $HOME/.krew ]] && path+="$HOME/.krew/bin"
  if ! type kubectl-krew >/dev/null; then
      read -q '?krew is not on the path, do you want to install it? ' || return 1
      (
        set -x; cd "$(mktemp -d)" &&
        OS="$(uname | tr '[:upper:]' '[:lower:]')" &&
        ARCH="$(uname -m | sed -e 's/x86_64/amd64/' -e 's/\(arm\)\(64\)\?.*/\1\2/' -e 's/aarch64$/arm64/')" &&
        KREW="krew-${OS}_${ARCH}" &&
        curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/latest/download/${KREW}.tar.gz" &&
        tar zxvf "${KREW}.tar.gz" &&
        ./"${KREW}" install krew
      )
  fi
}
