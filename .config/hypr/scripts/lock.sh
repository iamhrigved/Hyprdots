#!/bin/zsh

hyprctl dispatch submap lockscreen # engage lockscreen keybinds

pidof hyprlock || hyprlock # engage hyprlock

hyprctl dispatch submap reset # reset the submap when hyprlock is exited
