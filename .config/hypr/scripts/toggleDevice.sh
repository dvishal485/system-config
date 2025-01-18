#!/usr/bin/env bash

toggle_device() {
    # method 1: hyprctl bug causes wrong device being toggled
    # when multiple devices are being toggled
    # local config=device[$1]:enabled

    # method 2: use hyprland env var
    local config='$'$1

    local status_file=$HOME/.config/$1.status
    local status=$(cat $status_file || (touch $status_file && printf true))
    local short_name=$(echo $1 | rg '[a-z]*$' -o)
    if [[ $status == "true" ]]; then
        status=false
        notify-send "Disabling device $short_name" "$1"
    else
        status=true
        notify-send "Enabling device $short_name" "$1"
    fi
    printf $status > "$status_file"
    hyprctl -r keyword $config $status
}

toggle_device $1
