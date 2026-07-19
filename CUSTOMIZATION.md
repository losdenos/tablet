# Customization Guide

Adapting this tablet rice for different hardware, resolutions, and preferences.

---

## Adapting for a different tablet

### 1. Touchscreen device name

Every tablet reports its touchscreen under a different name. Find yours:
```bash
xinput list --name-only | grep -iE "touch|wacom|digitizer|elan"
```
Update two files with the correct name:

**`~/.config/tablet/rotation_daemon.sh`** — change the `grep -iE "touch|wacom|digitizer"` pattern or hardcode the device name:
```bash
TOUCH_DEVICE="Your Device Name Here"
```

**`~/.config/tablet/quick_controls.sh`** — same grep pattern for manual rotation entries.

### 2. Resolution and DPI

This setup targets **1920×1280** (3:2 ratio on 12.5" — ~184 DPI).

#### i3 gaps and bar height
In `i3_config_tablet`:
```
gaps inner 10
gaps outer 6
```
For higher-DPI screens, use larger gaps. For lower-DPI, smaller.  

Bar height:
```
height 40
```
Increase for touch (bigger tap targets), decrease for more screen space.

#### Alacritty font size
In `alacritty.toml`:
```toml
size = 14.0
```
Adjust up/down based on your resolution and eyesight.

#### Rofi theme sizing
In `cyberpunk.rasi`, touch-friendly padding means larger elements:
```css
element {
    padding: 20px 14px;
}
```
For smaller screens, reduce padding and the window width (`width: 860px`).

#### GTK cursor size
In `gtk-settings.ini`:
```
gtk-cursor-theme-size=32
```
32px is comfortable for touch. 24px is fine for mouse use.

### 3. On-screen keyboard layout

The OSK (`osk_toggle.sh`) launches `onboard` at 1280×320. For a different resolution:
```bash
onboard --size WxH --layout Compact --theme "Nightshade"
```
- **Width** should be roughly your screen width
- **Height** is up to you — 300–400px works well for a 12" screen

Available themes: `"Nightshade"`, `"Default"`, `"Low contrast"`, `"High contrast"`  
Available layouts: `"Compact"`, `"Full"`, `"Phone"`, `"Stroke"`

### 4. Wallpaper

The Python-generated wallpaper (`wallpaper_gen.sh`) is built for 1920×1280. Change the dimensions at the top:
```python
W, H = 1920, 1280  # Replace with your resolution
```

The script generates a dark cyan grid with magenta accent lines. To tweak:
- `#03060f` — background colour
- `#00ffff` — grid cyan
- `#ff00ff` — magenta accent
- `opacity` values — grid prominence

Run after editing:
```bash
bash ~/.config/wallpaper_gen.sh
```

---

## Changing the colour scheme

### i3 (Catppuccin Mocha → anything)

At the bottom of `i3_config_tablet`:
```
set $crust   #11111b
set $base    #1e1e2e
set $surface #313244
...
client.focused           $blue     $base     $text    $cyan      $blue
```
Swap the hex values for your palette. The `client.*` lines control borders and backgrounds.

### Alacritty

In `alacritty.toml`, replace the `[colors.*]` sections. [Catppuccin ports](https://github.com/catppuccin/catppuccin) exist for almost every terminal.

### Rofi

The `cyberpunk.rasi` theme uses a dark grid aesthetic. Variables at the top:
```css
* {
    bg:             #03060f;
    accent:         #00ffff;
    text:           #cceeff;
}
```
Change these for a different look. The theme is touch-optimised with 3-column, 3-row layout and 12px border radius.

### Dunst

In `dunstrc`, the accent colour:
```
frame_color = "#89b4fa"
```
Change to match your palette. Also `separator_color = frame` ties the separator to the frame.

---

## Adding custom keybinds

Edit `~/.config/i3/config` and add binds under the keybinds section:
```
bindsym $mod+e exec thunar          # Opens file manager
bindsym $mod+b exec firefox         # Opens browser
```

For multi-purpose binds, i3's `mode` is useful — see the built-in `mode "resize"` for an example.

---

## Adding more gesture bindings

Edit `~/.config/touchegg/touchegg.conf` (the XML config). Each gesture block looks like:
```xml
<gesture type="SWIPE" fingers="3" direction="UP">
    <action type="RUN_COMMAND">
        <command>~/.config/tablet/dashboard_hub.sh</command>
    </action>
</gesture>
```

**Available action types:**
- `RUN_COMMAND` — execute a shell command
- `SEND_KEYS` — simulate keyboard shortcut (uses `<modifiers>` + `<keys>`)
- `MOUSE_CLICK`, `SCROLL`, `MAXIMIZE_RESTORE`

**Gesture types:** `SWIPE`, `PINCH`, `TAP`

Available directions: `UP`, `DOWN`, `LEFT`, `RIGHT`

---

## Using a different bar

If you prefer **polybar** over i3status:

1. Replace `status_command i3status ...` with:
   ```
   status_command polybar tablet &
   ```
2. Remove the `colors` block from the i3 bar section (polybar handles its own theming)
3. Comment out the i3status config deployment in `install.sh`

---

## Disabling compositor (picom)

For battery savings or if picom causes issues:
```bash
pkill picom
```
To stop it on restart, comment out in `i3_config_tablet`:
```
# exec --no-startup-id picom --config ~/.config/picom/picom.conf -b
```

---

## Using Wayland instead of X11

This setup is **X11-only** — the rotation daemon, touchegg, and xinput calls won't work on Wayland. If you're on Wayland, look into:
- `wlr-randr` instead of `xrandr`
- `libinput` gesture support in the compositor (e.g. Sway has built-in gestures)
- Sway's `seat` config for touch input

This repo may still serve as inspiration, but the configs aren't directly portable.

---

## Removing the rice (clean revert)

```bash
# Restore i3 config
mv ~/.config/i3/config.bak ~/.config/i3/config

# Remove tablet scripts
rm -rf ~/.config/tablet/

# Disable services
sudo systemctl disable --now touchegg
sudo systemctl disable --now iio-sensor-proxy

# Remove config directories
rm -rf ~/.config/rofi/cyberpunk.rasi
rm -rf ~/.config/picom/
rm -rf ~/.config/touchegg/
rm -rf ~/.config/wallpaper.png
rm -rf ~/.config/wallpaper_gen.sh

# Remove X11 tap-to-click config
sudo rm /etc/X11/xorg.conf.d/40-libinput.conf

# Remove kernel module (optional)
sudo rm /etc/modules-load.d/tablet.conf
```

---

## Contributing

PRs and ideas are welcome! If you've adapted this for a different tablet, consider updating this guide with your device name and any quirks.
