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

# show menu (with icon)
selected_wallpaper=$(for a in $wallpapers; do
    if [[ ${a:t} == $current_wallpaper_name ]] then;
        echo -en "${a:t} (current)\0icon\x1f$a\n"
    else
        echo -en "${a:t}\0icon\x1f$a\n"
    fi
done | rofi -dmenu -p " " -theme /styles/swww.rasi)

# removing the added " (current)" from the selected wallpaper (no matter the item selected)
final_wallpaper=$(echo $selected_wallpaper | sed "s/ (current)//")
wallpaper_ext=$(echo $final_wallpaper | sed "s/.*\.\(.*\)/\1/")

# changing the wallpaper and the colorscheme if selected wallpaper is not empty
if [[ $selected_wallpaper != "" ]]; then
    swww img ~/Pictures/Wallpapers/$final_wallpaper --transition-type center --transition-fps 60 --transition-step 100 &&

    wallust run ~/Pictures/Wallpapers/$final_wallpaper -n -s && # running wallust without terminal color sequences

    ~/.config/hypr/scripts/terminal-red-color.sh && # changing the red color of the terminal (it looks bad by default)

    plasma-apply-colorscheme BreezeDark && plasma-apply-colorscheme Wallust &&

    ln -f ~/Pictures/Wallpapers/$final_wallpaper ~/.cache/current-wallpaper && # creates a symlink to the current wallpaper

    ~/.config/hypr/scripts/generate-wallpaper-variants.sh && # generates all the variants at a single time

    swaync-client -R && swaync-client -rs # reloads swaync css
fi
