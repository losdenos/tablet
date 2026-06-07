#!/bin/bash
# dashboard_hub.sh — Main touch-friendly hub for Fujitsu Arrows Tab V727
# Requires: rofi, dunst
# Usage: bind to a swipe gesture or i3 keybind ($mod+d or touchscreen button)

# ── Rofi theme: large icons + big text for finger tapping ──────────────────
ROFI_THEME='
window {
    width: 680px;
    border-radius: 16px;
    padding: 12px;
}
listview {
    columns: 3;
    lines: 3;
    spacing: 8px;
}
element {
    border-radius: 12px;
    padding: 18px 12px;
    orientation: vertical;
    cursor: pointer;
}
element-icon {
    size: 52px;
    horizontal-align: 0.5;
}
element-text {
    horizontal-align: 0.5;
    margin: 8px 0 0 0;
    font: "Sans 13";
}
element selected {
    background-color: @selected-normal-background;
}
'

# ── App entries: "Icon\0display\x1fName" ───────────────────────────────────
ENTRIES=(
    " Firefox"
    " Files"
    " Terminal"
    " Document"
    " Calc"
    "󰽉 Draw"
    " Keyboard"
    " Quick Controls"
    "󰐥 Power"
)

# Build newline-separated list
LIST=$(printf '%s\n' "${ENTRIES[@]}")

# ── Show rofi ──────────────────────────────────────────────────────────────
CHOICE=$(echo "$LIST" | rofi \
    -dmenu \
    -i \
    -p "Open" \
    -theme-str "$ROFI_THEME" \
    -theme-str 'element-text { font: "Sans 13"; }' \
    -font "Sans 14" \
    -lines 9 \
    -width 680)

# ── Dispatch ───────────────────────────────────────────────────────────────
case "$CHOICE" in
    " Firefox")          firefox & ;;
    " Files")            thunar & ;;
    " Terminal")         alacritty & ;;
    " Document")         soffice --writer & ;;
    " Calc")             soffice --calc & ;;
    "󰽉 Draw")            soffice --draw & ;;
    " Keyboard")         ~/.config/tablet/osk_toggle.sh ;;
    " Quick Controls")   ~/.config/tablet/quick_controls.sh ;;
    "󰐥 Power")           ~/.config/tablet/power_menu.sh ;;
esac
