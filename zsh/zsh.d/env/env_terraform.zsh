function activate_tenv() {
  local completion_path

  __ensure_package_is_installed tenv

  completion_path=$(mktemp -q) || return 1
  if ! tenv completion zsh > "${completion_path}"; then
    rm -f "${completion_path}"
    return 1
  fi

  source "${completion_path}" || {
    rm -f "${completion_path}"
    return 1
  }
  rm -f "${completion_path}"
}
