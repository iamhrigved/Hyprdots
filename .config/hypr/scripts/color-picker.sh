#!/bin/zsh

color=$(hyprpicker -af hex)

if [[ $color != "" ]]; then
    notify-send "Hyprpicker" "$color: copied to clipboard!" -i "colormanagement"
fi
