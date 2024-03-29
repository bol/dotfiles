set_if_unset() {
  local KEY="${1}"
  local VALUE="${2}"

  if [[ -z "${(P)KEY}" ]]; then
    export "${KEY}"="${VALUE}"
  fi
}

# Use english language and Swedish units if not set otherwise.
set_if_unset 'LANG' 'en_US.UTF-8'
set_if_unset 'LC_MEASUREMENT' 'sv_SE.UTF-8'
set_if_unset 'LC_MONETARY' 'sv_SE.UTF-8'
set_if_unset 'LC_NUMERIC' 'sv_SE.UTF-8'
set_if_unset 'LC_PAPER' 'sv_SE.UTF-8'
set_if_unset 'LC_TIME' 'sv_SE.UTF-8'

# LC_ALL is meant for debugging and should never be set by default.
if [[ -z "${LC_ALL}" ]]; then
  unset LC_ALL
fi
