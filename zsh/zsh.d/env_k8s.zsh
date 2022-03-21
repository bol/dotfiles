function activate_k8s() {

  autoload -Uz compinit && compinit

  source <(kubectl completion zsh)
  alias k=kubectl
  compdef __start_kubectl k
  alias kgy="kubectl get -o yaml"
  compdef "__start_kubectl get" kgy

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