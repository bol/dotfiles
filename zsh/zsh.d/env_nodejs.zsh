function activate_nodenv() {
    [[ -e $HOME/.nodenv ]] || {
        read -q '?$HOME/.nodenv does not exist, do you want to install it? ' || return -1
            print '\ninstalling nodenv'
            git clone https://github.com/nodenv/nodenv.git $HOME/.nodenv
            mkdir -p $HOME/.nodenv/plugins
            git clone https://github.com/nodenv/node-build.git $HOME/.nodenv/plugins/node-build
        }
    path+="$HOME/.nodenv/bin"
    eval "$(nodenv init -)"
}
