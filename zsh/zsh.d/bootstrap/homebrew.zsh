# Loaded before the platform bootstrap and tool modules.
function register_homebrew_greedy_casks() {
  emulate -L zsh
  [[ "$(uname -s)" == 'Darwin' ]] || return 0
  (( $# )) || return 0

  local -aU greedy_casks
  greedy_casks=(${=HOMEBREW_UPGRADE_GREEDY_CASKS} "$@")
  export HOMEBREW_UPGRADE_GREEDY_CASKS="${(j: :)greedy_casks}"
}
