function activate_sdkman() {
    [[ -e $HOME/.sdkman ]] || {
        read -q '?$HOME/.sdkman does not exist, do you want to install it? ' || return -1
            print '\ninstalling sdkman'
            curl -s https://get.sdkman.io | bash
        }
    source "$HOME/.sdkman/bin/sdkman-init.sh"
}

activate_sdkman