# Agents Guide — Dotfiles Repo

## Overview

This repo manages dotfiles for the **toaster** (ASUS E203NA, Aurora Linux 44). It uses a feature-oriented structure — each feature is self-contained under `feat/`.

## Repo Structure

```
dotfiles/
├── home/               Files that symlink into ~/
│   ├── .bashrc
│   ├── .zshrc
│   ├── agents.md       System guide (for agents on the live system)
│   ├── .config/        XDG config (opencode, cheatsheet, etc.)
│   └── .ssh/           SSH keys and config
├── feat/               Self-contained features, each with own setup.sh
│   ├── server-boot/    GRUB dual-entry (desktop / server mode)
│   └── ssh/            SSH setup from GitHub keys
├── Brewfile            Declarative brew packages
├── docs/               Misc documentation
├── agents.md           This file (for agents working on the dotfiles repo)
├── README.md           Repo overview and quick start
└── setup.sh            Master setup: symlinks + feature installs
```

## Conventions

### Git

- **Conventional commits**: `type(scope): description`
  - Types: `feat`, `fix`, `docs`, `style`, `refactor`, `chore`, `test`
  - Scope is optional but preferred (e.g., `feat(server-boot):`, `docs(agents):`)
- **Always push** after committing. No unpushed work.

### Features

Each feature in `feat/` must be self-contained:

```
feat/<name>/
├── README.md           What it does and how to use it
├── setup.sh            One-shot install script
├── scripts/            Executable scripts (installed to /usr/local/bin, etc.)
├── systemd/            Systemd units (installed to /etc/systemd/system/)
├── etc/                System config (installed to /etc/)
└── docs/               Additional documentation (if needed)
```

Setup scripts use `$SCRIPT_DIR` for relative paths — they work regardless of where the repo is cloned.

### Dotfile Changes

- Edit files in `home/`, not in `~/` directly.
- Run `./setup.sh` (or re-source the shell) after changes.
- If an OS-level change is made, add it to the appropriate feature or create a new one.

## System Details

- **Distro**: Aurora Linux 44 (Universal Blue / Fedora Atomic)
- **Desktop**: KDE Plasma 6 (Wayland)
- **Home**: `/var/home/metru`
- **Package layers**: Flatpak → Homebrew → rpm-ostree

See `home/agents.md` for the full system guide that agents use on the live machine.

## Restrictions

- Do NOT commit private SSH keys (`id_*` without `.pub`).
- Do NOT commit secrets, tokens, or `.env` files.
- `/usr` is read-only (immutable). Use `feat/` + setup scripts for system changes.
