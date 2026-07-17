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
stow -v -d "$DOTFILES_DIR" -t "$HOME" --no-folding --adopt home

echo ""
echo "==> Home symlinks complete"
echo ""

# --- Feature setup scripts ---

features=()
for setup in "$DOTFILES_DIR"/feat/*/setup.sh; do
    [[ -f "$setup" ]] || continue
    features+=("$setup")
done

if [[ ${#features[@]} -gt 0 ]]; then
    if gum confirm "Run feature setup scripts?"; then
        echo ""
        for setup in "${features[@]}"; do
            feature="$(basename "$(dirname "$setup")")"
            if gum confirm "  Run feat/$feature/setup.sh?"; then
                echo ""
                bash "$setup"
                echo ""
            fi
        done
    fi
fi

echo "==> Done! Open a new terminal or run: source ~/.bashrc"
