#!/bin/sh

# Set X cursor to arrow.
xsetroot -cursor_name left_ptr

# Disable screen saver.
xset s off
xset -dpms

# Enable Ctrl-Alt-Backspace to kill the X server.
setxkbmap -option terminate:ctrl_alt_bksp

# Fix OpenOffice.org.
export OOO_FORCE_DESKTOP=gnome

##gnome-settings-daemon &

# Configure screens.
##xrandr --output VGA-0 --right-of DVI-0

# Set random wallpaper.
~/bin/set_random_wallpaper.sh &

# Hide inactive mouse cursor.
/usr/bin/unclutter -idle 1 -root &

# Start window manager.
xmonad
