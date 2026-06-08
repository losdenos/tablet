#!/bin/bash
# wallpaper_gen.sh — Cyberpunk wallpaper for 1920x1280
# Requires: imagemagick, python3
# Run once: bash wallpaper_gen.sh

OUT="$HOME/.config/wallpaper.png"
SVG="/tmp/cyberpunk_wall.svg"

python3 << 'PYEOF'
W, H = 1920, 1280
l = []
l.append(f'<svg xmlns="http://www.w3.org/2000/svg" width="{W}" height="{H}">')
l.append(f'<rect width="{W}" height="{H}" fill="#03060f"/>')

# Minor grid every 40px
for x in range(0, W+1, 40):
    l.append(f'<line x1="{x}" y1="0" x2="{x}" y2="{H}" stroke="#00ffff" stroke-width="0.5" opacity="0.07"/>')
for y in range(0, H+1, 40):
    l.append(f'<line x1="0" y1="{y}" x2="{W}" y2="{y}" stroke="#00ffff" stroke-width="0.5" opacity="0.07"/>')

# Major grid every 200px
for x in range(0, W+1, 200):
    l.append(f'<line x1="{x}" y1="0" x2="{x}" y2="{H}" stroke="#00ffff" stroke-width="1" opacity="0.18"/>')
for y in range(0, H+1, 200):
    l.append(f'<line x1="0" y1="{y}" x2="{W}" y2="{y}" stroke="#00ffff" stroke-width="1" opacity="0.18"/>')

# Diagonal magenta accents
l.append(f'<line x1="0" y1="{H}" x2="500" y2="0" stroke="#ff00ff" stroke-width="1.5" opacity="0.08"/>')
l.append(f'<line x1="{W-500}" y1="{H}" x2="{W}" y2="0" stroke="#ff00ff" stroke-width="1.5" opacity="0.08"/>')

# Horizontal accent bars
l.append(f'<line x1="0" y1="42" x2="{W}" y2="42" stroke="#00ffff" stroke-width="1" opacity="0.25"/>')
l.append(f'<line x1="0" y1="{H-2}" x2="{W}" y2="{H-2}" stroke="#00ffff" stroke-width="1" opacity="0.25"/>')

# Subtle radial glow in center
l.append(f'<defs><radialGradient id="g" cx="50%" cy="50%" r="50%"><stop offset="0%" stop-color="#00ffff" stop-opacity="0.04"/><stop offset="100%" stop-color="#03060f" stop-opacity="0"/></radialGradient></defs>')
l.append(f'<rect width="{W}" height="{H}" fill="url(#g)"/>')

# Corner brackets
m, s, t = 24, 70, 2
c, o = "#00ffff", "0.6"
for (x1,y1,x2,y2) in [
    (m,m,m+s,m),(m,m,m,m+s),
    (W-m-s,m,W-m,m),(W-m,m,W-m,m+s),
    (m,H-m,m+s,H-m),(m,H-m-s,m,H-m),
    (W-m-s,H-m,W-m,H-m),(W-m,H-m-s,W-m,H-m),
]:
    l.append(f'<line x1="{x1}" y1="{y1}" x2="{x2}" y2="{y2}" stroke="{c}" stroke-width="{t}" opacity="{o}"/>')

l.append('</svg>')
with open('/tmp/cyberpunk_wall.svg','w') as f:
    f.write('\n'.join(l))
print("SVG done.")
PYEOF

magick -background "#03060f" "$SVG" "$OUT"
echo "Wallpaper saved to $OUT"
feh --bg-fill "$OUT"
