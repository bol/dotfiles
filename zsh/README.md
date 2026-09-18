# Zsh

Configuration for Zsh.
* Sensible defaults
* Fancy prompt
* [Zoxide](https://github.com/ajeetdsouza/zoxide) for navigation

## Customization
A blank `~/.zshrc_local` which is not version controlled is installed which can be used for customization. It's sourced last and can override any setting. Also useful for pre-loading commonly used environments.
Someone working with Java applications and infrastructure on AWS might load the following tools by default as an example.
```shell
activate_aws
activate_k8s
activate_markup
activate_podman
activate_sdkman
activate_tenv
```

## Homebrew upgrades on macOS

Run `brew update && brew upgrade` to refresh package metadata and upgrade installed tools. These dotfiles disable automatic metadata refresh.

Tool modules can opt casks into greedy upgrades by calling the shared helper when the module is sourced:

```shell
register_homebrew_greedy_casks gcloud-cli
```

It accepts one or more cask names, merges them into `HOMEBREW_UPGRADE_GREEDY_CASKS`, preserves existing entries, and removes duplicates. It is a no-op outside macOS. The helper is loaded before platform bootstrap and tool modules, and is also available in `~/.zshrc_local`. Register at module scope so upgrades do not depend on calling `activate_<name>` first.

GCP registers its `auto_updates` cask this way. The [Codex CLI cask](https://formulae.brew.sh/cask/codex) is versioned and does not currently set `auto_updates`, so ordinary upgrades already include it. AWS CLI is a formula and likewise needs no opt-in.

## Environment support
The module contains for option support for environments. These are not loaded by default and must be activated with `activate_<name>` to use.
### AWS
Activated with `activate_aws`. On macOS, offers to install the `awscli` Homebrew formula when the CLI is missing. Prefers the formula's `bin` directory over older standalone installations without duplicating `PATH` entries, and uses the selected CLI's own bash-compatible completer in zsh. Existing standalone installations remain usable until Homebrew's AWS CLI is installed.

Run `updateawscli_macos` to install or upgrade through Homebrew and activate that installation. Ordinary `brew update && brew upgrade` also includes AWS CLI; it needs no cask upgrade opt-in. This helper replaces the previous official-package updater, so running it with only a standalone installation adopts Homebrew without removing the old installation.

The [Homebrew formula](https://formulae.brew.sh/formula/awscli) is community-managed. [AWS recommends its own installer](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) and does not guarantee third-party repository freshness. On Linux, activation continues to print distribution-specific installation guidance when the CLI is missing.
### GCP
Activated with `activate_gcloud`. Reuses `gcloud` on `PATH`, or discovers an SDK in `~/google-cloud-sdk` or the Homebrew prefix. Adds the SDK's `bin` directory to `PATH` without duplicates so additional components are available, and loads its zsh completions when available.

On macOS, offers to install the `gcloud-cli` Homebrew cask, an [installation method documented by Google](https://docs.cloud.google.com/sdk/docs/downloads-homebrew). Homebrew handles the official Google binaries, Python dependency, and Apple Silicon/Intel selection. Run `updategcloudcli_macos` to install or update: Homebrew SDKs use `brew update` followed by `brew upgrade --cask gcloud-cli`; existing standalone SDKs continue to use `gcloud components update` and are not migrated automatically.

The GCP module registers `gcloud-cli` with `register_homebrew_greedy_casks`, so ordinary `brew upgrade` includes this `auto_updates` cask. Google documents `gcloud components update` even for Homebrew installs; these dotfiles use Brew for those upgrades to keep package management unified.

On Linux, prints package-manager instructions instead of installing automatically. Google's package repository must be configured before installing `google-cloud-cli` with APT, DNF, or YUM. Use the package manager to update those installations.
### Go
Activated with `activate_goenv`. Installs and initializes [Goenv](https://github.com/syndbg/goenv.git) for go version management.
### Java
Activated with `activate_sdkman`. Installs and initializes [Sdkman](https://get.sdkman.io) for java version management.
### Kubernetes
Activated with `activate_k8s`. Install the Kubernetes CLI and command completions. Installs [Krew](https://krew.sigs.k8s.io) together with some plugins.

Provides some aliases.
### Markup
Support for working with markup files.
Activated with `activate_markup`. Installs [Gojq](https://github.com/itchyny/gojq) and [Bat](https://github.com/sharkdp/bat) and sets up aliases.
### Node.js
Activated with `activate_nodenv`. Installs and initializes [nodenv](https://github.com/nodenv/nodenv) for node.js version management.
### Podman
Activated with `activate_podman`. Installs Podman and command completions.

Provides some aliases.
### Python
Activated with `activate_pyenv`. Installs and initializes [pyenv](https://github.com/pyenv/pyenv) for Python version management.
### Ruby
Activated with `activate_rbenv`. Installs and initializes [rbenv](https://github.com/rbenv/rbenv) for Ruby version management.
### Rust
Activated with `activate_rustup`. Installs and initializes cargo
### Terraform
Activated with `activate_tenv`. Installs and initializes [tenv](https://github.com/tofuutils/tenv) for Terraform version management.
