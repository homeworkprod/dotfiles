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

# Activate preferred display (if connected).
~/bin/activate_preferred_display.sh

# Set random wallpaper.
~/bin/set_random_wallpaper.sh &

# Hide inactive mouse cursor.
/usr/bin/unclutter -idle 1 -root &

# Have screen color temperature dynamically adjusted.
redshift &

# Start window manager.
xmonad
