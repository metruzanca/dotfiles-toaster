# Server Boot Mode

This laptop can boot into two modes via GRUB menu:

- **Aurora Desktop** — KDE Plasma (graphical.target)
- **Aurora Server** — Terminal only, no GUI (multi-user.target)

## How It Works

Each ostree deployment gets a BLS (Boot Loader Specification) entry in `/boot/loader/entries/`. The script `create-server-boot-entry` clones the latest desktop entry and appends `systemd.unit=multi-user.target` to the kernel options, creating a server variant.

### GRUB Timeout

The GRUB menu timeout is set to 10 seconds via `/etc/default/grub`. After each ostree deployment (system update), the `server-boot-entry.service` automatically regenerates `grub.cfg` to preserve this setting, since bootupd may overwrite it.

### Files

| File | Purpose |
|---|---|
| `/usr/local/bin/create-server-boot-entry` | Script that creates the server BLS entry |
| `/etc/default/grub` | GRUB config (timeout=10s) |
| `/etc/systemd/system/server-boot-entry.path` | Watches `/boot/loader/entries/` for new deployments |
| `/etc/systemd/system/server-boot-entry.service` | Runs script + regenerates grub.cfg (triggered by path watcher) |
| `etc/systemd/system/server-boot-entry-boot.service` | Runs at boot as a safety net |
| `dotfiles/scripts/create-server-boot-entry` | Source copy in dotfiles repo |
| `dotfiles/systemd/server-boot-entry*.service` | Source copies in dotfiles repo |
| `dotfiles/etc/default/grub` | Source copy of GRUB config |
| `dotfiles/setup-server-boot.sh` | One-shot installer for the above |

### Automatic Updates

The `server-boot-entry.path` unit watches `/boot/loader/entries/` with `PathChanged`. When `rpm-ostree` stages a new deployment, new BLS files appear, and the path watcher triggers the service which:

1. Creates the server BLS entry
2. Regenerates `grub.cfg` to preserve the 10s timeout

No manual intervention needed after updates.

### Cleaning up old deployments

Ostree keeps old deployments until pruned. If you see too many entries in GRUB:

```bash
sudo ostree admin cleanup
```

## Usage

At boot, GRUB shows both entries (10 second timeout). Pick one with arrow keys.

### Server mode

Boots into `multi-user.target`. No KDE, no GPU usage. SSH is available (sshd starts automatically if enabled).

### Desktop mode

Boots into `graphical.target`. Full KDE Plasma session.

### Switching

Just reboot and pick the other entry. No reconfiguration needed.

## Manual Commands

```bash
# Recreate the server entry manually
sudo create-server-boot-entry

# Regenerate grub.cfg
sudo grub2-mkconfig -o /boot/grub2/grub.cfg

# Check which target is default
systemctl get-default

# Check status of the path watcher
systemctl status server-boot-entry.path
```

## Troubleshooting

### GRUB timeout reset after update

The service should regenerate grub.cfg automatically. If it didn't:

```bash
sudo grub2-mkconfig -o /boot/grub2/grub.cfg
```

### Server entry missing after update

Run the script manually:

```bash
sudo create-server-boot-entry
```

### SSH not working in server mode

Ensure sshd is enabled:

```bash
sudo systemctl enable sshd
```
