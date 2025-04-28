#!/bin/bash

# if file cache file doesn't exists
if [ ! -f ~/.cache/current-kb-layout ]; then
    echo "colemak_dh" > ~/.cache/current-kb-layout
fi

current_layout=$(cat ~/.cache/current-kb-layout)

/usr/bin/kanata --nodelay -c "$HOME/.config/kanata/$current_layout.kbd"
