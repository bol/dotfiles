function activate_nvm() {
    [[ -e $HOME/.nvm ]] || {
        read -q '?$HOME/.nvm does not exist, do you want to install it? ' || return -1
            print '\ninstalling nvm'
            git clone https://github.com/creationix/nvm.git ~/.nvm

            # Checkout the latest version tag
            cd ~/.nvm
            git checkout $(git describe --abbrev=0 --tags --match "v[0-9]*" $(git rev-list --tags --max-count=1))
        }
    export NVM_DIR="$HOME/.nvm"
    . "$NVM_DIR/nvm.sh"
}
