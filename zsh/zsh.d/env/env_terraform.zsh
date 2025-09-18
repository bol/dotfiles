function activate_tenv() {
  __ensure_package_is_installed
  COMPLETION_PATH=$(mktemp -q)
  tenv completion zsh > "${COMPLETION_PATH}"
  source "${COMPLETION_PATH}"
  rm -f "${COMPLETION_PATH}"
}
