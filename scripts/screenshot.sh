#!/bin/bash

# Set output filename
filename="$HOME/screenshots/screenshot-$(date +%s).png"

# Check args
case "$1" in
    selection)
        grim -g "$(slurp)" "$filename"
        ;;
    fullscreen)
        grim "$filename"
        ;;
    *)
        echo "Usage: $0 [selection|fullscreen]"
        exit 1
        ;;
esac