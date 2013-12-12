#!/bin/bash

SCREEN_WIDTH=1140
PERCENTAGE=70

MAX_WIDTH=$(($SCREEN_WIDTH*$PERCENTAGE/100))

for i in *; do
    [[ "$0" == "$i" ]] && continue
    width=$(identify -verbose $i|grep Geom|awk '{print $2}'|cut -dx -f1)
    if [ "$width" -gt "1140" ]; then
        mogrify -resize ${MAX_WIDTH}x${MAX_WIDTH} $i
    fi
done
