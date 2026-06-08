#!/bin/bash
STATE=$(nmcli radio wifi)
[ "$STATE" = "enabled" ] && echo "󰤨" || echo "󰤭"
