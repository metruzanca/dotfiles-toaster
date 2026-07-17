# Server Boot Mode

This laptop can boot into two modes via GRUB menu:

- **Aurora Desktop** — KDE Plasma (graphical.target)
- **Aurora Server** — Terminal only, no GUI (multi-user.target)

## How It Works

Each ostree deployment gets a BLS (Boot Loader Specification) entry in `/boot/loader/entries/`. The script `create-server-boot-entry` clones the latest desktop entry and appends `systemd.unit=multi-user.target` to the kernel options, creating a server variant.

### Files

| File | Purpose |
|---|---|
| `/usr/local/bin/create-server-boot-entry` | Script that creates the server BLS entry |
| `/etc/systemd/system/server-boot-entry.path` | Watches `/boot/loader/entries/` for new deployments |
| `/etc/systemd/system/server-boot-entry.service` | Runs the script (triggered by path watcher) |
| `/etc/systemd/system/server-boot-entry-boot.service` | Runs at boot as a safety net |
| `dotfiles/scripts/create-server-boot-entry` | Source copy in dotfiles repo |
| `dotfiles/systemd/server-boot-entry*.service` | Source copies in dotfiles repo |
| `dotfiles/setup-server-boot.sh` | One-shot installer for the above |

### Automatic Updates

The `server-boot-entry.path` unit watches `/boot/loader/entries/` for `DirectoryChanged`. When `rpm-ostree` stages a new deployment, new BLS files appear, and the path watcher triggers the script to create the server variant automatically. No manual intervention needed after updates.

## Usage

At boot, GRUB shows both entries. Pick one with arrow keys.

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

# Check which target is default
systemctl get-default

# Check status of the path watcher
systemctl status server-boot-entry.path
```

## Troubleshooting

### GRUB menu not showing

If GRUB boots too fast to see the menu, hold **Shift** or **Esc** during boot to force it. You can also set the GRUB timeout:

```bash
# Check current timeout
grep TIMEOUT /etc/default/grub

# Set to 5 seconds
sudo sed -i 's/GRUB_TIMEOUT=.*/GRUB_TIMEOUT=5/' /etc/default/grub
sudo grub2-mkconfig -o /boot/grub2/grub.cfg
```

On Universal Blue with bootupd, GRUB config may be managed differently. Check `bootupd` docs if the above doesn't work.

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
