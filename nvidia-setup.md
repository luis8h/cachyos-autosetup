# The Ultimate Guide: Sway Window Manager on NVIDIA (CachyOS / Limine)

This guide resolves the "silent crash" where Sway immediately kicks you back to the login screen and configures the system for optimal Wayland performance using modern NVIDIA drivers (555+).

---

## Phase 1: Escaping the "Silent Crash"
By default, Sway refuses to launch on proprietary NVIDIA drivers. You must explicitly tell it to ignore this restriction.

**To test if this is your issue:**
Drop into a TTY shell (e.g., Ctrl+Alt+F3) and run:
`sway --unsupported-gpu`

**The Permanent Fix:**
1. Edit the Sway session file:
   `sudo vim /usr/share/wayland-sessions/sway.desktop`
2. Locate the `Exec=` line and append the flag:
   `Exec=sway --unsupported-gpu`
3. Save and exit and reboot. Your login screen (display manager) will now pass this flag automatically.

---

## Phase 2: Kernel Parameters (Enabling Modesetting)
Wayland requires Kernel Mode Setting (KMS) to communicate with the GPU. On CachyOS using the **Limine** bootloader, you must add the parameter to your kernel command line.

1. Open your Limine configuration file:
   `sudo vim /boot/limine.conf`
2. Find your default boot entry (usually under `//linux-cachyos`).
3. Locate the `cmdline:` string for that entry.
4. Add `nvidia-drm.modeset=1` to the end of that line.
   **Example:**
   `cmdline: quiet nowatchdog splash rw rootflags=subvol=/@ root=UUID=... nvidia-drm.modeset=1`
5. Save and exit. (Limine reads this at boot, so no "update" command is required).

> **Note:** If a CachyOS update overwrites this file via `limine-entry-tool`, you may need to re-add this parameter.

---

## Phase 3: Environment Variables (The "Glue")
To ensure Sway and your apps route graphics through the NVIDIA GPU correctly, you need to set global environment variables.

1. Open the environment file:
   `sudo vim /etc/environment`
2. Paste the following configuration at the bottom:
   ```bash
   # NVIDIA Wayland Support
   GBM_BACKEND=nvidia-drm
   __GLX_VENDOR_LIBRARY_NAME=nvidia
   LIBVA_DRIVER_NAME=nvidia

   # Fixes flickering in Electron/Chromium apps
   ELECTRON_OZONE_PLATFORM_HINT=auto
   ```
3. Save and exit.

> **Note on Driver 555+:** Since you are on modern drivers, do **NOT** use `WLR_NO_HARDWARE_CURSORS=1`. Leaving it out allows for lower-latency "Explicit Sync" cursor rendering.

---

## Phase 4: Reboot and Verify
Reboot your system to apply the kernel parameters and environment variables. Once logged back into Sway, run:
`nvidia-smi`

**How to verify success:**
In the `Processes` list at the bottom, you should see:
* `sway`
* `Xwayland`
* `firefox` (or your browser)
* `ghostty` (or your terminal)

If these are present, you are officially hardware-accelerated.
