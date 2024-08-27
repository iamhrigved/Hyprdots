#!/bin/zsh

clipboard=$(cliphist list)

selected=$(echo $clipboard | rofi -dmenu -theme /styles/clipboard.rasi -p "󱘢" -display-columns 2)

if [[ $selected != "" ]]; then
    echo $selected | cliphist decode | wl-copy
fi
