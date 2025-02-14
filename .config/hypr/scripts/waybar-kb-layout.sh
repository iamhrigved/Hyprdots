#!/bin/zsh

current_layout=$(cat ~/.cache/current-kb-layout)

if [[ $current_layout == "colemak_dh" ]]; then
    echo '{"text": "Colemak-DH", "alt": "colemak_dh", "tooltip": "Current Layout: Colemak DH"}'
else
    echo '{"text": "QWERTY", "alt": "qwerty", "tooltip": "Current Layout: QWERTY"}'
fi
