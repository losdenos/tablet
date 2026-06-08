# Tablet Visual Setup — Fujitsu Arrows Tab V727
# Arch Linux + i3 — 1920x1280

## 1. Install packages

```bash
sudo pacman -S picom feh ttf-nerd-fonts-symbols \
               papirus-icon-theme ttf-jetbrains-mono \
               alacritty dunst rofi onboard thunar \
               libreoffice-fresh brightnessctl pamixer \
               networkmanager xorg-xinput i3lock \
               iio-sensor-proxy imagemagick

yay -S touchegg
```

## 2. Deploy configs

```bash
# Scripts
mkdir -p ~/.config/tablet
cp dashboard_hub.sh quick_controls.sh osk_toggle.sh \
   power_menu.sh rotation_daemon.sh ~/.config/tablet/
chmod +x ~/.config/tablet/*.sh

# Rofi theme
mkdir -p ~/.config/rofi
cp cyberpunk.rasi ~/.config/rofi/

# Picom
mkdir -p ~/.config/picom
cp picom.conf ~/.config/picom/

# i3
cp i3_config_tablet ~/.config/i3/config
mkdir -p ~/.config/i3
cp i3status.conf ~/.config/i3/

# Alacritty
mkdir -p ~/.config/alacritty
cp alacritty.toml ~/.config/alacritty/

# Dunst
mkdir -p ~/.config/dunst
cp dunstrc ~/.config/dunst/

# GTK dark theme
mkdir -p ~/.config/gtk-3.0
cp gtk-settings.ini ~/.config/gtk-3.0/settings.ini

# Touchegg gestures
mkdir -p ~/.config/touchegg
cp touchegg_config.xml ~/.config/touchegg/touchegg.conf

# Generate wallpaper
bash wallpaper_gen.sh
```

## 3. Enable services

```bash
sudo systemctl enable --now touchegg
sudo systemctl enable --now iio-sensor-proxy
```

## 4. Tap-to-click (persistent)

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

## 5. Reboot

```bash
reboot
```

## What you'll see after reboot

- Cyberpunk grid wallpaper (1920x1280)
- Clean dark i3 bar with icons: wifi, battery, CPU, RAM, volume, disk, clock
- Rounded window corners + subtle shadows (picom)
- Slight transparency on inactive windows
- Dark notifications (dunst) top-right
- Dark terminal (alacritty) with Catppuccin colors
- All apps use Papirus-Dark icons + Adwaita-dark GTK theme

## Gesture reference

| Gesture        | Action              |
|----------------|---------------------|
| 3-finger up    | Dashboard hub       |
| 3-finger down  | Toggle keyboard     |
| 3-finger left  | Next workspace      |
| 3-finger right | Previous workspace  |
| 4-finger up    | Quick controls      |
| 4-finger down  | Power menu          |
| 4-finger left  | Close window        |
| 4-finger right | Fullscreen toggle   |
| 2-finger tap   | Right-click         |

## Keybind reference

| Shortcut      | Action              |
|---------------|---------------------|
| Super+Space   | Dashboard hub       |
| Super+K       | Toggle keyboard     |
| Super+Q       | Quick controls      |
| Super+P       | Power menu          |
| Super+Return  | Terminal            |
| Super+F       | Fullscreen          |
| Super+Shift+Q | Close window        |
| Super+Shift+R | Restart i3          |
