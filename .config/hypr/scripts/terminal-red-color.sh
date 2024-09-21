#!/bin/zsh

# changing the red color of terminal because the default color by wallust is really dark (most of the times)

__hex2rgb() {
    hex=$1

    if [[ "#" == "${hex:0:1}" ]]; then
        hex="${hex:1:6}"
    fi

    hex_r="${hex:0:2}"
    hex_g="${hex:2:2}"
    hex_b="${hex:4:2}"

    rgb_r=`echo $((16#$hex_r))`
    rgb_g=`echo $((16#$hex_g))`
    rgb_b=`echo $((16#$hex_b))`

    echo "$rgb_r $rgb_g $rgb_b"
}

__rgb2hex() {
    rgb_r=$1
    rgb_g=$2
    rgb_b=$3

    hex_r=`echo $(([##16]rgb_r))`
    hex_g=`echo $(([##16]rgb_g))`
    hex_b=`echo $(([##16]rgb_b))`

    hex=($hex_r $hex_g $hex_b)

    for a in 1 2 3; do
        if [ $((16#$hex[$a])) -lt 16 ]; then # adding a 0 when there is only 1 digit in hex
            hex[$a]="0$hex[$a]"
        fi
    done

    echo "#$hex[1]$hex[2]$hex[3]"
}

__mix() { # will take 2 hex values and return the mixture in hex
    rgb1=($(__hex2rgb $1))
    rgb2=($(__hex2rgb $2))

    rgb=()

    for a in 1 2 3; do
        rgb[$a]=$((($rgb1[$a] + $rgb2[$a]) / 2))
    done

    hex=$(__rgb2hex $rgb)

    echo $hex
}

wallust_red1=$(cat ~/.config/kitty/colors.conf | grep "color1 " | sed "s/.*\(#.*\)/\1/g")
wallust_red2=$(cat ~/.config/kitty/colors.conf | grep "color9 " | sed "s/.*\(#.*\)/\1/g")

my_red=#f7768e # TokyoNight red color

custom_red1=$(__mix $wallust_red1 $(__mix $wallust_red1 $my_red))
custom_red2=$(__mix $wallust_red2 $(__mix $wallust_red2 $my_red))

sed -i "s/$wallust_red1/$custom_red1/g" ~/.config/kitty/colors.conf
sed -i "s/$wallust_red2/$custom_red2/g" ~/.config/kitty/colors.conf

kill -SIGUSR1 $(pgrep kitty)

echo "$wallust_red1 * 2 + $my_red = $custom_red1"
echo "$wallust_red2 * 2 + $my_red = $custom_red2"
