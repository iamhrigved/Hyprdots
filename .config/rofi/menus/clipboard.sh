#!/bin/zsh

selected=$(cliphist list | rofi -dmenu -theme /styles/clipboard.rasi -p "󱘢" -display-columns 2)

if [[ $selected != "" ]]; then
    echo $selected | cliphist decode | wl-copy
fi
