#!/usr/bin/env bash

# discord and vencord
sudo pacman -S discord --noconfirm
sh -c "$(curl -sS https://raw.githubusercontent.com/Vendicated/VencordInstaller/main/install.sh)"

# intellij and java
sudo pacman -S intellij-idea-community-edition --noconfirm

# pycharm and uv
sudo pacman -S pycharm-community-edition --noconfirm
curl -LsSf https://astral.sh/uv/install.sh | sh

# bun
curl -fsSL https://bun.sh/install | bash

# markdown -> pdf
bun i -g md-to-pdf

# go
sudo pacman -S go --noconfirm

# bitwarden
sudo pacman -S bitwarden --noconfirm

# betterbird
sudo pacman -S betterbird --noconfirm

# imave viewer
sudo pacman -S loupe --noconfirm
# set as default
xdg-mime default org.gnome.Loupe.desktop image/png
xdg-mime default org.gnome.Loupe.desktop image/apng
xdg-mime default org.gnome.Loupe.desktop image/jpeg
xdg-mime default org.gnome.Loupe.desktop image/gif

# okular pdf viewer
sudo pacman -S okular --noconfirm

# for wireguard to work
sudo pacman -S wireguard-tools

# localsend (needs ports open to work)
sudo pacman -S localsend
sudo ufw allow 53317/tcp
sudo ufw allow 53317/udp
sudo ufw reload

# vesktop for discord client alternative
sudo yay -S vesktop

# spotify
flatpak install flathub com.spotify.Client
