#!/bin/bash
# wallpaper_gen.sh — Generate cyberpunk grid wallpaper (1280x800)
# Requires: imagemagick
# Install:  sudo pacman -S imagemagick
# Output:   ~/.config/eww/wallpaper.png

OUT="$HOME/.config/eww/wallpaper.png"
W=1280
H=800

convert -size ${W}x${H} xc:"#03060f" \
  \
  `# Grid lines — cyan at low opacity` \
  -stroke "#00ffff22" -strokewidth 1 -fill none \
  $(python3 -c "
for x in range(0, 1281, 40):
    print(f'-draw \"line {x},0 {x},{800}\"')
for y in range(0, 801, 40):
    print(f'-draw \"line 0,{y} {1280},{y}\"')
" | tr '\n' ' ') \
  \
  `# Accent lines — brighter every 200px` \
  -stroke "#00ffff55" -strokewidth 1 \
  $(python3 -c "
for x in range(0, 1281, 200):
    print(f'-draw \"line {x},0 {x},{800}\"')
for y in range(0, 801, 200):
    print(f'-draw \"line 0,{y} {1280},{y}\"')
" | tr '\n' ' ') \
  \
  `# Corner bracket — top left` \
  -stroke "#00ffff88" -strokewidth 2 \
  -draw "line 20,20 80,20" \
  -draw "line 20,20 20,80" \
  `# Corner bracket — top right` \
  -draw "line 1200,20 1260,20" \
  -draw "line 1260,20 1260,80" \
  `# Corner bracket — bottom left` \
  -draw "line 20,780 80,780" \
  -draw "line 20,720 20,780" \
  `# Corner bracket — bottom right` \
  -draw "line 1200,780 1260,780" \
  -draw "line 1260,720 1260,780" \
  \
  `# Horizontal accent bar top` \
  -stroke "#00ffff33" -strokewidth 1 \
  -draw "line 0,36 1280,36" \
  `# Horizontal accent bar bottom` \
  -draw "line 0,764 1280,764" \
  \
  `# Magenta diagonal accents` \
  -stroke "#ff00ff18" -strokewidth 1 \
  -draw "line 0,800 400,0" \
  -draw "line 880,800 1280,0" \
  \
  "$OUT"

echo "Wallpaper written to $OUT"
feh --bg-fill "$OUT"
