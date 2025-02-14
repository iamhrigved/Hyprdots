#!/bin/zsh

layout_file=$HOME/.cache/current-kb-layout
current_layout=$(cat $layout_file)

if [[ $current_layout == "colemak_dh" ]]; then
    echo "qwerty" > $layout_file &&
    systemctl --user restart kanata.service &&
    notify-send -i "key_bindings" "QWERTY" "Keyboard Layout changed!"
    exit
fi

# if current layout is qwerty

echo "colemak_dh" > $layout_file &&
systemctl --user restart kanata.service &&
notify-send -i "key_bindings" "Colemak DH" "Keyboard Layout changed!"
