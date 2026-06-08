#!/bin/bash
# desktop_start.sh — Launch cyberpunk desktop (wallpaper + eww)
# Run once at i3 startup via: exec --no-startup-id ~/.config/eww/desktop_start.sh

WALLPAPER="$HOME/.config/eww/wallpaper.png"

# Generate wallpaper if it doesn't exist
if [ ! -f "$WALLPAPER" ]; then
    bash "$HOME/.config/eww/wallpaper_gen.sh"
fi

feh --bg-fill "$WALLPAPER"

# Small delay to let i3 settle
sleep 1

# Kill any existing eww desktop instance
eww close desktop 2>/dev/null
eww kill 2>/dev/null
sleep 0.3

# Start eww daemon and open desktop window
eww daemon
sleep 0.5
eww open desktop
