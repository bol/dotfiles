# Dotfiles

A set of configuration for a modern, minimalistic shell environment.

## Installation

To use, clone the repository and run the install script. This symlinks in the configuration. No files will be overwritten, you will need to delete any eventual pre-existing local files to fully use this collection.

```
git clone https://github.com/bol/dotfiles.git
cd dotfiles && ./install`
```
## Usage

The collection is centered on the Zsh shell used in the terminal emulator Wezterm. Support for different environments can be activated with the activate_ set of functions. As an example, someone working with containerized Java applications in AWS might find the following support useful.
```
activate_aws
activate_k8s
activate_markup
activate_podman
activate_sdkman
activate_tfenv
```

Customizations are intended to be placed in `~/.zshrc_local` which is not version controlled.
