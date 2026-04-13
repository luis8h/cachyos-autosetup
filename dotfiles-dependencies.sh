#!/usr/bin/env bash

set -euo pipefail

sudo pacman -Syu

# List of required packages
PACKAGES=(
    keychain
    xdg-desktop-portal-hyprland # hyprland-native portal (replaces xdg-desktop-portal-gtk)
    xdg-desktop-portal-gtk # remove from the system if there are any errors related to opening the file browser from an application
    hypridle
    waybar
    flatpak
    kanshi
    nwg-displays
    cliphist
    wl-clipboard
    hyprpicker
    hyprpaper           # replaces swaybg (hyprland-native wallpaper)
    satty
    grim
    slurp
    polkit-gnome
    swaync
    network-manager-applet
    nm-connection-editor
    fcitx5
    fcitx5-gtk
    fcitx5-qt
    fcitx5-configtool
    neovim-nightly-bin
    hyprlock            # replaces swaylock (hyprland-native lock screen)
    rofi-wayland
    wireplumber
    brightnessctl
    lsd
    git
    curl
    base-devel
    stow
    zsh
    tree
    fzf
    zoxide
    tmux
    nodejs
    npm
    docker
    docker-compose
    podman
    podman-compose
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
    texlive-langgerman
    biber
    brave
    sddm
    nemo
    cronie
    ttf-terminus-nerd
    ttf-font-awesome
    ttf-firacode-nerd
    python-pip
    ntfs-3g
    jujutsu
    rclone
    ghostty
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

echo "Installing pacman packages..."
install_packages

echo "Installing yay..."
install_yay

echo "Installing yay packages..."
install_yay_packages zgen papirus-icon-theme papirus-folders-catppuccin-git

echo "Installing other tools..."

# rust (manual)
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source "$HOME/.cargo/env"

# kanata
cargo install kanata

# set zsh as default
set_default_shell_to_zsh

# docker
sudo systemctl start docker.service
sudo systemctl enable docker.service
sudo usermod -aG docker "$USER"

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

# install possibly missing audio drivers
sudo pacman -S sof-firmware pipewire pipewire-alsa pipewire-pulse pipewire-jack wireplumber alsa-utils alsa-firmware alsa-ucm-conf

# enable cronie
sudo systemctl start cronie.service
sudo systemctl enable cronie.service

# enable gtk themes (dotfiles need to be installed)
gsettings set org.gnome.desktop.interface gtk-theme 'Catppuccin-Dark'
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
papirus-folders -C cat-mocha-lavender -t Papirus

echo "Finished!"
