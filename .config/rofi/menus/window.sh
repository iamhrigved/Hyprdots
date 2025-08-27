#!/bin/zsh

clients_raw=$(hyprctl clients)

clients=(${(ps/\n\n/)clients_raw})

menu=""

for client in $clients; do
    window_name=$(echo $client | rg -e '.*-> (.*):.*' -U -r '$1')
    neg_workspace=$(echo $client | rg -e '.*workspace: (.*) \(.*' -U -r '$1' | grep -o "-")
    if [[ "$neg_workspace" != "-" ]]; then
        menu=$menu\\n$window_name
    fi
done;

menu=$(echo $menu | sed -r '/^\s*$/d') # remove empty line

# echo $menu | rofi -dmenu -theme /styles/window.rasi

rofi -drun-use-desktop-cache -show window -p " " -theme /styles/window.rasi
