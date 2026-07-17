# Dotfiles

Personal dotfiles for the **toaster** — an ASUS E203NA running Aurora Linux (Fedora Atomic / Universal Blue).

## Structure

Feature-oriented layout. Each feature is self-contained under `feat/`:

```
feat/
├── server-boot/    Boot menu with desktop/server mode toggle
└── ssh/            Quick SSH setup from GitHub keys
```

Shared config lives at the root:

```
home/       Shell configs, agents.md, SSH keys, opencode config
Brewfile    Declarative brew package list
docs/       Misc documentation
```

## Quick Start

```bash
git clone git@github.com:metruzanca/dotfiles-toaster.git ~/dotfiles
cd ~/dotfiles
./setup.sh
```

This symlinks `home/` files into `~/` and installs brew packages. Feature-specific setup scripts are listed at the end — run them as needed.

### Individual features

```bash
./feat/server-boot/setup.sh
```

### SSH setup (fetch keys from GitHub, enable sshd)

```bash
./feat/ssh/setup.sh
```

### Brew packages

```bash
brew bundle --file=~/dotfiles/Brewfile
```
