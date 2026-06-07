# Tablet Setup Guide — Fujitsu Arrows Tab V727
# Arch Linux + i3 — touchscreen-primary

## 1. Install dependencies

```bash
# AUR helper (if not already installed)
sudo pacman -S --needed base-devel git
git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si

# Core packages
sudo pacman -S rofi dunst brightnessctl pamixer networkmanager alacritty \
               xorg-xinput xorg-xrandr i3lock iio-sensor-proxy

# AUR packages
yay -S wvkbd libinput-gestures xdotool i3-gaps

# Office suite (pick one)
sudo pacman -S libreoffice-fresh   # full suite ~400MB
# or: sudo pacman -S onlyoffice-bin  # more tablet-friendly UI (AUR)

# File manager
sudo pacman -S thunar
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
# Backup existing config
cp ~/.config/i3/config ~/.config/i3/config.bak

# Merge tablet config (or copy if starting fresh)
cat i3_config_tablet >> ~/.config/i3/config
```

## 4. Set up gestures

```bash
# Add your user to input group
sudo gpasswd -a $USER input
# Log out and back in for this to take effect

# Deploy gesture config
cp libinput-gestures.conf ~/.config/libinput-gestures.conf

# Enable autostart
libinput-gestures-setup autostart start
```

## 5. Enable auto-rotation

```bash
# Enable the sensor service
sudo systemctl enable --now iio-sensor-proxy

# Test it works
monitor-sensor   # tilt the tablet and watch output
```

## 6. Tap-to-click (persistent via X11 config)

```bash
sudo mkdir -p /etc/X11/xorg.conf.d
sudo tee /etc/X11/xorg.conf.d/40-libinput.conf << 'EOF'
Section "InputClass"
    Identifier "touchscreen"
    MatchIsTouchscreen "on"
    Driver "libinput"
    Option "Tapping" "on"
    Option "NaturalScrolling" "true"
    Option "DisableWhileTyping" "false"
EndSection
EOF
```

## 7. Reboot and test

```bash
reboot
# After login: press Super+Space to open the dashboard hub
```

## Gesture reference

| Gesture           | Action                    |
|-------------------|---------------------------|
| 3-finger up       | Dashboard hub             |
| 3-finger down     | Toggle keyboard           |
| 3-finger left     | Next workspace            |
| 3-finger right    | Previous workspace        |
| 4-finger up       | Quick controls            |
| 4-finger down     | Power menu                |
| 4-finger left     | Close window              |
| 4-finger right    | Fullscreen toggle         |

## Key bindings

| Shortcut          | Action                    |
|-------------------|---------------------------|
| Super+Space       | Dashboard hub             |
| Super+K           | Toggle on-screen keyboard |
| Super+Q           | Quick controls            |
| Super+P           | Power menu                |
| Super+F           | Fullscreen                |
| Super+Shift+Q     | Close window              |

## Troubleshooting

**Touch not working after rotation**: Check `xinput list` for the exact device name
and update the grep pattern in `quick_controls.sh` and `rotation_daemon.sh`.

**wvkbd not showing**: Run `wvkbd-mobintl --help` to confirm it installed,
then check `/tmp/wvkbd.pid` permissions.

**Gestures not firing**: Confirm `$USER` is in the `input` group:
`groups $USER` — should include `input`. Re-login required after adding.

**iio-sensor-proxy not detecting orientation**: Check `systemctl status iio-sensor-proxy`
and `monitor-sensor` output. Some Fujitsu tablets need the `industrialio` kernel module:
`sudo modprobe industrialio` then add to `/etc/modules-load.d/tablet.conf`.
