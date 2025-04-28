#!/bin/zsh

# all wallpapers array
wallpapers=(~/Pictures/Wallpapers/*)

# getting the current wallpaper with `swww query`
current_wallpaper_path=$(swww query | sed "s/.*image: \(.*\)/\1/") 

# if the daemon is not running
if [[ $current_wallpaper_path == "" ]] then;
    swww-daemon &!
fi

current_wallpaper_name=${current_wallpaper_path:t}

# good thresholds for specific wallpapers
typeset -A hash
hash[landscape5.jpg]=8
hash[landscape6.png]=14
hash[forest2-mononoke.png]=6
hash[anime1.png]=20
hash[anime2.jpg]=20
hash[street1.png]=2
hash[street2.jpg]=8
hash[sunset1.png]=4
hash[sunset2.jpg]=16
hash[flowers1.png]=14
hash[landscape7.png]=12

# show menu (with icon)
selected_wallpaper=$(for a in $wallpapers; do
    list_item=""
    head=${a:t}

    # check if current wallpaper
    if [[ $head == $current_wallpaper_name ]] then;
        list_item="$(echo -en "$head (current)")"
    else
        list_item="$(echo -en $head)"
    fi
    
    # check if favourite
    if [[ ${hash[$head]} != "" ]]; then
        list_item="$list_item "
    fi

    # add icon and final echo
    list_item="$list_item\0icon\x1f$a"
    echo $list_item
done | rofi -drun-use-desktop-cache -dmenu -p " " -theme /styles/swww.rasi)

# removing the added " (current)" or the  from the selected wallpaper
final_wallpaper=$(echo $selected_wallpaper | awk '{print $1}')

# changing the wallpaper and the colorscheme if selected wallpaper is not empty
if [[ $selected_wallpaper != "" ]]; then
    swww img ~/Pictures/Wallpapers/$final_wallpaper --transition-type center --transition-fps 60 --transition-step 100 &&

    if [[ ${hash[$final_wallpaper]} != "" ]]; then
        wallust run ~/Pictures/Wallpapers/$final_wallpaper -t ${hash[$final_wallpaper]}
    else
        wallust run ~/Pictures/Wallpapers/$final_wallpaper && # running wallust
    fi &&

    kill -SIGUSR1 $(pgrep kitty) && # reload kitty theme

    ln -f ~/Pictures/Wallpapers/$final_wallpaper ~/.cache/current-wallpaper && # creates a symlink to the current wallpaper

    plasma-apply-colorscheme BreezeDark && plasma-apply-colorscheme Wallust &&

    ~/.config/hypr/scripts/generate-wallpaper-variants.sh && # generates all the variants at a single time

    swaync-client -R && swaync-client -rs && # reloads swaync css

    notify-send "Wallpaper Changed!" "Current wallpaper: $final_wallpaper" -i "preferences-wallpaper"
fi
