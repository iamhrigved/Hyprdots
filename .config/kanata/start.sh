#!/bin/bash

current_layout=$(cat ~/.cache/current-kb-layout)

/usr/bin/kanata --nodelay -c "$HOME/.config/kanata/$current_layout.kbd"
