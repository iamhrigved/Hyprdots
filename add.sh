#!/bin/bash

# copying the thing
cp -r ~/$1 ~/.Hyprdots/$1 &&

# stow-ing it
parent=$(dirname $1)
stow --adopt $parent &&

# adding the changes to git
git add . &&

# commiting the changes
if [[ -d ~/.Hyprdots/$1 ]]; then
    git commit -m "Add $1 directory"
elif [[ -f ~/.Hyprdots/$1 ]]; then
    git commit -m "Add $1 file"
fi
