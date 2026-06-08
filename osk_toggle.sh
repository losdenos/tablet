#!/bin/bash
# osk_toggle.sh — Toggle on-screen keyboard (onboard)
# Requires: onboard
# Install:  sudo pacman -S onboard

PIDFILE="/tmp/onboard.pid"

if [ -f "$PIDFILE" ] && kill -0 "$(cat $PIDFILE)" 2>/dev/null; then
    kill "$(cat $PIDFILE)"
    rm -f "$PIDFILE"
else
    onboard \
        --size 1280x320 \
        --layout Compact \
        --theme "Nightshade" \
        &
    echo $! > "$PIDFILE"
fi
