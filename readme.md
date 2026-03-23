# autosetup script for cachyos

## getting started

### cachyos
#### installation
- use the graphical installer and chose sway as a window manager

#### display settings
- use nvidia-settings (run as root: `sudo nvidia-settings &` to save the configuration to x config)
- when nvidia-settings are not available just run the install and then use lxqt-config (or use xrandr already before installing)

#### secure boot
- if secure boot does not work disable it temporarly and then follow the tutorial on the [official site](https://wiki.cachyos.org/configuration/secure_boot_setup/)
- enable setup mode might look different in some uefis, it might be also called clear keys

### autosetup
- download and install dotfiles from [here](https://github.com/luis8h/dotfiles)
- install dotfiles (instructions in repo) (dont forget to switch away from the adopted changes)
- install required tools for dotfiles: `./dotfiles-dependencies.sh`
- install optional tools: `./typical-apps.sh`
- reboot

#### laptop
- setup kanata `./setup-kanata.sh`
- reboot

### post setup

#### Email
- Use a betterbird backup (`.thunderbird` directory) and just copy it into the HOME dir on the new system

#### tmux
- start a tmux session, and navigate to the `tmux.conf` file in nvim
- press <tmux-prefix> and then shift+i to install the plugins
- if some plugins do not work afterwards try restarting tmux, deleting the plugins from `.config/tmux/plugins` and install them again

### Syncthing
- Create directory: `mkdir -p ~/.config/containers/systemd/`
- Copy filel `cp ./syncthing.container ~/.config/containers/systemd/`
- Modify the volumes to match the correct directories (need to exist in advance for the container to work)
- `systemctl --user daemon-reload`
- `systemctl --user start syncthing`

#### winapps
- use the installation instructions of [this website](https://github.com/winapps-org/winapps)
- first start the docker container `docker compose up`
- then connect using freerdp `xfreerdp3 /u:"MyWindowsUser" /p:"MyWindowsPassword" -grab-keyboard /v:127.0.0.1 /cert:tofu /f` (**NOTE** usually when connecting for the first time the windows screen is frozen. Just close the window and run the command again to fix this.)

#### Wireguard setup
- create a new config and copy it to this pc
- move it into the right directory `sudo mv ./config.txt /etc/wireguard/wg0.conf`
- assign the correct permissions `sudo chmod 600 /etc/wireguard/wg0.conf`
- start the connection `sudo wg-quick up wg0`
- if it does not work try regenerating the resolved.conf `sudo resolvconf -u`

#### fix suspend waking up
- list all devices which are enabled to wake up: `cat /proc/acpi/wakeup | grep enabled`
- manually toggl enabled/disabled: `sudo sh -c “echo PEG0 > /proc/acpi/wakeup”`
- to make this persistant just sopy the script like this: `sudo cp disable-some-wake.sh /usr/lib/systemd/system-sleep`
- this script can be adjusted with the devices which should be disabled

#### downloads autocleaning script
- cleans the downloads directory on every reboot (moves all files to a `trash` subdirectory)
- `crontab -e` to access cron config file
- append the following line: `@reboot ~/.scripts/clean-downloads.sh`

#### laptop
- for high dpi displays set dpi in `.Xresources` like below and set the window scaling to be bigger `gsettings set org.gnome.settings-daemon.plugins.xsettings overrides "[{'Gdk/WindowScalingFactor', <2>}]"`
- change powerbutton behavior in `/etc/systemd/logind.conf` like this:
    ```ini
    HandlePowerKey=suspend
    HandlePowerKeyLongPress=poweroff
    ```
    and reload the config `systemctl kill -s HUP systemd-logind`

## known issues
#### installation
- when pacman gives errors a reboot could solve the problems (just run the script again afterwards)

#### polybar
- it might be necessary to manually remove the file `~/.config/polybar/config` because it will not be overriden with stow and polybar will use it instaed of `config.ini` file

## usefull tips

#### mount ntfs
- mount ntfs file system on linux: `/dev/nvme1n1p2   /mnt/data   ntfs-3g   rw,uid=1000,gid=1000,umask=022,nofail,x-systemd.automount,x-systemd.device-timeout=10   0 0` in /etc/fstab
- or with with no permissions set `/dev/nvme1n1p2 /mnt/data ntfs-3g rw 0 0`

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

