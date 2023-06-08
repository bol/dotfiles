function activate_markup() {
  for cmd in gojq bat; do
      __ensure_package_is_installed "${cmd}"
  done

  # Query JSON
  # Use gojq instead of regular jq as the original has broken base64 handling and is no longer maintained.
  # This also gives us YAML support
  # https://github.com/stedolan/jq/issues/1931
  alias jq='gojq'
  # Colorize JSON
  alias jc="bat --language JSON --theme 'Solarized (dark)' --style=plain"
  # Convert JSON to YAML
  alias j2y='gojq --yaml-output'

  # Query YAML
  alias yq='gojq --yaml-output --yaml-input'
  # Colorize YAML
  alias yc="bat --language YAML --theme 'Solarized (dark)' --style=plain"
}
