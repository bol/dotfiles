function activate_k8s() {
  [[ $commands[kubectl] ]] && source <(kubectl completion zsh)

  alias k="kubectl"
  alias kg="kubectl get"
  alias kgj="kubectl get -o json"
  alias kgy="kubectl get -o yaml"
  alias kgl="kubectl get --show-labels"

  alias kn="kubectl neat"


  [[ -d $HOME/.krew ]] && export PATH="$HOME/.krew/bin:$PATH"
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

export PATH="/opt/homebrew/opt/kubernetes-cli@1.22/bin:$PATH"
export PATH="/opt/homebrew/opt/openssl@3/bin:$PATH"
export PATH="/opt/homebrew/opt/git/bin:$PATH"
