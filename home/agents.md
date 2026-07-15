# Agents Guide

## System Overview

- **Distro**: Aurora Linux 44 (Fedora Kinoite variant, Universal Blue)
- **Desktop**: KDE Plasma (Wayland session)
- **Kernel**: 7.0.8
- **Image**: `ghcr.io/ublue-os/aurora:stable`
- **Home dir**: `/var/home/metru`

## Immutable System

This is an **immutable Fedora** system. The base OS is managed by `rpm-ostree` and delivered as a container image. Do NOT use `dnf` or `yum` — they are not available.

- **System packages**: Managed via `rpm-ostree` overlays or the base image.
- **Layered packages**: `rpm-ostree install <pkg>` (persists across updates).
- **System updates**: `rpm-ostree upgrade` or via GNOME Software/KDE Discover.
- **Reboot required**: After most `rpm-ostree` changes and image updates.
- **COPR repos**: One active — `ledif/kairpods`.

## Package Management

Use these three layers in order of preference:

### 1. Flatpak (GUI applications)

Primary method for installing desktop apps.

```bash
flatpak install flathub <app-id>
flatpak list --columns=application
flatpak update
flatpak uninstall <app-id>
flatpak info <app-id>
```

- Flatpak apps are sandboxed with their own filesystem views.
- Config often lives under `~/.var/app/<app-id>/`.
- Use `Flatseal` (`com.github.tchx84.Flatseal`) to manage permissions.

### 2. Homebrew (CLI tools and libraries)

Installed at `/home/linuxbrew/.linuxbrew`. PATH is already configured in `.zshrc` and `.bash_profile`.

```bash
brew install <formula>
brew list
brew update
brew upgrade
brew uninstall <formula>
```

- Brew installs into `/home/linuxbrew/.linuxbrew/Cellar/`.
- Does NOT require root/sudo.
- Useful for dev tools, CLI utilities, and language runtimes.

### 3. rpm-ostree (system packages, last resort)

For packages that need system-level integration or aren't available via the above.

```bash
rpm-ostree install <package>
rpm-ostree list --installed
rpm-ostree status
rpm-ostree uninstall <package>
```

**Caution**: Too many layered packages can cause update conflicts. Prefer flatpak/brew when possible. Reboot after changes.

## KDE Plasma Configuration

- **Desktop shell**: KDE Plasma 6 (Wayland)
- **Config dir**: `~/.config/`
- **Key configs**:
  - `~/.config/kwinrc` — Window manager settings
  - `~/.config/plasmashellrc` — Panel and desktop settings
  - `~/.config/kdeglobals` — Global KDE appearance
  - `~/.config/kglobalshortcutsrc` — Keyboard shortcuts
  - `~/.config/konsolerc` — Terminal profile
  - `~/.config/plasma-org.kde.plasma.desktop-appletsrc` — Panel layout
  - `~/.config/kdedefaults/` — KDE defaults
- **Plasma config tool**: `plasmashell` can be restarted with `killall plasmashell && plasmashell &`
- **Apply changes**: Most KDE config changes take effect on save or Plasma restart.

## Session Info

- **Session type**: Wayland (graphical-session-wayland.target)
- **Session user services**: Managed by systemd --user
- **Check session**: `systemctl --user status`
- **List services**: `systemctl --user list-units --type=service`

## Important Paths

| Path | Purpose |
|---|---|
| `/home/linuxbrew/.linuxbrew/` | Homebrew installation |
| `/var/home/metru/.config/` | User configuration files |
| `/var/home/metru/.var/app/` | Flatpak app data and configs |
| `/usr/bin/rpm-ostree` | System package manager |
| `/etc/ostree/` | OSTree configuration |

## Common Tasks

### Install a GUI app
```bash
flatpak install flathub <app-id>
```

### Install a CLI tool
```bash
brew install <tool>
```

### Add a system package
```bash
rpm-ostree install <package>
# Then reboot
```

### Check for system updates
```bash
rpm-ostree status          # Check current state and pending updates
rpm-ostree upgrade         # Pull new image
flatpak update             # Update flatpak runtimes and apps
brew upgrade               # Update brew packages
```

### Restart Plasma session
```bash
plasmashell --replace &
```

### Find where a flatpak stores its data
```bash
flatpak info --show-location <app-id>
```

## Restrictions

- No `dnf` / `yum` — use `rpm-ostree`, `flatpak`, or `brew` instead.
- System root filesystem is read-only (immutable). Changes to `/usr`, `/etc` etc. require `rpm-ostree` or manual overlays.
- Do not edit files under `/usr` directly — they will be overwritten on update.
- `sudo` works for system management commands but cannot be used to install packages the traditional way.
