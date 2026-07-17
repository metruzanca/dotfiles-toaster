#!/usr/bin/env bash
#
# Install custom console keymap to disable Alt+Arrow TTY switching.
# Run once after cloning dotfiles, or after changes to the keymap.
#

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Installing keymaps to /usr/local/share/keymaps/"
sudo install -d /usr/local/share/keymaps
sudo install -m 644 "$SCRIPT_DIR/keymaps/no-console-switch.map" /usr/local/share/keymaps/
sudo install -m 644 "$SCRIPT_DIR/keymaps/no-console-switch.inc" /usr/local/share/keymaps/

echo "Installing systemd unit to /etc/systemd/system/"
sudo install -m 644 "$SCRIPT_DIR/systemd/disable-console-switch.service" /etc/systemd/system/

echo "Enabling service..."
sudo systemctl daemon-reload
sudo systemctl enable disable-console-switch.service

echo "Loading keymap now..."
sudo loadkeys /usr/local/share/keymaps/no-console-switch.map

echo ""
echo "Done! Alt+Left/Right TTY switching is disabled."
echo "It will persist across reboots via disable-console-switch.service."
