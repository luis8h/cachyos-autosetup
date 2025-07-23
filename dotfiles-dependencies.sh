#!/usr/bin/env bash

set -euo pipefail

# List of required packages
PACKAGES=(
    git
    curl
    neovim
    htop
    base-devel
    stow
    rust
    kitty
    zsh
    tree
    fzf
    zoxide
    tmux
    xclip
)

# Function to check if a package is installed
is_installed() {
    pacman -Q "$1" &>/dev/null
}

# Main installation logic
install_packages() {
    echo "Checking and installing missing packages..."

    local missing=()

    for pkg in "${PACKAGES[@]}"; do
        if is_installed "$pkg"; then
            echo "✓ $pkg is already installed"
        else
            echo "✗ $pkg is not installed"
            missing+=("$pkg")
        fi
    done

    if [ ${#missing[@]} -eq 0 ]; then
        echo "All packages are already installed."
    else
        echo "Installing missing packages: ${missing[*]}"
        sudo pacman -S --needed --noconfirm "${missing[@]}"
    fi
}

install_yay() {
    if command -v yay &>/dev/null; then
        echo "yay is already installed."
    else
        echo "Installing yay..."
        sudo pacman -S --needed base-devel git
        tmpdir=$(mktemp -d)
        git clone https://aur.archlinux.org/yay.git "$tmpdir/yay"
        cd "$tmpdir/yay"
        makepkg -si --noconfirm
        cd -
        rm -rf "$tmpdir"
        echo "yay installed."
    fi
}

echo "installing packages..."
install_packages

echo "installing yay ..."
install_yay

echo "installing other tools ..."

# zgen
git clone https://github.com/tarjoilija/zgen.git "${HOME}/.zgen"

# kanata
cargo install kanata

# set zsh as default
chsh -s $(which zsh)

# nerdfont
yay -S nerd-fonts-jetbrains-mono

# tmux plugin manager
yay -S tmux-plugin-manager
