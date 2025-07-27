# autosetup script for cachyos

## guide

### cachyos
#### installation
- use the graphical installer and chose i3-wm as a window manager

#### display settings
- use nvidia-settings (run as root: `sudo nvidia-settings &` to save the configuration to x config)

#### secure boot
- if secure boot does not work disable it temporarly and then follow the tutorial on the [official site](https://wiki.cachyos.org/configuration/secure_boot_setup/)
- enable setup mode might look different in some uefis, it might be also called clear keys

### autosetup
- install dotfiles (instructions in repo)
- install required tools for dotfiles: `./dotfiles-dependencies.sh`
- install optional tools: `./typical-apps.sh`
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

### known issues
- when pacman gives errors a reboot could solve the problems (just run the script again afterwards)
