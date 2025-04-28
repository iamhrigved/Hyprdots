#!/bin/zsh

echo "tty" > ~/.cache/current-kb-layout &&
systemctl --user restart kanata.service
