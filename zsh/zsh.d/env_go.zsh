function activate_goenv() {
    [[ -e $HOME/.goenv ]] || {
        read -q '?$HOME/.goenv does not exist, do you want to install it? ' || return 1
            print '\ninstalling goenv'
            git clone https://github.com/syndbg/goenv.git ~/.goenv
        }
    export GOENV_ROOT="$HOME/.goenv"
    path+="$GOENV_ROOT/bin"
    eval "$(goenv init -)"
    path+="$GOROOT/bin"
    path+="$GOPATH/bin"
}