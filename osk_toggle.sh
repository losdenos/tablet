#!/bin/bash
# osk_toggle.sh — Toggle on-screen keyboard (wvkbd)
# Requires: wvkbd-mobintl  (AUR: wvkbd)
# Install:  yay -S wvkbd
 
PIDFILE="/tmp/wvkbd.pid"
 
if [ -f "$PIDFILE" ] && kill -0 "$(cat $PIDFILE)" 2>/dev/null; then
    # Already running — toggle visibility with SIGRTMIN
    kill -SIGRTMIN "$(cat $PIDFILE)"
else
    # Not running — launch it
    # -L: keyboard height in pixels (landscape)
    # --fn: font name and size (no quotes around the whole value)
    # color values are plain rrggbb hex, no # prefix
    wvkbd-mobintl \
        -L 280 \
        --fn "Sans 18" \
        --bg 1e1e2e \
        --fg cdd6f4 \
        --fg-sp 89b4fa \
        --press 89b4fa \
        --text 1e1e2e \
        --text-sp 1e1e2e &
    echo $! > "$PIDFILE"
fi
 
