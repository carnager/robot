# robot

Poor man's bookmarks manager utilizing rofi and bash
It uses a simple directory/file structure.
Groups are defined with directories and actual bookmarks with files.

It's basically a very stripped down version of rofi-pass, which does
nothing but open URLs. And without the encryption, of course.

# Screenshot
![Screenshot]
(images/robot.jpg)

# Features:

* Simple directory/file structure
* Open bookmarks (duh!)
* Edit bookmarks in Editor
* Store bookmarks in git repository

# TODO

* Move bookmark files to different groups
* Delete bookmarks

# Dependencies:

* rofi (https://github.com/DaveDavenport/rofi)
* python2

# Installation

2. Copy config.robot to $HOME/.config/robot/config and edit it.
3. Copy robot to $PATH
4. Run robot

For arch linux there is a package in [AUR](https://aur.archlinux.org/packages/robot-git/)
