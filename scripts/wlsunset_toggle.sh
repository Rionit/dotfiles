#!/bin/bash
# Toggle wlsunset on/off
 
LAT="50.08"
LON="14.44"

if pgrep -x wlsunset > /dev/null; then
    pkill wlsunset
    notify-send "wlsunset stopped"
else
    wlsunset -l "$LAT" -L "$LON" &
    notify-send "wlsunset started"
fi

