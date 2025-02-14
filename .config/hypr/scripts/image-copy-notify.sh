#!/bin/zsh

# The main usage of this script (other than storing the clipboard items to cliphist)
# is to get a notification when an image is copied.

cat - > /tmp/clipboard-image # write the clipboard-image to a file

if cmp -s /tmp/clipboard-image /tmp/prev-clipboard-image; then # compare to old clipboard image
    exit 0
fi

notify-send "Image Copied!" 'This image is copied to clipboard! <img src="/tmp/clipboard-image">' -i "image"

cat /tmp/clipboard-image | cliphist store # store to cliphist

mv -f /tmp/clipboard-image /tmp/prev-clipboard-image
