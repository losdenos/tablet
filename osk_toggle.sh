#!/bin/bash
# osk_toggle.sh — Toggle on-screen keyboard (wvkbd)
# Requires: wvkbd-mobintl  (AUR: wvkbd)
# Install:  yay -S wvkbd

PIDFILE="/tmp/wvkbd.pid"

if [ -f "$PIDFILE" ] && kill -0 "$(cat $PIDFILE)" 2>/dev/null; then
    # Keyboard is running — kill it
    kill "$(cat $PIDFILE)"
    rm -f "$PIDFILE"
else
    # Launch keyboard — landscape layer with numbers row
    wvkbd-mobintl \
        --landscape \
        --fn "Sans 18" \
        --bg 1e1e2e \
        --fg cdd6f4 \
        --press 89b4fa \
        --press-fg 1e1e2e \
        -L 280 &
    echo $! > "$PIDFILE"
fi
