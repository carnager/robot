#!/bin/bash

source $HOME/.config/robo

cd $bmark_dir
browseBookmarks () {
    bookmark="$(echo -e "$(cat bookmarks | awk -F ' @@ ' '{ print $1, $4, $3 }' | rofi -dmenu -p "Choose Bookmark > ")")"
    bmark=$(echo "$bookmark" | cut -d ' ' -f1)
    chromium $(cat bookmarks | grep "$bmark" | awk -F ' @@ ' '{ print $2 }')
}

addBookmarks () {
    bookmark=$(echo -e "Use ctrl+v to paste bookmark" | rofi -dmenu -p "Add Bookmark > ")
    tags=$(echo -e "Add some Tags to your bookmark (seperate with comma)" | rofi -dmenu -p "Add Tags > ")
    name=$(echo -e "Please Enter the Display Name for the bookmark" | rofi -dmenu -p "Name > ")
    id=$(cat bookmarks | wc -l)

    echo "$(( $id + 1 )) @@ $bookmark @@ $tags @@ $name" >> bookmarks
}

if [[ $1 == "add" ]]; then
    addBookmarks
elif [[ $1 == "list" ]]; then
    browseBookmarks
else
    echo "Please use the "add" or "list" arguments"
fi
