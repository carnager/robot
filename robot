#!/bin/bash

source $HOME/.config/robot/config

cd $bmark_dir
browseBookmarks () {
    bookmark="$(cat bookmarks | awk -F ' @@ ' '{ printf "%3s %-20s %59s\n", $1, $4, $3 }' | rofi -width 30 -dmenu -p "Choose Bookmark > ")"
    bmark=$(echo "$bookmark" | awk '{ print $1 }')
    if [[ "$bookmark" == "" ]]; then
        exit
    else
        chromium $(cat bookmarks | grep "$bmark" | awk -F ' @@ ' '{ print $2 }')
    fi
}

addBookmarks () {
    bookmark=$(echo -e "Use ctrl+v to paste bookmark" | rofi -dmenu -p "Add Bookmark > ")
    if [[ "$bookmark" == "" ]]; then
        exit
    else
        addTags
    fi
}

addTags () {
    tags=$(echo -e "Add some Tags to your bookmark (seperate with comma)" | rofi -dmenu -p "Add Tags > ")
    if [[ "$tags" == "" ]]; then
        confirm=$(echo -e "1  Yes\n2  No" | rofi -dmenu -p "Continue without Tags? > ")
        if [[ "$confirm" == "1  Yes" ]]; then
            addName
        elif [[ "$confirm" == "2  No" ]]; then
            addTags
        fi
    elif [[ "$tags" == "Add some Tags to your bookmark (seperate with comma)" ]]; then
        confirm=$(echo -e "1  Yes\n2  No" | rofi -dmenu -p "Continue without Tags? > ")
        if [[ "$confirm" == "1  Yes" ]]; then
            addName
        elif [[ "$confirm" == "2  No" ]]; then
            addTags
        fi
    else
        addName
    fi
}

addName () {
    name=$(echo -e "Please Enter the Display Name for the bookmark" | rofi -dmenu -p "Name > ")
    if [[ "$name" == "" ]]; then
        exit
    elif [[ "$name" == "Please Enter the Display Name for the bookmark" ]]; then
        addName
    else
        id=$(cat bookmarks | wc -l)
        echo "$(( $id + 1 )) @@ $bookmark @@ $tags @@ $name" >> bookmarks
    fi
}

if [[ $1 == "add" ]]; then
    addBookmarks
elif [[ $1 == "list" ]]; then
    browseBookmarks
else
    echo "Please use the "add" or "list" arguments"
fi
