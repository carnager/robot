#!/bin/bash

source $HOME/.config/robot/config
cd "${root}"

main () {
files="$(find . \( ! -regex '.*/\..*' \) -type f \
    | cut -c 3- \
    | roficmd -dmenu -mesg "Enter: Open URL | Alt+e: Edit Entry | Alt+n: Add Bookmark" -kb-custom-1 "Alt+e" -kb-custom-2 "Alt+n" -p "Bookmarks > ")"

val=$?

if [[ $val -eq 10 ]]; then
    echo "${files}" | while read line; do
        $EDITOR "$(echo "${line}" &)"
    done
elif [[ $val -eq 0 ]]; then
    echo "${files}" | while read line; do
        $BROWSER "$(head -1 "${line}")"
    done
elif [[ $val -eq 1 ]]; then
    exit
elif [[ $val -eq 11 ]]; then
    addBookmark
fi
}

addBookmark() {
    url=$(echo "" | roficmd -dmenu -mesg "Press Ctrl+v to paste from Clipboard or enter an URL manually" -p "URL > ")
    domain=$(python2 -c "from urlparse import urlparse; url = urlparse('$url'); print url.netloc")
    val=$?
    if [[ $val -eq 1 ]]; then
        exit
    elif [[ $val -eq 0 ]]; then
        group=$(find . -type d | cut -c 3- | tail -n +2 | roficmd -dmenu -p "Group > " -mesg "Choose Group or enter a new one > ")
        val=$?
        if [[ $val -eq 1 ]]; then
            exit
        elif [[ $val -eq 0 ]]; then
            :
        fi
        filename=$(echo -e "${domain}" | roficmd -dmenu -mesg "Choose Filaname or Enter your own" -p "Filename > ")
        val=$?
        if [[ $val -eq 1 ]]; then
            exit
        elif [[ $val -eq 0 ]]; then
            if [[ $filename == "" ]]; then
                filename="${domain}"
            fi
        fi
        if [[ -d "$group" ]]; then
            echo "${url}" > "${group}/${filename}"
        else
            mkdir "${group}"
            echo "${url}" > "${group}/${filename}"
        fi
    fi
}

if [[ -z "$rofiopts" ]]; then
    roficmd () {
        rofi -dmenu "$@"
    }
else
    roficmd () {
        rofi -dmenu $(echo "$rofiopts") "$@"
    }
fi

main
