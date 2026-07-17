#!/usr/bin/env bash
#
# Master setup for dotfiles.
# Symlinks home/ files into ~/ and runs feature setup scripts.
#

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HOME_DIR="$DOTFILES_DIR/home"

echo "==> Dotfiles: $DOTFILES_DIR"
echo ""

# --- Symlink home/ files ---

echo "==> Symlinking home/ files into ~/"

symlink() {
    local src="$1"
    local dst="$2"

    if [[ -L "$dst" ]]; then
        rm "$dst"
    elif [[ -e "$dst" ]]; then
        echo "    Backing up existing $dst -> ${dst}.bak"
        mv "$dst" "${dst}.bak"
    fi

    mkdir -p "$(dirname "$dst")"
    ln -sf "$src" "$dst"
    echo "    Linked $dst -> $src"
}

# Shell configs
symlink "$HOME_DIR/.bashrc" "$HOME/.bashrc"
symlink "$HOME_DIR/.zshrc" "$HOME/.zshrc"

# Dotfiles agents guide
symlink "$HOME_DIR/agents.md" "$HOME/agents.md"

# .config files
for f in "$HOME_DIR"/.config/*; do
    [[ -e "$f" ]] || continue
    name="$(basename "$f")"
    symlink "$f" "$HOME/.config/$name"
done

# .ssh files (authorized_keys, known_hosts, public keys)
for f in "$HOME_DIR"/.ssh/*; do
    [[ -e "$f" ]] || continue
    name="$(basename "$f")"
    # Skip agent socket files and private key dirs
    [[ "$name" == agent ]] && continue
    [[ "$name" == "known_hosts.old" ]] && continue
    mkdir -p "$HOME/.ssh"
    symlink "$f" "$HOME/.ssh/$name"
done
chmod 700 "$HOME/.ssh" 2>/dev/null || true

echo ""
echo "==> Home symlinks complete"
echo ""

# --- Brew packages ---

if command -v brew &>/dev/null; then
    echo "==> Installing brew packages from Brewfile"
    brew bundle --file="$DOTFILES_DIR/Brewfile" --no-lock
    echo ""
fi

# --- Feature setup scripts ---

echo "==> Checking feature setup scripts..."
echo ""

for setup in "$DOTFILES_DIR"/feat/*/setup.sh; do
    [[ -f "$setup" ]] || continue
    feature="$(basename "$(dirname "$setup")")"
    echo "  Found: feat/$feature/setup.sh"
    echo "  Run manually with: ./$setup"
    echo ""
done

echo "==> Done! Open a new terminal or run: source ~/.bashrc"
