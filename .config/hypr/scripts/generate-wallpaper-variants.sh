#!/bin/zsh

magick ~/.cache/current-wallpaper -scale 75% ~/.cache/temp
magick ~/.cache/temp -fill black -colorize 50% ~/.cache/wallpaper-blur-dim
magick ~/.cache/wallpaper-blur-dim -blur 0x10 ~/.cache/wallpaper-blur-dim
rm ~/.cache/temp
