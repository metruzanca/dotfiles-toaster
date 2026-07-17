#!/usr/bin/env bash
#
# Deploy the server boot entry system and GRUB timeout config.
# Run once after cloning dotfiles, or after changes to the script/units.
#

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$SCRIPT_DIR"

echo "Installing create-server-boot-entry to /usr/local/bin/"
sudo install -m 755 "$REPO_DIR/scripts/create-server-boot-entry" /usr/local/bin/create-server-boot-entry

echo "Installing /etc/default/grub (10s timeout)..."
sudo install -m 644 "$REPO_DIR/etc/default/grub" /etc/default/grub

echo "Installing systemd units to /etc/systemd/system/"
sudo install -m 644 "$REPO_DIR/systemd/server-boot-entry.service" /etc/systemd/system/
sudo install -m 644 "$REPO_DIR/systemd/server-boot-entry.path" /etc/systemd/system/
sudo install -m 644 "$REPO_DIR/systemd/server-boot-entry-boot.service" /etc/systemd/system/

echo "Enabling services..."
sudo systemctl daemon-reload
sudo systemctl enable --now server-boot-entry.path
sudo systemctl enable server-boot-entry-boot.service

echo "Creating initial server boot entry..."
sudo /usr/local/bin/create-server-boot-entry

echo "Regenerating grub.cfg with 10s timeout..."
sudo grub2-mkconfig -o /boot/grub2/grub.cfg

echo ""
echo "Done! Reboot and you should see both entries in GRUB (10s timeout):"
echo "  - Aurora Desktop  (KDE)"
echo "  - Aurora Server   (terminal only)"
echo ""
echo "To switch: reboot and pick from the GRUB menu."
