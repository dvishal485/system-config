#!/usr/bin/env sh

HYPRGAMEMODE=$(hyprctl getoption animations:enabled | awk 'NR==1{print $2}')
if [ "$HYPRGAMEMODE" = 1 ] ; then
    notify-send "Game Mode" "Game Mode enabled" -i settings -e
    hyprctl keyword monitor eDP-1,highres,highrr,1.0
    hyprctl --batch "\
        keyword animations:enabled 0;\
        keyword decoration:shadow:enabled 0;\
        keyword decoration:blur:enabled 0;\
        keyword general:gaps_in 0;\
        keyword general:gaps_out 0;\
        keyword general:border_size 1;\
        keyword decoration:rounding 0"
    exit
else
    notify-send "Game Mode" "Game Mode disabled" -i settings -e
fi
hyprctl reload
