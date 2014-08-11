#!/bin/bash

source $HOME/.config/robot/config

cd $bmark_dir
openBookmarks () {
    while read bookmark
    do
        bmark=$(echo "$bookmark" | awk -F 'id=' '{ print $2 }')
        if [[ "$bookmark" == "" ]]; then
            exit
        elif [[ "$bookmark" == "Mode: Open" ]]; then
            copyBookmarks
        else
            chromium $(cat bookmarks | grep "$bmark" | awk -F ' @@ ' '{ print $2 }')
        fi
    done < <(echo -e "Mode: Open\n---\n$(cat bookmarks | awk -F ' @@ ' '{ printf "%-30s  %-78s  %20s %6s\n", $4, $3, $5, $1 }')" | rofi -dmenu -p "Choose Bookmark > ")
}

copyBookmarks () {
    while read bookmark
    do
        bmark=$(echo "$bookmark" | awk -F 'id=' '{ print $2 }')
        if [[ "$bookmark" == "" ]]; then
            exit
        elif [[ "$bookmark" == "Mode: Copy" ]]; then
            editBookmarks
        else
            echo -n $(cat bookmarks | grep "$bmark" | awk -F ' @@ ' '{ print $2 }') | xclip && xclip -o | xclip -selection clipboard
        fi
    done < <(echo -e "Mode: Copy\n---\n$(cat bookmarks | awk -F ' @@ ' '{ printf "%-30s  %-78s  %20s %6s\n", $4, $3, $5, $1 }')" | rofi -dmenu -p "Choose Bookmark > ")
}

editBookmarks () {
    while read bookmark
    do
        bmark=$(echo "$bookmark" | awk -F 'id=' '{ print $2 }')
        if [[ "$bookmark" == "" ]]; then
            exit
        elif [[ "$bookmark" == "Mode: Edit" ]]; then
            openBookmarks
        else
            echo $bmark
            id=$bmark
            bookmark=$(cat bookmarks | grep "$bmark" | awk -F ' @@ ' '{ print $2 }')
            sed -i "/^id=$id/d" "$bmark_dir"/bookmarks
            addCategory
            echo "id=$id @@ $bookmark @@ $tags @@ $name @@ $category" >> bookmarks
            sorted=$(sort -t "=" -k2 -n bookmarks)
            rm -f "$bmark_dir"/bookmarks
            echo "$sorted" > "$bmark_dir"/bookmarks
        fi
    done < <(echo -e "Mode: Edit\n---\n$(cat bookmarks | awk -F ' @@ ' '{ printf "%-30s  %-78s  %20s %6s\n", $4, $3, $5, $1 }')" | rofi -dmenu -p "Choose Bookmark > ")
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
#    else
        #echo "$(( $id + 1 )) @@ $bookmark @@ $tags @@ $name @@ $category" >> bookmarks
    fi
}

if [[ $1 == "add" ]]; then
    addBookmarks
    id=$(cat bookmarks | wc -l)
    echo "id=$(( $id + 1 )) @@ $bookmark @@ $tags @@ $name @@ $category" >> bookmarks
elif [[ $1 == "list" ]]; then
    openBookmarks
else
    echo "Please use the "add" or "list" arguments"
fi
