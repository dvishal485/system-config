#!/usr/bin/env sh

CURR_BRIGHTNESS=$(brightnessctl g)
MAX_BRIGHTNESS=$(brightnessctl m)
BRIGHTNESS_PERCENT=$((($CURR_BRIGHTNESS * 100) / $MAX_BRIGHTNESS))
notify-send "Brightness" "$BRIGHTNESS_PERCENT%" -u low -e -h string:synchronous:brightness -h int:value:$BRIGHTNESS_PERCENT -i brightness
