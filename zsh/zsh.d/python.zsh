function activate_pyenv() {
    [[ -e $HOME/.pyenv ]] || {
        read -q '?$HOME/.pyenv does not exist, do you want to install it? ' || return -1
            print '\ninstalling pyenv'
            git clone https://github.com/pyenv/pyenv.git ~/.pyenv
            git clone https://github.com/pyenv/pyenv-virtualenv.git $HOME/.pyenv/plugins/pyenv-virtualenv
        }
    export PATH="$HOME/.pyenv/bin:$PATH"
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
}
