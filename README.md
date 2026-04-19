# autosetup script for cachyos

> **NVIDIA:** When using an NVIDIA GPU go to [this file](./nvidia-setup.md) after the basic cachyos setup to solve problems and enable proper support. It did not work on sway but seems to work out of the box for hyprland though.

## Getting Started

### CachyOS Installation Guide

Follow these steps to ensure a smooth installation of CachyOS with the Sway window manager.

####  Core Installation
* **Installer:** Launch the **Graphical Installer**.
* **Desktop Environment:** Select **Hyprland** as your window manager during the component selection phase.

####  Manual Partitioning & Mount Points
When manually configuring your drive, use the following specifications for your mount points:

| Mount Point | Size (MiB) | Filesystem | Label | Flags |
| :--- | :--- | :--- | :--- | :--- |
| `/boot` | `4096` | **FAT32** | *Leave Empty* | `boot` |
| `/` | `Remaining` | **Btrfs** | *Your Choice* | *None* |

> **⚠️ Important:** Do **not** use a label for the `/boot` partition, as this may cause the installation process to fail.


####  Additional Resources
Partitioning requirements and best practices can evolve. For the most up-to-date information, please refer to the official documentation:
👉 **[CachyOS Wiki: Installation on Root](https://wiki.cachyos.org/installation/installation_on_root/)**

#### Secure boot
- if secure boot does not work disable it temporarly and then follow the tutorial on the [official site](https://wiki.cachyos.org/configuration/secure_boot_setup/)
- enable setup mode might look different in some uefis, it might be also called clear keys
- The setup mode could also be disabled, just continue it might still work

### Autosetup
- download and install dotfiles from [here](https://github.com/luis8h/dotfiles)
- install dotfiles (instructions in repo) (dont forget to switch away from the adopted changes)
- install required tools for dotfiles: `./dotfiles-dependencies.sh`
- install optional tools: `./typical-apps.sh`
- reboot

#### Laptop specific
- setup kanata `./setup-kanata.sh`
- reboot

### Post Setup

#### Monitor Management
Currently only `nwg-display` is used to configure displays and load/create profiles. The problem is that the profiles do not get applied automatically. So frequent switching between Monitors is annoying. There is a solution to this named `kanshi`. It is already installed but commented out in the sway config. This tool has its own config file and automatically detects different profiles. But there is no gui editor for these files currently. Maybe in the future `nwg-display` will support writing those files too, but currently not. Another workaround could be a script that translates the config.

#### Email
- Use a betterbird backup (`.thunderbird` directory) and just copy it into the HOME dir on the new system

#### Tmux
- start a tmux session, and navigate to the `tmux.conf` file in nvim
- press <tmux-prefix> and then shift+i to install the plugins
- if some plugins do not work afterwards try restarting tmux, deleting the plugins from `.config/tmux/plugins` and install them again

#### Syncthing
- Create directory: `mkdir -p ~/.config/containers/systemd/`
- Copy file `cp ./syncthing.container ~/.config/containers/systemd/`
- Modify the volumes to match the correct directories (need to exist in advance for the container to work)
- `systemctl --user daemon-reload`
- `systemctl --user start syncthing`

#### Winapps
- use the installation instructions of [this website](https://github.com/winapps-org/winapps)
- first start the docker container `docker compose up`
- then connect using freerdp `xfreerdp3 /u:"MyWindowsUser" /p:"MyWindowsPassword" -grab-keyboard /v:127.0.0.1 /cert:tofu /f` (**NOTE** usually when connecting for the first time the windows screen is frozen. Just close the window and run the command again to fix this.)
- NOTE: when first starting the container its not possible to connect to the vm immediatly because it needs to install first (look at `http://127.0.0.1:8006/` in a browser to see the progress)

#### Wireguard setup
- create a new config and copy it to this pc
- move it into the right directory `sudo mv ./config.txt /etc/wireguard/wg0.conf`
- assign the correct permissions `sudo chmod 600 /etc/wireguard/wg0.conf`
- start the connection `sudo wg-quick up wg0`
- if it does not work try regenerating the resolved.conf `sudo resolvconf -u`

#### Suspend Waking Up
- list all devices which are enabled to wake up: `cat /proc/acpi/wakeup | grep enabled`
- manually toggl enabled/disabled: `sudo sh -c “echo PEG0 > /proc/acpi/wakeup”`
- to make this persistant just sopy the script like this: `sudo cp disable-some-wake.sh /usr/lib/systemd/system-sleep`
- this script can be adjusted with the devices which should be disabled

#### downloads autocleaning script
- cleans the downloads directory on every reboot (moves all files to a `trash` subdirectory)
- `crontab -e` to access cron config file
- append the following line: `@reboot ~/.scripts/clean-downloads.sh`

#### Laptop (probably deprecated)
- for high dpi displays set dpi in `.Xresources` like below and set the window scaling to be bigger `gsettings set org.gnome.settings-daemon.plugins.xsettings overrides "[{'Gdk/WindowScalingFactor', <2>}]"`
- change powerbutton behavior in `/etc/systemd/logind.conf` like this:
    ```ini
    HandlePowerKey=suspend
    HandlePowerKeyLongPress=poweroff
    ```
    and reload the config `systemctl kill -s HUP systemd-logind`

## Known Issues
#### Installation
- when pacman gives errors a reboot could solve the problems (just run the script again afterwards)

## Usefull Tips

#### Use keychain (ssh)
Just run the following command to activate the key in a shell:
```sh
eval $(keychain --eval ~/.ssh/id_ed25519)
```

#### System Snapshots
- snapper is setup by default to create a snapshot for every pacman command
- if anything breaks by a system update, open btrfs-assistant (gui tool) and just restore a previous snapshot

#### Mount NTFS
- mount ntfs file system on linux: `UUID=1ECA8969CA893DD1   /home/luis8h/store/sync/data   ntfs-3g   rw,uid=1000,gid=1000,umask=022,nofail   0 0` in /etc/fstab
- or with with no permissions set `/dev/nvme1n1p2 /mnt/data ntfs-3g rw 0 0`

#### Markdown -> PDF
- `md-to-pdf ./submissions/Module0.md`

#### mount webdav
- configure with `rclone config`
- create a systemd-service file (look at ditfiles repo for an example)
- reload `systemctl --user daemon-reload`
- enable the service `systemctl --user enable --now rclone-webdav.service`

#### default applications
- find out the mime-type of a file `file --mime-type your_image.png`
- find desktop name of an app `ls /usr/share/applications | grep -i loupe` or `ls ~/.local/share/applications | grep -i loupe`
- set default app `xdg-mime default org.gnome.Loupe.desktop image/png`

#### .Xresources
Not in source control because it depends on the systen which values are good. Here are some examples:
```bash
Xcursor.size: 8
Xft.dpi: 150
```

#### gtk theme
- get selected theme `gsettings get org.gnome.desktop.interface gtk-theme`
- get selected mode (dark/default) `gsettings get org.gnome.desktop.interface color-scheme`
- list available themes `ls /usr/share/themes` and `ls ~/.themes`
- set theme `gsettings set org.gnome.desktop.interface gtk-theme 'Catppuccin-Mocha'`
- set dark mode `gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'`
- enable folder colors `papirus-folders -C cat-mocha-lavender -t Papirus`

