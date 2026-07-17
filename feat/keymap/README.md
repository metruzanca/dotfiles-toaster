# Console Keymap

Disables Alt+Arrow TTY switching on the Linux console.

## Why

Alt+Left/Right switches between TTYs by default. This is easy to trigger accidentally, especially in terminal multiplexers and editors that use Alt+Arrow for navigation.

## How It Works

A custom console keymap remaps Alt+Arrow to the plain arrow key, effectively neutralizing the TTY switch. A systemd service loads the keymap at boot.

### Files

| File | Purpose |
|---|---|
| `keymaps/no-console-switch.map` | Keymap source (Alt+Arrow -> Arrow) |
| `keymaps/no-console-switch.inc` | Include fragment for use in other keymaps |
| `systemd/disable-console-switch.service` | Loads keymap at boot (after vconsole-setup) |
| `/usr/local/share/keymaps/no-console-switch.map` | Installed keymap |
| `/etc/systemd/system/disable-console-switch.service` | Installed service |

## Usage

```bash
# Install
./setup.sh

# Apply immediately without reboot
sudo loadkeys /usr/local/share/keymaps/no-console-switch.map

# Check service status
sudo systemctl status disable-console-switch.service
```

## Manual Commands

```bash
# Reload keymap
sudo loadkeys /usr/local/share/keymaps/no-console-switch.map

# Disable the service
sudo systemctl disable disable-console-switch.service

# Remove installed files
sudo rm /usr/local/share/keymaps/no-console-switch.{map,inc}
sudo rm /etc/systemd/system/disable-console-switch.service
sudo systemctl daemon-reload
```
