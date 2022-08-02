#!/bin/sh

# Set X cursor to arrow.
xsetroot -cursor_name left_ptr

# Disable screen saver.
xset s off
xset -dpms

# Enable Ctrl-Alt-Backspace to kill the X server.
setxkbmap -option terminate:ctrl_alt_bksp

# Override 'rxvt-unicode-256color' to avoid "terminal is not fully
# functional" warnings.
TERM=rxvt-unicode

# Fix OpenOffice.org.
export OOO_FORCE_DESKTOP=gnome

# Activate preferred display (if connected).
~/bin/activate-preferred-display.sh

# Set random wallpaper.
~/bin/set_random_wallpaper.sh &

# Have screen color temperature dynamically adjusted.
redshift &

# Hide inactive mouse cursor.
/usr/bin/unclutter -idle 1 -root &

# Start window manager.
xmonad
