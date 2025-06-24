#!/usr/bin/env sh

MIC_VOLUME=$(wpctl get-volume @DEFAULT_AUDIO_SOURCE@)

if echo -n $MIC_VOLUME | rg -q MUTED; then
    brightnessctl -d platform::micmute s 1
else
    brightnessctl -d platform::micmute s 0
fi
