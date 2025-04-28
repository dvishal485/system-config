#!/usr/bin/env sh

HYPRGAMEMODE=$(hyprctl getoption animations:enabled | awk 'NR==1{print $2}')

if [ "$HYPRGAMEMODE" = 1 ] ; then
    action=$(notify-send "Game Mode" "Game mode is not running, do you want to enable it?" -i settings -a "hyprctl" -u critical -c "Disable,Enable" -A enable=Enable -A dismiss=Dismiss)
    if [ "$action" = "enable" ] ; then
        hyprctl keyword monitor eDP-1,highres,highrr,1.0
        hyprctl --batch "\
            keyword animations:enabled 0;\
            keyword decoration:shadow:enabled 0;\
            keyword decoration:blur:enabled 0;\
            keyword general:gaps_in 0;\
            keyword general:gaps_out 0;\
            keyword general:border_size 1;\
            keyword decoration:rounding 0"
    fi
    exit
fi

action=$(notify-send "Game Mode" "Game mode is active, do you want to disable it?" -i settings -a "hyprctl" -u critical -c "Disable,Enable" -A disable=Disable -A dismiss=Dismiss)
if [ "$action" = "disable" ] ; then
    hyprctl reload
fi
