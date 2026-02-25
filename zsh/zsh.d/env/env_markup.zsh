function activate_markup() {
  # Use gojq instead of regular jq as the original has broken base64 handling and is no longer maintained.
  # This also gives us YAML support
  # https://github.com/stedolan/jq/issues/1931
  __ensure_package_is_installed gojq || return 1
  __ensure_package_is_installed bat || return 1

  # Query JSON
  alias jq='gojq'
  # Colorize JSON
  alias jc='bat --language JSON'
  # Convert JSON to YAML
  alias j2y='gojq --yaml-output'

  # Query YAML
  alias yq='gojq --yaml-output --yaml-input'
  # Colorize YAML
  alias yc='bat --language YAML'
}
