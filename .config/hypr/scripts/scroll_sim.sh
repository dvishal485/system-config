#!/usr/bin/env sh

trap "exit 0" SIGINT SIGTERM

scroll_ev(){
    local base=$(hyprctl cursorpos -j | jq .y)
    dotool < <(
    while true; do
        local curr=$(hyprctl cursorpos -j | jq .y)
        local delta=$(( (curr - base) / 3 ))
        base=$curr
        printf "wheel $delta\n"
    done
    )
}

scroll_ev
