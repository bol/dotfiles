# Dotfiles

Opinionated dotfiles for a modern shell-centric workflow with consistent tooling and color theme defaults.

## Goals
- A modern but minimal base shell with sane defaults, lightweight UX improvements, and no heavy framework lock-in.
- Do not fight standard Unix muscle memory.
- Keep environments modular and opt-in: language and cloud tooling is activated only when needed via `activate_<name>` functions.
- Keep Linux and macOS first class, with different installation strategies where needed.
- Enable high daily productivity through strong prompt context, completions, navigation/search helpers, and useful aliases.
- Keep user control over automation: missing tools are handled with interactive prompts instead of silent system mutation.
- Maintain a safe install model: link/copy dotfiles without overwriting existing local files, and support explicit local overrides.

## Support Matrix
| Platform | Status | Notes |
| --- | --- | --- |
| macOS | First class | Uses Homebrew for package bootstrap in zsh setup. |
| Linux | First class | Uses distro package managers; missing tools are reported with install hints. |

## Prerequisites
- `zsh`
- `git`
- `curl`
- `nvim` and `tree-sitter` CLI (required for the `nvim` module; `./install nvim` offers to install `neovim` and `tree-sitter-cli` on macOS)
- Internet access during install (fonts, plugin/bootstrap downloads)

## Quick Start
```shell
git clone https://github.com/bol/dotfiles.git
cd dotfiles
./install
```

Install specific modules only:
```shell
./install zsh git wezterm
```

## What The Installer Does
- Installs all modules by default (`fonts`, `git`, `nvim`, `wezterm`, `zsh`).
- Creates symlinks for managed config files.
- Copies selected local files only when missing:
  - `~/.zshrc_local`
  - `~/.gitconfig`
- Never overwrites existing targets. Existing files are skipped.

## Modules
- [Zsh](zsh/README.md): shell config, prompt, completions, environment activators.
- [WezTerm](wezterm/README.md): terminal config with Selenized theme.
- [Fonts](fonts/README.md): Nerd Font variants used by prompt/terminal.
- [Git](git/README.md): defaults, Delta diffs, Difftastic difftool.
- [NeoVim](nvim/README.md): editor setup with plugin bootstrap.

## Customization
- Use `~/.zshrc_local` for machine- or user-specific overrides.
- `~/.zshrc_local` is sourced last and is not tracked by this repo.

## Update Workflow
```shell
git pull --ff-only
./install
```

## Rollback
- Remove symlinks created by this repo and restore your own files.
- Re-run `./install` after adjustments if you want selective re-linking.

## Troubleshooting
- Install skipped because target already exists: move/remove the target, then re-run `./install`.
- AWS CLI on Linux: the setup prints distro package manager install hints when `aws` is missing.
- Neovim module fails: on macOS rerun `./install nvim` and allow Homebrew to install `neovim`; on Linux install `nvim` manually and rerun.
- Neovim parser bootstrap fails: on macOS rerun `./install nvim` and allow Homebrew to install `tree-sitter-cli`; on Linux install `tree-sitter` manually and rerun.

## Important Note About Git Identity
The Git module copies `~/.gitconfig` from `git/gitconfig.ini` on first install. Review and update user identity/signing settings for your machine if needed.
