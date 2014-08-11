#!/bin/bash

source $HOME/.config/robot/config

cd $bmark_dir
browseBookmarks () {
    bookmark="$(cat bookmarks | awk -F ' @@ ' '{ printf "%-30s  %-50s  %20s %3s\n", $4, $3, $5, $1 }' | rofi -dmenu -p "Choose Bookmark > ")"
    bmark=$(echo "$bookmark" | awk '{ print $4 }')
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
    elif [[ "$bookmark" == "Use ctrl+v to paste bookmark" ]]; then
        confirm=$(echo -e "1  Yes\n2  No" | rofi -dmenu -p "Use $(xclip -selection clipboard -o)?")
        if [[ "$confirm" == "1  Yes" ]]; then
            bookmark=$(xclip -selection clipboard -o)
            notify-send "robot" "Using $(xclip -selection clipboard -o) as URL"
            addCategory
        elif [[ "$confirm" == "2  No" ]]; then
            addBookmarks
        fi
    else
        addCategory
    fi
}


addCategory () {
    category=$(echo -e "No Category" | rofi -dmenu -p "Add Category > ")
    if [[ "$category" == "" ]]; then
        exit
    elif [[ "$category" == "No Category" ]]; then
        confirm=$(echo -e "1  Yes\n2  No" | rofi -dmenu -p "Continue without Category? > ")
        if [[ "$confirm" == "1  Yes" ]]; then
            category="#none"
            addTags
        elif [[ "$confirm" == "2  No" ]]; then
            addCategory
        fi
    else
        addTags
    fi
}

addTags () {
    tags=$(echo -e "No Tags" | rofi -dmenu -p "Add Tags > ")
    if [[ "$tags" == "" ]]; then
        exit
    elif [[ "$tags" == "No Tags" ]]; then
        confirm=$(echo -e "1  Yes\n2  No" | rofi -dmenu -p "Continue without Tags? > ")
        if [[ "$confirm" == "1  Yes" ]]; then
            tags="#none"
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
        echo "$(( $id + 1 )) @@ $bookmark @@ $tags @@ $name @@ $category" >> bookmarks
    fi
}

if [[ $1 == "add" ]]; then
    addBookmarks
elif [[ $1 == "list" ]]; then
    browseBookmarks
else
    echo "Please use the "add" or "list" arguments"
fi
