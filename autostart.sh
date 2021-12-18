#!/usr/bin/env bash

function backg() {
    cp ~/.bashrc ~/.bashrc_init
    echo "~/bin/desktop_app.sh .bashrc_init && reset" >> ~/.bashrc_init 
    xterm -bg black -fullscreen -e "bash --init-file ~/.bashrc_init"
}

xsetroot -solid black &
xrdb -merge ~/.Xresources &
#~/bin/night_light on &
xset -dpms s off &
#~/bin/keyboard us &
sleep 0.5 && backg
