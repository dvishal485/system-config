#!/usr/bin/env bash
# rofi-windows-preview
# Author: @dvishal485

dir="$HOME/.config/rofi"
theme='style-6'
temp="$HOME/.cache/rofi-windows-preview"
include_special_workspace=false

workspace_overview(){
    mkdir -p $temp
    local animation=$(hyprctl getoption animations:enabled -j | jq .int)
    hyprctl keyword animations:enabled 0
    local active_win=$(hyprctl activewindow -j | jq ".address")
    local windows=$(hyprctl clients -j)
    if [[ $include_special_workspace != "true" ]]; then
        windows=$(echo $windows | jq 'map(select(.workspace.name | contains("special") | not))')
    fi
	echo $windows | jq -r 'sort_by(.workspace.id) .[] | "hyprctl dispatch focuswindow address:\(.address) && grim -g \"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])\" \"$temp/\(.address).png\""' | while read cmd; do
	    eval "$cmd"
	done
	# dunno why it doesn't work
	# hyprctl dispatch focuswindow address:$active_win
	echo $active_win | xargs -I {} hyprctl dispatch focuswindow address:{}
	hyprctl keyword animations:enabled $animation
	local text=$(echo $windows | jq -r '.[] | "\(.title) - \(.address)\\0icon\\x1f'$temp'/\(.address).png\\n"')
	selected=$(echo -en $text | rofi -dmenu -i -theme ${dir}/${theme}.rasi)
	if [[ $selected != "" ]]; then
        hyprctl dispatch focuswindow address:$(echo $selected | rg '\-\s([a-z0-9]*)$' -or '$1')
    fi
    rm -r $temp/*
}

pkill rofi || workspace_overview > /dev/null
