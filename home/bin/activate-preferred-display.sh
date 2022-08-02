#!/bin/sh

# Switch to Display Port 1 (disabling the laptop's built-in display) if
# an external monitor is connected to it, and use only the laptop's
# display otherwise.

##DISPLAY_DP1=DP-1
DISPLAY_DP1=DP-2
DISPLAY_HDMI1_SYSNAME=HDMI-A-1
DISPLAY_HDMI1=HDMI-1
DISPLAY_VGA1=VGA-1
DISPLAY_LAPTOP=LVDS-1

if [ `cat /sys/class/drm/card0-${DISPLAY_DP1}/status` = 'connected' ]; then
    echo "Setting preferred display to $DISPLAY_DP1."
    xrandr \
        --output $DISPLAY_DP1 --auto --primary \
        --output $DISPLAY_HDMI1 --off \
        --output $DISPLAY_VGA1 --off \
        --output $DISPLAY_LAPTOP --off
elif [ `cat /sys/class/drm/card0-${DISPLAY_HDMI1_SYSNAME}/status` = 'connected' ]; then
    echo "Setting preferred display to $DISPLAY_HDMI1."
    xrandr \
        --output $DISPLAY_DP1 --off \
        --output $DISPLAY_HDMI1 --auto --primary \
        --output $DISPLAY_VGA1 --off \
        --output $DISPLAY_LAPTOP --off
elif [ `cat /sys/class/drm/card0-${DISPLAY_VGA1}/status` = 'connected' ]; then
    echo "Setting preferred display to $DISPLAY_VGA1."
    xrandr \
        --output $DISPLAY_DP1 --off \
        --output $DISPLAY_HDMI1 --off \
        --output $DISPLAY_VGA1 --auto --primary \
        --output $DISPLAY_LAPTOP --off
else
    echo "Setting preferred display to $DISPLAY_LAPTOP."
    xrandr \
        --output $DISPLAY_DP1 --off \
        --output $DISPLAY_HDMI1 --off \
        --output $DISPLAY_VGA1 --off \
        --output $DISPLAY_LAPTOP --auto --primary
fi
