#!/usr/bin/env bash

# discord and vencord
sudo pacman -S discord --noconfirm
sh -c "$(curl -sS https://raw.githubusercontent.com/Vendicated/VencordInstaller/main/install.sh)"

# freefilesync
sudo pacman -S freefilesync --noconfirm

# intellij and java
sudo pacman -S intellij-idea-community-edition --noconfirm

# pycharm and uv
sudo pacman -S pycharm-community-edition --noconfirm
curl -LsSf https://astral.sh/uv/install.sh | sh

# go
sudo pacman -S go --noconfirm

# postman
yay -S postman-bin --noconfirm

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


