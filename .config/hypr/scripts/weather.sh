#!/bin/zsh

if [ $(nmcli --get-values TYPE con show --active | grep -o "ethernet") ]; then
    location=Varanasi
    echo $location
fi
