#!/usr/bin/env bash
# rofi-windows-preview
# Author: @dvishal485

dir="$HOME/.config/rofi"
theme='style-6'
temp="$HOME/.cache/rofi-windows-preview"
include_special_workspace=false

workspace_overview(){
    mkdir -p $temp
    local animation=$(hyprctl getoption animations:enabled -j | jq -r .int)
    hyprctl keyword animations:enabled 0
    local active_win=$(hyprctl activewindow -j | jq -r ".address")
    local windows=$(hyprctl clients -j)

    local jq_filter
    if [[ $include_special_workspace != "true" ]]; then
        jq_filter='map(select(.workspace.name | contains("special") | not)) | sort_by(.workspace.id) | .[] | "\(.address)\t\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])\t\(.title)"'
    else
        jq_filter='sort_by(.workspace.id) | .[] | "\(.address)\t\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])\t\(.title)"'
    fi

    local text=""
    while IFS=$'\t' read -r address geom title; do
        hyprctl dispatch focuswindow address:"$address" && grim -g "$geom" "$temp/$address.png"
        text+="${title} - ${address}\0icon\x1f$temp/${address}.png\n"
    done < <(echo "$windows" | jq -r "$jq_filter")

    hyprctl dispatch focuswindow address:"$active_win"
    hyprctl keyword animations:enabled "$animation"
	selected=$(echo -en $text | rofi -dmenu -i -theme ${dir}/${theme}.rasi)
	if [[ $selected != "" ]]; then
        hyprctl dispatch focuswindow address:$(echo $selected | rg '\-\s([a-z0-9]*)$' -or '$1')
    fi
    rm -r $temp/*
}

pkill rofi || workspace_overview > /dev/null
