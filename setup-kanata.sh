#!/usr/bin/env bash

set -e

# Create uinput group (if not already exists)
sudo groupadd -f uinput

# Add current user to necessary groups
sudo usermod -aG input "$USER"
sudo usermod -aG uinput "$USER"

# Create the udev rule (optional, may still be useful for hotplugging)
echo 'KERNEL=="uinput", MODE="0660", GROUP="uinput", OPTIONS+="static_node=uinput"' | sudo tee /etc/udev/rules.d/99-uinput.rules > /dev/null

# Reload udev and trigger device events
sudo udevadm control --reload-rules
sudo udevadm trigger

# Load the uinput kernel module now
sudo modprobe uinput

# Ensure uinput module loads at boot
echo "uinput" | sudo tee /etc/modules-load.d/uinput.conf > /dev/null

# Fix /dev/uinput permissions persistently using systemd-tmpfiles
echo 'z /dev/uinput 0660 root uinput -' | sudo tee /etc/tmpfiles.d/10-uinput.conf > /dev/null

# Apply tmpfiles rule immediately
sudo systemd-tmpfiles --create /etc/tmpfiles.d/10-uinput.conf

# Reload systemd user units
systemctl --user daemon-reexec
systemctl --user daemon-reload

# Enable and start Kanata
systemctl --user enable kanata.service
systemctl --user start kanata.service

echo "✅ Kanata setup complete. Please log out and log back in if this is your first time joining the 'uinput' group."
