function activate_gcloud() {
    [[ -e $HOME/google-cloud-sdk ]] || {
        read -q '?$HOME/google-cloud-sdk does not exist, do you want to install it? ' || return -1
       curl https://sdk.cloud.google.com | bash
    }
    . '/Users/nikbol/google-cloud-sdk/path.zsh.inc'
    . '/Users/nikbol/google-cloud-sdk/completion.zsh.inc'
}
