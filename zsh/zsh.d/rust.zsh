function activate_rustup() {
    [[ -e $HOME/.cargo ]] || {
        read -q '?$HOME/.cargo does not exist, do you want to install it? ' || return -1
            print '\ninstalling rustup'
	    curl https://sh.rustup.rs -sSf | sh
    }
    source $HOME/.cargo/env
}
