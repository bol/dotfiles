# Containers
# Using Podman for local container handling.

function activate_podman() {
  for cmd in podman podman-compose; do
      __ensure_package_is_installed "${cmd}"
  done

  podman completion -f "${fpath[1]}/_podman" zsh
  alias pm="podman"
  alias compose="podman-compose"
  [[ "$(uname -s)" == "Darwin" ]] && export CONTAINERS_MACHINE_PROVIDER='applehv'

  function pm-machine-reset() {
    local machine_found=0
    local machine_running=0
    for line in "${(@f)$(podman machine list --noheading --format '{{range .}}{{.Name}}\t{{.LastUp}}\n{{end -}}' )}"; do
      [[ -z "${line}" ]] && continue
      IFS=$'\t' read -A machine <<< "$line"
      machine_found=1
      [[ "${machine[2]}" == 'Currently running' ]] && machine_running=1
    done
    if (( $machine_running )); then
      echo "Stopping previous VM"
      podman machine stop
    fi
    if (( $machine_found )); then
      echo "Removing previous VM"
      podman machine rm --force podman-machine-default
    fi

    # Install qemu-user-static for multi arch support
    echo "Initializing new VM"
    podman machine init \
      --cpus=2 \
      --disk-size=20 \
      --memory 4096 \
      --rootful \
      --now && \
      podman machine ssh 'sudo rpm-ostree install qemu-user-static && sudo systemctl reboot' &&
      podman machine start
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
