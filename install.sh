#!/bin/bash
# install.sh — Full tablet setup for Fujitsu Arrows Tab V727
# Arch Linux + i3 — 1920x1280
# Run from the directory containing all the config files:
# bash install.sh

set -e

# ── Colors for output ─────────────────────────────────────────────
C_CYAN='\033[0;36m'
C_GREEN='\033[0;32m'
C_YELLOW='\033[1;33m'
C_RED='\033[0;31m'
C_RESET='\033[0m'

info()    { echo -e "${C_CYAN}  →${C_RESET} $1"; }
success() { echo -e "${C_GREEN}  ✓${C_RESET} $1"; }
warn()    { echo -e "${C_YELLOW}  !${C_RESET} $1"; }
error()   { echo -e "${C_RED}  ✗${C_RESET} $1"; exit 1; }
header()  { echo -e "\n${C_CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${C_RESET}"; echo -e "${C_CYAN}  $1${C_RESET}"; echo -e "${C_CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${C_RESET}"; }

# ── Sanity checks ─────────────────────────────────────────────────
header "Pre-flight checks"

[ "$EUID" -eq 0 ] && error "Don't run as root. Run as your normal user."

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REQUIRED_FILES=(
    dashboard_hub.sh osk_toggle.sh quick_controls.sh
    power_menu.sh rotation_daemon.sh i3_config_tablet
    i3status.conf cyberpunk.rasi picom.conf
    alacritty.toml dunstrc gtk-settings.ini
    wallpaper_gen.sh touchegg_config.xml
)
for f in "${REQUIRED_FILES[@]}"; do
    [ -f "$SCRIPT_DIR/$f" ] || error "Missing file: $f — run from the correct directory"
done
success "All config files found"

# Check pacman
command -v pacman &>/dev/null || error "Not an Arch Linux system"
success "Arch Linux detected"

# ── AUR helper ────────────────────────────────────────────────────
header "AUR helper"

AUR_CMD=""
if command -v yay &>/dev/null; then
    AUR_CMD="yay"
    success "yay found"
elif command -v paru &>/dev/null; then
    AUR_CMD="paru"
    success "paru found"
else
    warn "No AUR helper found — installing yay"
    sudo pacman -S --needed --noconfirm base-devel git
    git clone https://aur.archlinux.org/yay.git /tmp/yay-install
    (cd /tmp/yay-install && makepkg -si --noconfirm)
    rm -rf /tmp/yay-install
    AUR_CMD="yay"
    success "yay installed"
fi

# ── Pacman packages ───────────────────────────────────────────────
header "Installing packages"

PACMAN_PKGS=(
    picom
    feh
    ttf-nerd-fonts-symbols
    papirus-icon-theme
    ttf-jetbrains-mono
    alacritty
    dunst
    rofi
    onboard
    thunar
    libreoffice-fresh
    brightnessctl
    pamixer
    networkmanager
    xorg-xinput
    xorg-xrandr
    i3lock
    iio-sensor-proxy
    imagemagick
    python3
    i3status
)

info "Running pacman (may ask for sudo password)..."
sudo pacman -S --needed --noconfirm "${PACMAN_PKGS[@]}"
success "Pacman packages installed"

# ── AUR packages ──────────────────────────────────────────────────
header "Installing AUR packages"

AUR_PKGS=(touchegg xdotool)
info "Running $AUR_CMD..."
$AUR_CMD -S --needed --noconfirm "${AUR_PKGS[@]}"
success "AUR packages installed"

# ── Create directories ────────────────────────────────────────────
header "Creating config directories"

DIRS=(
    ~/.config/tablet
    ~/.config/rofi
    ~/.config/picom
    ~/.config/alacritty
    ~/.config/dunst
    ~/.config/gtk-3.0
    ~/.config/touchegg
    ~/.config/i3
)
for d in "${DIRS[@]}"; do
    mkdir -p "$d"
    info "Created $d"
done
success "Directories ready"

# ── Deploy scripts ────────────────────────────────────────────────
header "Deploying scripts"

SCRIPTS=(dashboard_hub.sh osk_toggle.sh quick_controls.sh power_menu.sh rotation_daemon.sh)
for s in "${SCRIPTS[@]}"; do
    cp "$SCRIPT_DIR/$s" ~/.config/tablet/
    chmod +x ~/.config/tablet/"$s"
    info "Installed $s"
done
success "Scripts deployed and made executable"

# ── Deploy configs ────────────────────────────────────────────────
header "Deploying configs"

# Backup existing i3 config if present
if [ -f ~/.config/i3/config ]; then
    cp ~/.config/i3/config ~/.config/i3/config.bak
    warn "Existing i3 config backed up to ~/.config/i3/config.bak"
fi

cp "$SCRIPT_DIR/i3_config_tablet"   ~/.config/i3/config
cp "$SCRIPT_DIR/i3status.conf"      ~/.config/i3/i3status.conf
cp "$SCRIPT_DIR/cyberpunk.rasi"     ~/.config/rofi/cyberpunk.rasi
cp "$SCRIPT_DIR/picom.conf"         ~/.config/picom/picom.conf
cp "$SCRIPT_DIR/alacritty.toml"     ~/.config/alacritty/alacritty.toml
cp "$SCRIPT_DIR/dunstrc"            ~/.config/dunst/dunstrc
cp "$SCRIPT_DIR/gtk-settings.ini"   ~/.config/gtk-3.0/settings.ini
cp "$SCRIPT_DIR/touchegg_config.xml" ~/.config/touchegg/touchegg.conf

success "All configs deployed"

# ── Generate wallpaper ────────────────────────────────────────────
header "Generating wallpaper"

cp "$SCRIPT_DIR/wallpaper_gen.sh" ~/.config/wallpaper_gen.sh
chmod +x ~/.config/wallpaper_gen.sh
bash ~/.config/wallpaper_gen.sh
success "Wallpaper generated at ~/.config/wallpaper.png"

# ── Tap-to-click ──────────────────────────────────────────────────
header "Configuring tap-to-click"

sudo mkdir -p /etc/X11/xorg.conf.d
sudo tee /etc/X11/xorg.conf.d/40-libinput.conf > /dev/null << 'XEOF'
Section "InputClass"
    Identifier "touchscreen"
    MatchIsTouchscreen "on"
    Driver "libinput"
    Option "Tapping" "on"
    Option "NaturalScrolling" "true"
    Option "DisableWhileTyping" "false"
EndSection
XEOF
success "Tap-to-click configured"

# ── Enable services ───────────────────────────────────────────────
header "Enabling services"

sudo systemctl enable --now touchegg
success "touchegg service enabled"

sudo systemctl enable --now iio-sensor-proxy
success "iio-sensor-proxy service enabled"

# ── Add user to input group (for touchegg gestures) ───────────────
header "User group"

if ! groups "$USER" | grep -q '\binput\b'; then
    sudo gpasswd -a "$USER" input
    warn "Added $USER to input group — takes effect after reboot"
else
    success "$USER already in input group"
fi

# ── Done ──────────────────────────────────────────────────────────
header "All done!"

echo ""
echo -e "${C_GREEN}  Everything installed and configured.${C_RESET}"
echo -e "${C_CYAN}  Reboot now to apply all changes:${C_RESET}"
echo ""
echo -e "    ${C_YELLOW}sudo reboot${C_RESET}"
echo ""
echo -e "  After reboot:"
echo -e "  ${C_CYAN}Super+Space${C_RESET}  → Dashboard hub"
echo -e "  ${C_CYAN}Super+K${C_RESET}      → On-screen keyboard"
echo -e "  ${C_CYAN}Super+Q${C_RESET}      → Quick controls"
echo -e "  ${C_CYAN}Super+P${C_RESET}      → Power menu"
echo -e "  ${C_CYAN}3-finger up${C_RESET}  → Dashboard hub"
echo -e "  ${C_CYAN}3-finger down${C_RESET}→ Keyboard toggle"
echo ""
