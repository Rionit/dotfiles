#!/bin/bash

# Set output filename
filename="$HOME/screenshots/screenshot-$(date +%s).png"

# Check args
case "$1" in
    selection)
        grim -g "$(slurp)" - | tee "$filename" | wl-copy --type image/png
        ;;
    fullscreen)
        grim - | tee "$filename" | wl-copy --type image/png
        ;;
    *)
        echo "Usage: $0 [selection|fullscreen]"
        exit 1
        ;;
esac
