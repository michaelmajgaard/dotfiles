#!/bin/bash

sudo echo 'user-db:user
system-db:gdm
file-db:/usr/share/gdm/greeter-dconf-defaults' > /etc/dconf/profile/gdm

sudo mkdir /etc/dconf/db/gdm.d/

sudo echo '[org/gnome/login-screen]
disable-user-list=true' > /etc/dconf/db/gdm.d/00-login-screen

dconf update

