#!/usr/bin/env sh

VOLUME=$(wpctl get-volume @DEFAULT_AUDIO_SINK@)
ICON=$(echo -n $VOLUME | rg -q MUTED && echo "audio-off" || echo "audio-on")
VOLUME_INT=$(echo -n $VOLUME | rg -o '([0-9]).([0-9]*)' -r '$1$2')
notify-send "Output Sound" "$VOLUME" -e -i $ICON -h int:value:$VOLUME_INT -h string:synchronous:volume
