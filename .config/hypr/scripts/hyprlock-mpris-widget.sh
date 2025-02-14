#!/bin/zsh

img_path=$(playerctl metadata mpris:artUrl)
title_name=$(playerctl metadata xesam:title)
artist_name=$(playerctl metadata xesam:artist)

echo $img_path
echo $title_name
echo $artist_name
