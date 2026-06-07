#!/bin/bash
# power_menu.sh — Sleep, lock, reboot, shutdown
# Requires: rofi, i3lock (or swaylock), systemd

CHOICE=$(printf '󰒲  Suspend\n󰌾  Lock screen\n  Reboot\n󰐥  Shutdown' \
    | rofi \
        -dmenu \
        -p "Power" \
        -font "Sans 15" \
        -lines 4 \
        -width 320 \
        -theme-str 'window { border-radius: 14px; } element { padding: 14px 20px; border-radius: 8px; }')

case "$CHOICE" in
    *Suspend*)
        i3lock -c 000000 && systemctl suspend ;;
    *Lock*)
        i3lock -c 1e1e2e ;;
    *Reboot*)
        systemctl reboot ;;
    *Shutdown*)
        systemctl poweroff ;;
esac
