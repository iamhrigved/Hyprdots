selected=$(echo " Shutdown
 Restart
󰤄 Sleep" | rofi -dmenu)

if [[ $(echo $selected | grep -oi "restart") == "Restart" ]]; then
    echo "HI RAMESH"
fi
