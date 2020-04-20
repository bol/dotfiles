function activate_tfenv() {
    [[ -e $HOME/.tfenv ]] || {
        read -q '?$HOME/.tfenv does not exist, do you want to install it? ' || return -1
            print '\ninstalling tfenv'
            git clone https://github.com/tfutils/tfenv.git $HOME/.tfenv
        }
    export PATH="$HOME/.tfenv/bin:$PATH"
}