function activate_rbenv() {
    [[ -e $HOME/.rbenv ]] || {
        read -q '?$HOME/.rbenv does not exist, do you want to install it? ' || return -1
            print '\ninstalling rbenv'
            git clone https://github.com/rbenv/rbenv.git $HOME/.rbenv
            mkdir -p $HOME/.rbenv/plugins
            git clone https://github.com/rbenv/ruby-build.git $HOME/.rbenv/plugins/ruby-build
	    git clone https://github.com/ianheggie/rbenv-binstubs.git $HOME/.rbenv/plugins/rbenv-binstubs
        }
    export PATH="$HOME/.rbenv/bin:$PATH"
    eval "$(rbenv init -)"
}
