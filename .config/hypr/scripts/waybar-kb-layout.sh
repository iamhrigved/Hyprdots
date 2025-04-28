#!/bin/zsh

current_layout=$(cat ~/.cache/current-kb-layout)

if [[ $current_layout == "colemak_dh" ]]; then
    echo '{"text": "Colemak-DH", "alt": "colemak_dh", "tooltip": "Current Layout: Colemak DH"}'
elif [[ $current_layout == "tty" ]]; then
    echo '{"text": "TTY", "alt": "tty", "tooltip": "TTY Mode Activated"}'
else
    echo '{"text": "QWERTY", "alt": "qwerty", "tooltip": "Current Layout: QWERTY"}'
fi
