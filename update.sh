#!/bin/zsh

diffs_config=($(diff -q -r ~/.config ./.config | sed "s/Only in \(.*\): \(.*\)/\1\/\2/g"))

for a in $diffs_config; do
    if [[ -f $a ]]; then
        new_file=$(echo $a | sed "s/\(.*\).config\(.*\)/.config\2/")
        echo "Copying $a -> $new_file"
    fi
done

# stow --ignore=Wallpapers . &&
#
# stow --target=~/Pictures/ Wallpapers
