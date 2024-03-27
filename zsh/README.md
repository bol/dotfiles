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
activate_tfenv
```
## Environment support
The module contains for option support for environments. These are not loaded by default and must be activated with `activate_<name>` to use.
### AWS
Activated with `activate_aws`. Install the AWS CLI and command completions.
### GCP
Activated with `activate_gcloud`. Install the GCP CLI and command completions.
### Go
Activated with `activate_go`. Installs and initializes [Goenv](https://github.com/syndbg/goenv.git) for go version management.
### Java
Activated with `activate_sdkman`. Installs and initializes [Sdkman](https://get.sdkman.io) for java version management.
### Kubernetes
Activated with `activate_k8s`. Install the Kubernetes CLI and command completions. Installs [Krew](https://krew.sigs.k8s.io) together with some plugins.

Provides some aliases.
### Markup
Support for working with markup files.
Activated with `activate_markup`. Installs [Gojq](https://github.com/itchyny/gojq) and [Bat](https://github.com/sharkdp/bat) and sets up aliases.
### Node.js
Activated with `activate_nodenv`. Installs and initializes [nodeenv](https://github.com/ekalinin/nodeenv) for node.js version management.
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
Activated with `activate_tfenv`. Installs and initializes [tfenv](https://github.com/tfutils/tfenv) for Terraform version management.
