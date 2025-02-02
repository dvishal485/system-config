#!/usr/bin/env sh

MIC_VOLUME=$(wpctl get-volume @DEFAULT_AUDIO_SOURCE@)
ICON=$(echo -n $VOLUME | rg -q MUTED && echo "mic-off" || echo "mic-on")

if echo -n $MIC_VOLUME | rg -q MUTED; then
    brightnessctl -d platform::micmute s 1
    ICON="mic-off"
else
    brightnessctl -d platform::micmute s 0
    ICON="mic-on"
fi
MIC_VOLUME_INT=$(echo -n $MIC_VOLUME | rg -o '([0-9]).([0-9]*)' -r '$1$2')
notify-send "Output Sound" "$MIC_VOLUME" -e -i $ICON -h int:value:$MIC_VOLUME_INT -h string:synchronous:mic-volume
