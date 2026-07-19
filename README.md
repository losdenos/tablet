# Tablet Rice — Fujitsu Arrows Tab V727

**Arch Linux + i3, touchscreen-first.**

A complete tablet desktop environment for the Fujitsu Arrows Tab V727 (1920×1280). Turn a laptop-convertible into a gesture-driven, touch-friendly Linux workstation with rounded corners, a cyberpunk grid wallpaper, dark Catppuccin theme, and an on-screen keyboard that actually works.

---

## What's inside

| Where | What |
|---|---|
| `install.sh` | **One-shot installer** — detects Arch, installs packages, deploys all configs, enables services. Run and reboot. |
| `i3_config_tablet` | i3 config built for touch — big gaps, floating OSK rules, 40px bar, full Catppuccin colour scheme |
| `rotation_daemon.sh` | Auto-rotate daemon using `iio-sensor-proxy` + `xrandr` + `xinput` coordinate transform |
| `dashboard_hub.sh` | Touch-friendly launcher (rofi grid: Firefox, Files, Terminal, LibreOffice, Quick Controls, Power) |
| `quick_controls.sh` | Brightness, volume, wifi toggle, and manual rotation in one rofi menu |
| `power_menu.sh` | Suspend / Lock / Reboot / Shutdown |
| `osk_toggle.sh` | Toggle onboard (virtual keyboard) — Super+K or 3-finger down |
| `wallpaper_gen.sh` | Python + ImageMagick — generates a dark cyan/magenta grid wallpaper at 1920×1280 |
| `touchegg_config.xml` | Touchégg gestures — 3/4-finger swipes, 2-finger tap for right-click |
| `cyberpunk.rasi` | Rofi theme — dark, cyan accents, 860px grid layout, touch-friendly padding |
| `picom.conf` | Compositor — rounded corners (10px), subtle shadows, slight inactive opacity |
| `alacritty.toml` | Terminal — JetBrains Mono, Catppuccin Mocha palette, 0.92 opacity |
| `dunstrc` | Notifications — top-right, 10px radius, blue frame, Papirus-Dark icons |
| `gtk-settings.ini` | GTK3 — Adwaita-dark theme, Papirus-Dark icons, 32px cursor for touch |
| `i3status.conf` | Status bar — wifi, battery, CPU, RAM, volume, disk, clock |

---

## Quick start

```bash
# Clone and run — that's it
git clone https://github.com/0x4E6FHost/tablet.git
cd tablet
bash install.sh
sudo reboot
```

The installer handles everything: dependencies, config deployment, services, touch input group, and the X11 tap-to-click rule.

> **Prefer a step-by-step?** See [`SETUP.md`](./SETUP.md) for the manual visual setup guide.

---

## Gesture reference

| Gesture | Action |
|---|---|
| 3-finger ↑ | Dashboard hub |
| 3-finger ↓ | Toggle on-screen keyboard |
| 3-finger ← | Next workspace |
| 3-finger → | Previous workspace |
| 4-finger ↑ | Quick controls |
| 4-finger ↓ | Power menu |
| 4-finger ← | Close window |
| 4-finger → | Fullscreen toggle |
| 2-finger tap | Right-click |

## Keybind reference

| Shortcut | Action |
|---|---|
| Super+Space | Dashboard hub |
| Super+K | On-screen keyboard |
| Super+Q | Quick controls |
| Super+P | Power menu |
| Super+Return | Terminal (Alacritty) |
| Super+F | Fullscreen |
| Super+Shift+Q | Close window |
| Super+Shift+R | Restart i3 |
| Super+Shift+Space | Toggle floating |

---

## Docs

- **[SETUP.md](./SETUP.md)** — Manual walkthrough with package list, config-by-config deployment, and what the final desktop looks like
- **[TROUBLESHOOTING.md](./TROUBLESHOOTING.md)** — Touchégg, auto-rotation, device name issues, and common pitfalls
- **[CUSTOMIZATION.md](./CUSTOMIZATION.md)** — Adapting for different tablets, resolutions, themes, and hardware

---

## Target hardware

This setup was built and tested on:

**Fujitsu Arrows Tab V727** (also known as Fujitsu Stylistic V727 / Lifebook V727)
- 1920×1280 touchscreen (3:2 ratio)
- Intel Core i5-7Y54 / i7-7Y75
- 8–16 GB RAM
- Built-in accelerometer (iio-sensor-proxy compatible)

It should work on any Linux tablet or 2-in-1 with similar hardware. See [`CUSTOMIZATION.md`](./CUSTOMIZATION.md) for adapting.

---

## Requirements

- **Arch Linux** (install script uses `pacman` + `yay`)
- **i3** window manager (the config is i3-specific)
- **X11** (Wayland not tested)
