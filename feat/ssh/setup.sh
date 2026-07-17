#!/usr/bin/env bash
set -euo pipefail

GITHUB_USER="${1:-metruzanca}"

echo "==> Setting up SSH..."

mkdir -p ~/.ssh
chmod 700 ~/.ssh

echo "==> Fetching public keys from github.com/$GITHUB_USER..."
curl -sL "https://github.com/$GITHUB_USER.keys" > ~/.ssh/authorized_keys

chmod 600 ~/.ssh/authorized_keys

echo "==> Keys written to ~/.ssh/authorized_keys"
echo "==> Enabling sshd..."

sudo systemctl enable --now sshd

echo "==> SSH setup complete"
echo "    Connect with: ssh $GITHUB_USER@$(hostname -I | awk '{print $1}')"
