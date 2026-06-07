#!/bin/bash
# quick_controls.sh — Brightness, volume, wifi toggle
# Requires: brightnessctl, pamixer, nmcli, dunst, rofi

notify() {
    dunstify -t 1500 -r 9999 "$1" "$2"
}

show_menu() {
    BRI=$(brightnessctl g)
    BRI_MAX=$(brightnessctl m)
    BRI_PCT=$(( BRI * 100 / BRI_MAX ))

    VOL=$(pamixer --get-volume)
    MUTED=$(pamixer --get-mute && echo "yes" || echo "no")

    WIFI_STATE=$(nmcli radio wifi)
    [ "$WIFI_STATE" = "enabled" ] && WIFI_ICON="󰤨 WiFi ON" || WIFI_ICON="󰤭 WiFi OFF"

    ENTRIES=(
        "󰃠  Brightness  ${BRI_PCT}%  [+10]"
        "󰃞  Brightness  ${BRI_PCT}%  [-10]"
        "󰕾  Volume  ${VOL}%  [+10]"
        "󰕿  Volume  ${VOL}%  [-10]"
        "󰖁  Mute toggle"
        "${WIFI_ICON}"
        "󰏓  Rotate: Normal"
        "󰏒  Rotate: Inverted"
        "󰏑  Rotate: Left"
        "󰏐  Rotate: Right"
    )

    LIST=$(printf '%s\n' "${ENTRIES[@]}")

    echo "$LIST" | rofi \
        -dmenu \
        -i \
        -p "Controls" \
        -font "Sans 14" \
        -lines 10 \
        -width 500 \
        -theme-str 'window { border-radius: 14px; } element { padding: 12px 16px; border-radius: 8px; }'
}

CHOICE=$(show_menu)

case "$CHOICE" in
    *"Brightness"*"+10"*)
        brightnessctl set +10%
        notify "Brightness" "$(( $(brightnessctl g) * 100 / $(brightnessctl m) ))%" ;;
    *"Brightness"*"-10"*)
        brightnessctl set 10%-
        notify "Brightness" "$(( $(brightnessctl g) * 100 / $(brightnessctl m) ))%" ;;
    *"Volume"*"+10"*)
        pamixer -i 10
        notify "Volume" "$(pamixer --get-volume)%" ;;
    *"Volume"*"-10"*)
        pamixer -d 10
        notify "Volume" "$(pamixer --get-volume)%" ;;
    *"Mute toggle"*)
        pamixer --toggle-mute
        pamixer --get-mute && notify "Audio" "Muted" || notify "Audio" "Unmuted" ;;
    *"WiFi ON"*)
        nmcli radio wifi off
        notify "WiFi" "Disabled" ;;
    *"WiFi OFF"*)
        nmcli radio wifi on
        notify "WiFi" "Enabled" ;;
    *"Rotate: Normal"*)
        xrandr -o normal
        xinput set-prop "$(xinput list --name-only | grep -i touch | head -1)" \
            "Coordinate Transformation Matrix" 1 0 0 0 1 0 0 0 1 ;;
    *"Rotate: Inverted"*)
        xrandr -o inverted
        xinput set-prop "$(xinput list --name-only | grep -i touch | head -1)" \
            "Coordinate Transformation Matrix" -1 0 1 0 -1 1 0 0 1 ;;
    *"Rotate: Left"*)
        xrandr -o left
        xinput set-prop "$(xinput list --name-only | grep -i touch | head -1)" \
            "Coordinate Transformation Matrix" 0 -1 1 1 0 0 0 0 1 ;;
    *"Rotate: Right"*)
        xrandr -o right
        xinput set-prop "$(xinput list --name-only | grep -i touch | head -1)" \
            "Coordinate Transformation Matrix" 0 1 0 -1 0 1 0 0 1 ;;
esac
