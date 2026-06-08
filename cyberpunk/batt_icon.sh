#!/bin/bash
STATUS=$(cat /sys/class/power_supply/BAT0/status 2>/dev/null)
CAP=$(cat /sys/class/power_supply/BAT0/capacity 2>/dev/null || echo 0)
if [ "$STATUS" = "Charging" ]; then echo ""; exit; fi
if   [ "$CAP" -ge 90 ]; then echo ""
elif [ "$CAP" -ge 60 ]; then echo ""
elif [ "$CAP" -ge 40 ]; then echo ""
elif [ "$CAP" -ge 20 ]; then echo ""
else echo ""
fi
