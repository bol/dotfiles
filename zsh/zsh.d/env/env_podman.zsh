# Containers
# Using Podman for local container handling.

function activate_podman() {
  for cmd in podman podman-compose; do
      if ! (( $+commands[$cmd] )); then
        print "The ${cmd} was not found on your path.\n"
        case "$(uname -s)" in
            Darwin)
              read -q "?Do you want to install it from homebrew? " || return -1
              print ''
              brew install "${cmd}"
                ;;
            *)
                ;;
        esac
      fi
  done

  alias pm="podman"
  alias compose="podman-compose"

  function pm-machine-reset() {
    machine_found=0
    machine_running=0
    for line in "${(@f)$(podman machine list --noheading --format '{{range .}}{{.Name}}\t{{.LastUp}}\n{{end -}}' )}"; do
      [[ -z "${line}" ]] && continue
      IFS=$'\t' read -A machine <<< "$line"
      machine_found=1
      [[ "${machine[2]}" == 'Currently running' ]] && machine_running=1
    done
    if (( $machine_running )); then
      podman machine stop
    fi
    if (( $machine_found )); then
      podman machine rm --force podman-machine-default
    fi

    podman machine init --cpus=2 --disk-size=20 --memory 4096 && \
      podman machine set --rootful && \
      podman machine start && \
      podman machine ssh "sudo rpm-ostree install podman-docker qemu-user-static && sudo systemctl reboot"
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
