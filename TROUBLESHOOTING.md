# Troubleshooting

Common issues when setting up the tablet rice, and how to fix them.

---

## Touchégg gestures not working

Touchégg requires **two processes** — a system daemon (root) and a user client.

### Check daemon
```bash
systemctl status touchegg
```
Should show `active (running)`. If not:
```bash
sudo systemctl enable --now touchegg
```

### Check user client
```bash
ps aux | grep touchegg
```
You should see **two** lines (one `root` for the daemon, one for the user client).  
If the user client is missing, make sure your i3 config includes:
```
exec --no-startup-id touchegg
```
After adding it, restart i3: **Super+Shift+R**

### Check input group
The user needs to be in the `input` group for Touchégg to receive gesture events.
```bash
groups $USER
```
If `input` isn't listed:
```bash
sudo gpasswd -a $USER input
```
**Reboot required** for group changes to take effect.

### Still not working?
Try running touchegg directly in a terminal:
```bash
touchegg
```
You'll see log output that might reveal the problem (missing permissions, wrong config path, etc.).

---

## Auto-rotation not working

### Check the service
```bash
systemctl status iio-sensor-proxy
```
If not running:
```bash
sudo systemctl enable --now iio-sensor-proxy
```

### Test the sensor
```bash
monitor-sensor
```
Tilt the tablet — you should see orientation events like:
```
Accelerometer orientation changed: bottom-up
```
If nothing appears, your accelerometer might need a kernel module.

### Load industrialio (Fujitsu tablets)
Some Fujitsu models need this module:
```bash
sudo modprobe industrialio
```
To make it permanent:
```bash
echo "industrialio" | sudo tee /etc/modules-load.d/tablet.conf
```

### Check the rotation daemon is running
```bash
ps aux | grep rotation_daemon
```
It should be running as a background process (started by `exec --no-startup-id ~/.config/tablet/rotation_daemon.sh` in i3 config).

Check the daemon's log:
```bash
cat /tmp/rotation_daemon.log
```
The log shows detected orientation changes and what it tried to do.

---

## Touchscreen input doesn't rotate with the screen

The rotation daemon uses `xinput` to find the touchscreen device and apply a coordinate transformation matrix. If the device name doesn't match, rotation breaks.

### Find the correct device name
```bash
xinput list --name-only | grep -iE "touch|wacom|digitizer"
```
Common names on the Fujitsu V727: `"ELAN9038:00 04F3:2E24"` or `"Wacom HID 52E9 Finger"`.

### Update rotation_daemon.sh
If the grep pattern doesn't match your device, edit `~/.config/tablet/rotation_daemon.sh`:

```bash
# Change this line:
TOUCH_DEVICE=$(xinput list --name-only | grep -iE "touch|wacom|digitizer" | head -1)

# To something like:
TOUCH_DEVICE="ELAN9038:00 04F3:2E24"
```

### Same issue for quick_controls.sh
The same grep pattern is used in `quick_controls.sh` for manual rotation. Update it the same way.

---

## On-screen keyboard issues

### Onboard not installed
```bash
sudo pacman -S onboard
```

### Keyboard too small / wrong size
The toggle script launches onboard at 1280×320. Adjust in `~/.config/tablet/osk_toggle.sh`:
```bash
onboard --size 1280x320 --layout Compact --theme "Nightshade"
```
Change the `--size` values or try a different `--theme` like `"Nightshade"`, `"Default"`, or `"Low contrast"`.

### Keyboard appears behind windows
The i3 config has a rule for this:
```
for_window [class="Onboard"] floating enable, border none, sticky enable
```
If you changed the window class, update this rule.

---

## Install script errors

### "Don't run as root"
Run `install.sh` as your normal user, not with `sudo`. The script calls `sudo` internally when needed.

### "Missing file: X"
Make sure you're running `install.sh` from inside the cloned repo directory:
```bash
cd /path/to/tablet
bash install.sh
```

### "Not an Arch Linux system"
The script checks for `pacman`. If you're on Arch but the check fails, your `pacman` binary might be in a non-standard location. Verify:
```bash
command -v pacman
```

### "No AUR helper found"
If neither `yay` nor `paru` is installed, the script will install `yay` automatically. This requires `base-devel` and `git`.

---

## i3 config not taking effect

### Config deployed to wrong location
i3 looks for `~/.config/i3/config`. The install script copies `i3_config_tablet` there. Manually:
```bash
cp i3_config_tablet ~/.config/i3/config
```

### Restart i3 after changes
**Super+Shift+R** to restart i3, or **Super+Shift+C** to reload config.

### Backup your old config
```bash
cp ~/.config/i3/config ~/.config/i3/config.bak
```

---

## Wallpaper not showing

### Check feh is installed
```bash
which feh
```

### Check the wallpaper exists
```bash
ls -la ~/.config/wallpaper.png
```
If missing, regenerate:
```bash
bash ~/.config/wallpaper_gen.sh
```

### Check i3 exec line
In i3 config:
```
exec --no-startup-id feh --bg-fill ~/.config/wallpaper.png
```

---

## Screen brightness controls not working

### Check brightnessctl
```bash
brightnessctl set +10%
```
If this fails, you may need to add your user to the `video` group:
```bash
sudo gpasswd -a $USER video
```
Reboot after.

---

## No network indicator

The i3 config starts `nm-applet`. If it's not showing:
```bash
nm-applet --indicator &
```
It needs a system tray — i3bar has this built in. Check `tray_output primary` is in your bar config. If you're on a minimal installation, ensure `networkmanager` and `nm-applet` are installed:
```bash
sudo pacman -S network-manager-applet
```

---

## Still stuck?

Open an issue on the [GitHub repository](https://github.com/0x4E6FHost/tablet/issues) with:
- Your tablet model
- Output of `neofetch` or `fastfetch`
- What you tried
- Any error messages
