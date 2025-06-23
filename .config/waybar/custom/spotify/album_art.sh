#!/bin/bash
album_art=$(playerctl -p spotify metadata mpris:artUrl)
if [[ -z $album_art ]]
then
    # spotify dead, we should die too
    exit
fi
curl -s "${album_art}" --output "/tmp/cover.jpeg"
echo "/tmp/cover.jpeg"