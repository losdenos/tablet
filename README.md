# Tablet Setup Guide — Fujitsu Arrows Tab V727
# Arch Linux + i3 — touchscreen-primary

## 1. Install dependencies

```bash
sudo pacman -S rofi dunst brightnessctl pamixer networkmanager \
               alacritty xorg-xinput xorg-xrandr i3lock \
               iio-sensor-proxy onboard thunar libreoffice-fresh

yay -S touchegg xdotool wmctrl
```

## 2. Deploy scripts

```bash
mkdir -p ~/.config/tablet

cp dashboard_hub.sh    ~/.config/tablet/
cp osk_toggle.sh       ~/.config/tablet/
cp quick_controls.sh   ~/.config/tablet/
cp power_menu.sh       ~/.config/tablet/
cp rotation_daemon.sh  ~/.config/tablet/

chmod +x ~/.config/tablet/*.sh
```

## 3. Configure i3

```bash
cp ~/.config/i3/config ~/.config/i3/config.bak
cat i3_config_tablet >> ~/.config/i3/config
```

## 4. Set up touchegg gestures

```bash
# Enable the system daemon
sudo systemctl enable --now touchegg

# Deploy gesture config
mkdir -p ~/.config/touchegg
cp touchegg_config.xml ~/.config/touchegg/touchegg.conf

# Add to i3 config if not already there:
# exec --no-startup-id touchegg
```

## 5. Enable auto-rotation

```bash
sudo systemctl enable --now iio-sensor-proxy
# Test: monitor-sensor (tilt tablet and watch output)
```

## 6. Tap-to-click (persistent)

```bash
sudo mkdir -p /etc/X11/xorg.conf.d
sudo tee /etc/X11/xorg.conf.d/40-libinput.conf << 'XEOF'
Section "InputClass"
    Identifier "touchscreen"
    MatchIsTouchscreen "on"
    Driver "libinput"
    Option "Tapping" "on"
    Option "NaturalScrolling" "true"
    Option "DisableWhileTyping" "false"
EndSection
XEOF
```

## 7. Reboot and test

```bash
reboot
# Super+Space → dashboard hub
# Super+K     → on-screen keyboard
# Super+Q     → quick controls
# Super+P     → power menu
```

## Gesture reference (touchegg)

| Gesture          | Action                |
|------------------|-----------------------|
| 3-finger up      | Dashboard hub         |
| 3-finger down    | Toggle keyboard       |
| 3-finger left    | Next workspace        |
| 3-finger right   | Previous workspace    |
| 4-finger up      | Quick controls        |
| 4-finger down    | Power menu            |
| 4-finger left    | Close window          |
| 4-finger right   | Fullscreen toggle     |
| 2-finger tap     | Right-click           |

## Keybind reference

| Shortcut       | Action                |
|----------------|-----------------------|
| Super+Space    | Dashboard hub         |
| Super+K        | On-screen keyboard    |
| Super+Q        | Quick controls        |
| Super+P        | Power menu            |
| Super+F        | Fullscreen            |
| Super+Shift+Q  | Close window          |

## Troubleshooting

**Touchegg gestures not working:**
Run `systemctl status touchegg` — the system daemon must be running.
Also check `ps aux | grep touchegg` — you need TWO processes (root daemon + user client).
The user client is started by `exec --no-startup-id touchegg` in i3 config.

**Auto-rotation not working:**
Check `systemctl status iio-sensor-proxy` and run `monitor-sensor`.
Some Fujitsu tablets need: `sudo modprobe industrialio`
Add to `/etc/modules-load.d/tablet.conf` to persist.

**Touchscreen device name:**
Run `xinput list` to find the exact name, then update the grep pattern
in quick_controls.sh and rotation_daemon.sh if rotation isn't working.
