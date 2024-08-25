#!/bin/zsh

###############################
########## WLOGOUT ############
###############################
magick ~/.cache/current-wallpaper -scale 75% ~/.cache/temp
magick ~/.cache/temp -fill black -colorize 50% ~/.cache/wlogout-background
magick ~/.cache/wlogout-background -blur 0x10 ~/.cache/wlogout-background
rm ~/.cache/temp
