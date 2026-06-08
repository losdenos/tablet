#!/bin/bash
# dashboard_hub.sh — Touch-friendly hub for 1920x1280 tablet
# Requires: rofi, ~/.config/rofi/cyberpunk.rasi

ENTRIES=(
    " Firefox"
    " Files"
    " Terminal"
    " Write"
    " Calc"
    "󰽉 Draw"
    " Keyboard"
    " Controls"
    "󰐥 Power"
)

LIST=$(printf '%s\n' "${ENTRIES[@]}")

CHOICE=$(echo "$LIST" | rofi \
    -dmenu \
    -i \
    -p "  Open" \
    -theme ~/.config/rofi/cyberpunk.rasi)

case "$CHOICE" in
    " Firefox")   firefox & ;;
    " Files")     thunar & ;;
    " Terminal")  alacritty & ;;
    " Write")     soffice --writer & ;;
    " Calc")      soffice --calc & ;;
    "󰽉 Draw")    soffice --draw & ;;
    " Keyboard")  ~/.config/tablet/osk_toggle.sh ;;
    " Controls")  ~/.config/tablet/quick_controls.sh ;;
    "󰐥 Power")   ~/.config/tablet/power_menu.sh ;;
esac
