#!/bin/bash

# Set screenshot directory
SCREENSHOT_DIR="$HOME/screenshots"
mkdir -p "$SCREENSHOT_DIR"

# Set output filename
FILENAME="$SCREENSHOT_DIR/screenshot-$(date +%s).png"

# Take screenshot based on argument
case "$1" in
    selection)
        grim -g "$(slurp)" - | tee "$FILENAME" | wl-copy --type image/png
        ;;
    fullscreen)
        grim - | tee "$FILENAME" | wl-copy --type image/png
        ;;
    *)
        echo "Usage: $0 [selection|fullscreen]"
        exit 1
        ;;
esac

# Send notification with "View Screenshot" action
DUNST_ACTION=$(dunstify -a screenshot -i "$FILENAME" -A "view,View Screenshot" Screenshot "New screenshot taken")

# Handle action if user clicks "View"
case "$DUNST_ACTION" in
    view)
        # Use an image viewer compatible with Wayland, e.g., swayimg or sxiv
        swappy -f "$FILENAME"
        ;;
esac

