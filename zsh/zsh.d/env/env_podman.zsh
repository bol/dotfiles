# Containers
# Using Podman for local container handling.

function activate_podman() {
  local completion_file

  __ensure_package_is_installed podman || return 1

  __zsh_completion_file_for podman || return 1
  completion_file="${REPLY}"
  if ! podman completion -f "${completion_file}" zsh; then
    print "Failed to generate podman completion at ${completion_file}.\n"
    return 1
  fi
  autoload -Uz "${completion_file:t}"
  compdef "${completion_file:t}" podman

  alias pm="podman"

  [[ "$(uname -s)" == "Darwin" ]] && export CONTAINERS_MACHINE_PROVIDER='applehv'

  function pm-machine-reset() {
    local machine_found=0
    local machine_running=0
    for line in "${(@f)$(podman machine list --noheading --format '{{range .}}{{.Name}}\t{{.LastUp}}\n{{end -}}' )}"; do
      [[ -z "${line}" ]] && continue
      IFS=$'\t' read -A machine <<< "$line"

      [[ "${machine[2]}" == 'Currently running' ]] && {
        echo "Stopping previous VM ${machine[1]}"
        podman machine stop "${machine[1]}"
      }
      echo "Removing previous VM ${machine[1]}"
      podman machine rm --force "${machine[1]}"
    done

    echo "Initializing new VM"
    podman machine init \
      --cpus=4 \
      --disk-size=100 \
      --memory 12288 \
      --rootful \
      --now
  }

  # Configure privileged mode for testcontainers Ryuk.
  # See: https://github.com/containers/podman/discussions/14238#discussioncomment-2746413
  grep -E '^ryuk\.container\.privileged=true' ~/.testcontainers.properties >/dev/null 2>&1 || ( echo 'Configuring TestContainers to run Ryuk in privileged mode so that it can open the docker socket' && echo 'ryuk.container.privileged=true' >> ~/.testcontainers.properties)

  # Podman only runs on Linux. Other platform requires a vm managed with podman machine.
  case "$(uname -s)" in
    Linux)
      ;;
    *)
      machine_found=0
      machine_running=0
      for line in "${(@f)$(podman machine list --noheading --format '{{range .}}{{.Name}}\t{{.LastUp}}\n{{end -}}')}"; do
        [[ -z "${line}" ]] && continue
        IFS=$'\t' read -A machine <<< "$line"
        machine_found=1
        [[ "${machine[2]}" == 'Currently running' ]] && machine_running=1
      done
      if (( ! $machine_found )); then
        read -q "?There is currently no podman vm. Do you want to create one? " || return -1
        print ''
        pm-machine-reset
      elif (( ! $machine_running)); then
        read -q "?Your podman vm is currently not running. Do you want to start it? " || return -1
        print ''
        podman machine start
      fi

      ;;
  esac
}
