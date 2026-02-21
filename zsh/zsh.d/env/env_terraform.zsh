function activate_tenv() {
  local completion_path

  __ensure_package_is_installed tenv || return 1

  __zsh_completion_file_for tenv || return 1
  completion_path="${REPLY}"
  if ! tenv completion zsh > "${completion_path}"; then
    print "Failed to generate tenv completion at ${completion_path}.\n"
    return 1
  fi

  source "${completion_path}" || return 1
}
