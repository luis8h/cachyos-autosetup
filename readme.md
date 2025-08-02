# autosetup script for cachyos

## getting started

### cachyos
#### installation
- use the graphical installer and chose i3-wm as a window manager

#### display settings
- use nvidia-settings (run as root: `sudo nvidia-settings &` to save the configuration to x config)
- when nvidia-settings are not available just run the install and then use lxqt-config (or use xrandr already before installing)

#### secure boot
- if secure boot does not work disable it temporarly and then follow the tutorial on the [official site](https://wiki.cachyos.org/configuration/secure_boot_setup/)
- enable setup mode might look different in some uefis, it might be also called clear keys

### autosetup
- download and install dotfiles from [here](https://github.com/luis8h/dotfiles)
- install dotfiles (instructions in repo)
- install required tools for dotfiles: `./dotfiles-dependencies.sh`
- install optional tools: `./typical-apps.sh`
- reboot

#### laptop
- setup kanata `./setup-kanata.sh`
- reboot

### post setup
#### tmux
- start a tmux session, and navigate to the `tmux.conf` file in nvim
- press <tmux-prefix> and then shift+i to install the plugins
- if some plugins do not work afterwards try restarting tmux, deleting the plugins from `.config/tmux/plugins` and install them again

#### auto download cleaning
- acces cron config: `crontab -e`
- add the following line `@reboot ~/.scripts/clean-downloads.sh`

#### fix suspend waking up
- list all devices which are enabled to wake up: `cat /proc/acpi/wakeup | grep enabled`
- manually toggl enabled/disabled: `sudo sh -c “echo PEG0 > /proc/acpi/wakeup”`
- to make this persistant just sopy the script like this: `sudo cp disable-some-wake /usr/lib/systemd/system-sleep`
- this script can be adjusted with the devices which should be disabled

#### downloads autocleaning script
- cleans the downloads directory in every reboot (moves all files to a `trash` subdirectory)
- `crontab -e` to access cron config file
- append the following line: `@reboot ~/.scripts/clean-downloads.sh`

#### syncthing setup
- copy docker-compose file into a directory `mkdir -p ~/docker-syncthing && cp ./docker-compose.yml ~/docker-syncthing/` and configure volumes in it
- **important:** create the synced directory first on the host pc, otherwise it will be created by docker and have root:root as owner (if it is too late you can chown the directory afterwards to make it work)
- go to the directory and run `docker-compose up -d`
- configure the sync directories in the webinterface (in advanced sync folder settings set ignore permissions to avoid issues)

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

## usefull tips

#### general
- mount ntfs file system on linux: `/dev/nvme1n1p2   /mnt/data   ntfs-3g   rw,uid=1000,gid=1000,umask=022   0 0` in /etc/fstab
- or with with no permissions set `/dev/nvme1n1p2 /mnt/data ntfs-3g rw 0 0`


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

