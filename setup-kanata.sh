#!/usr/bin/env bash

sudo groupadd uinput

sudo usermod -aG input $USER
sudo usermod -aG uinput $USER

sudo touch /etc/udev/rules.d/99-input.rules
echo 'KERNEL=="uinput", MODE="0660", GROUP="uinput", OPTIONS+="static_node=uinput"' | sudo tee /etc/udev/rules.d/99-input.rules

sudo udevadm control --reload-rules && sudo udevadm trigger

sudo modprobe uinput

systemctl --user daemon-reload
systemctl --user enable kanata.service
systemctl --user start kanata.service
