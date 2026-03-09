function activate_goenv() {
    [[ -e $HOME/.goenv ]] || {
        read -q '?$HOME/.goenv does not exist, do you want to install it? ' || return 1
            print '\ninstalling goenv'
            git clone https://github.com/syndbg/goenv.git ~/.goenv
        }
    export GOENV_ROOT="$HOME/.goenv"
    export GOENV_PATH_ORDER="${GOENV_PATH_ORDER:-front}"
    path=("${GOENV_ROOT}/bin" ${(@)path:#${GOENV_ROOT}/bin})
    eval "$(goenv init -)"
    if [[ "${GOENV_PATH_ORDER}" == 'front' ]]; then
        path=("${GOENV_ROOT}/shims" ${(@)path:#${GOENV_ROOT}/shims})
    fi
    [[ -n "${GOROOT:-}" ]] && path+=("${GOROOT}/bin")
    [[ -n "${GOPATH:-}" ]] && path+=("${GOPATH}/bin")
}
