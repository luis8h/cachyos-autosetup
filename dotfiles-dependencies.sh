#!/usr/bin/env bash

set -euo pipefail

sudo pacman -Syu

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
    nodejs
    npm
    docker
    docker-compose
    ripgrep
    fd
    expat
    libxml2
    pkgconf
    alsa-lib
    openssl
    cmake
    freetype2
    libxcb
    harfbuzz
    fontconfig
    gcc
    ttf-jetbrains-mono-nerd
    texlive-binextra
    texlive
    brave
    sddm
    nemo
    cronie
    flameshot
    network-manager-applet
    nm-connection-editor
    lxrandr
    ttf-terminus-nerd
    ttf-font-awesome
    lxqt-config
    python-pip
    ttf-firacode-nerd
    xss-lock
    xorg-xhost
    ntfs-3g
    jujutsu
    rclone
    zen-browser
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

install_yay_package() {
    local pkg=$1

    if pacman -Q "$pkg" &>/dev/null || yay -Q "$pkg" &>/dev/null; then
        echo "✓ $pkg is already installed"
    else
        echo "Installing $pkg via yay..."
        yay -S --noconfirm "$pkg"
    fi
}

install_yay_packages() {
    for pkg in "$@"; do
        install_yay_package "$pkg"
    done
}

set_default_shell_to_zsh() {
    local zsh_path
    zsh_path=$(command -v zsh)

    if ! grep -qx "$zsh_path" /etc/shells; then
        echo "Adding $zsh_path to /etc/shells"
        echo "$zsh_path" | sudo tee -a /etc/shells
    fi

    echo "Changing default shell to $zsh_path for $USER"
    chsh -s "$zsh_path"
}

echo "installing pacman packages ..."
install_packages

echo "installing yay ..."
install_yay

echo "installing yay packages ..."
install_yay_packages zgen papirus-icon-theme papirus-folders-catppuccin-git

echo "installing other tools ..."

# kanata
cargo install kanata

# set zsh as default
set_default_shell_to_zsh

# docker
sudo systemctl start docker.service
sudo systemctl enable docker.service
sudo usermod -aG docker $USER

# needed for treesitter auto_install to work with vimtex
sudo npm install -g tree-sitter-cli

# silicon
cargo install silicon

# refresh font cache
fc-cache -fv

# tpm
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
else
    echo "tmux plugin manager (tpm) already installed."
fi

# switch display manager (might also resolve suspend issues)
sudo systemctl disable ly.service
sudo systemctl enable sddm.service

# enable cronie
sudo systemctl start cronie.service
sudo systemctl enable cronie.service

# enable gtk themes (dotfiles need to be installed)
gsettings set org.gnome.desktop.interface gtk-theme 'Catppuccin-Dark'
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
papirus-folders -C cat-mocha-lavender -t Papirus

echo "Finished!"
