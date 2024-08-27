#!/bin/zsh

# The main usage of this script (other than storing the clipboard items to cliphist)
# is to get a notification when an image is copied.

cat - > /tmp/clipboard-contents # write the clipboard-contents to a file

if cmp -s /tmp/clipboard-contents /tmp/prev-clipboard-contents; then # compare to old clipboard content
    exit 0
fi

if file -i /tmp/clipboard-contents | grep -q "charset=binary"; then # check if binary
    notify-send "Image Copied!" '<img src="/tmp/clipboard-contents">'
fi

cat /tmp/clipboard-contents | cliphist store # store to cliphist

mv -f /tmp/clipboard-contents /tmp/prev-clipboard-contents
