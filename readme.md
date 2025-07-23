# autosetup script for cachyos

## guide

### cachyos
#### installation
- use the graphical installer and chose i3-wm as a window manager

#### secure boot
- if secure boot does not work disable it temporarly and then follow the tutorial on the [official site](https://wiki.cachyos.org/configuration/secure_boot_setup/)
- enable setup mode might look different in some uefis, it might be also called clear keys

### autosetup
- run `./dotfiles-dependencies.sh`

### post setup
#### auto download cleaning
- acces cron config: `crontab -e`
- add the following line `@reboot ~/.scripts/clean-downloads.sh`

#### display settings
- use nvidia-settings (run as root: `sudo nvidia-settings &` to save the configuration to x config)

#### fix suspend waking up
- list all devices which are enabled to wake up: `cat /proc/acpi/wakeup | grep enabled`
- manually toggl enabled/disabled: `sudo sh -c “echo PEG0 > /proc/acpi/wakeup”`
- to make this persistant just sopy the script like this: `sudo cp disable-some-wake /usr/lib/systemd/system-sleep`
- this script can be adjusted with the devices which should be disabled
