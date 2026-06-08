#!/bin/bash
# rotation_daemon.sh — Auto-rotate screen + touchscreen using iio-sensor-proxy
# Requires: iio-sensor-proxy, xrandr, xinput
# Enable service: systemctl enable --now iio-sensor-proxy
# Run at i3 startup: exec --no-startup-id ~/.config/tablet/rotation_daemon.sh

# Find the touchscreen device name (adjust grep pattern if needed)
TOUCH_DEVICE=$(xinput list --name-only | grep -iE "touch|wacom|digitizer" | head -1)

log() { echo "[rotation] $*" >> /tmp/rotation_daemon.log; }
log "Starting. Touchscreen: '${TOUCH_DEVICE}'"

# Map orientation → xrandr flag and touch matrix
declare -A XRANDR=( [normal]="normal" [bottom-up]="inverted" [left-up]="right" [right-up]="left" )
declare -A MATRIX=(
    [normal]="1 0 0 0 1 0 0 0 1"
    [bottom-up]="-1 0 1 0 -1 1 0 0 1"
    [right-up]="0 1 0 -1 0 1 0 0 1"
    [left-up]="0 -1 1 1 0 0 0 0 1"
)

LAST=""

monitor_iio() {
    # Use monitor-sensor to stream orientation events
    monitor-sensor 2>&1 | while read -r line; do
        if [[ "$line" =~ "Accelerometer orientation changed:" ]]; then
            ORI=$(echo "$line" | grep -oE '(normal|bottom-up|left-up|right-up)')
            [ -z "$ORI" ] && continue
            [ "$ORI" = "$LAST" ] && continue
            LAST="$ORI"

            XFLAG="${XRANDR[$ORI]}"
            MAT="${MATRIX[$ORI]}"

            log "Rotating to $ORI (xrandr: $XFLAG)"
            xrandr -o "$XFLAG"

            if [ -n "$TOUCH_DEVICE" ]; then
                xinput set-prop "$TOUCH_DEVICE" "Coordinate Transformation Matrix" $MAT
            fi
        fi
    done
}

# Restart monitor-sensor loop if it dies
while true; do
    monitor_iio
    log "monitor-sensor exited, restarting in 3s..."
    sleep 3
done
