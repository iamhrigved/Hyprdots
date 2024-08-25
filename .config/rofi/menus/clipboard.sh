#!/bin/zsh

clipboard=$(cliphist list)

echo $clipboard | rofi -dmenu -theme /styles/clipboard.rasi -p "󱘢" -display-columns 2  | cliphist decode | wl-copy
