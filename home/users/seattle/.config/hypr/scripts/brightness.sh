#!/usr/bin/env sh

CURR_BRIGHTNESS=$(brightnessctl g)
MAX_BRIGHTNESS=$(brightnessctl m)

if [ -z "$MAX_BRIGHTNESS" ] || [ "$MAX_BRIGHTNESS" -eq 0 ]; then
    BRIGHTNESS_PERCENT=0
else
    BRIGHTNESS_PERCENT=$(( (CURR_BRIGHTNESS * 100) / MAX_BRIGHTNESS ))
fi

notify-send "Brightness" "$BRIGHTNESS_PERCENT%" -u low -e -h string:synchronous:brightness -h int:value:$BRIGHTNESS_PERCENT -i brightness
