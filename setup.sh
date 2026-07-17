#!/usr/bin/env bash
#
# Master setup for dotfiles using GNU Stow.
# Symlinks home/ into ~/ via stow, then lists feature setup scripts.
#

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# --- Check for stow ---

if ! command -v stow &>/dev/null; then
    echo "GNU Stow is not installed."
    if gum confirm "Install stow via Homebrew?"; then
        brew install stow
    else
        echo "Stow is required. Exiting."
        exit 1
    fi
fi

echo "==> Dotfiles: $DOTFILES_DIR"
echo ""

# --- Symlink home/ into ~/ ---

echo "==> Stowing home/"
stow -v -d "$DOTFILES_DIR" -t "$HOME" --no-folding home

echo ""
echo "==> Home symlinks complete"
echo ""

# --- Feature setup scripts ---

echo "==> Feature setup scripts:"
echo ""

for setup in "$DOTFILES_DIR"/feat/*/setup.sh; do
    [[ -f "$setup" ]] || continue
    feature="$(basename "$(dirname "$setup")")"
    echo "  feat/$feature/setup.sh"
done

echo ""
echo "==> Done! Open a new terminal or run: source ~/.bashrc"
