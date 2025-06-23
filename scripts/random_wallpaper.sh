#!/usr/bin/env bash

WALLPAPER_DIR="$HOME/wallpapers"
COLORSCHEME_DIR="$HOME/wallpaper_schemes"
WAYBAR_CSS="$HOME/.config/waybar/style.css"
WAYBAR_TEMPLATE="$HOME/.config/waybar/style-base.css"

# Get current wallpaper (if any)
CURRENT_WALL=$(hyprctl hyprpaper listloaded | grep -E '\.(jpg|png)$' | head -n1)
CURRENT_NAME=$(basename "$CURRENT_WALL")

# Pick a new wallpaper at random (not same as current)
WALLPAPER=$(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.png" \) ! -name "$CURRENT_NAME" | shuf -n 1)
BASENAME=$(basename "$WALLPAPER")
SCHEME_FILE="$COLORSCHEME_DIR/$BASENAME.json"

# Load wallpaper
hyprctl hyprpaper unload all
hyprctl hyprpaper preload "$WALLPAPER"
MONITOR=$(hyprctl monitors | grep Monitor | awk '{print $2}')
hyprctl hyprpaper wallpaper "$MONITOR,$WALLPAPER"

# Load colors
if [[ -f "$SCHEME_FILE" ]]; then
    BG=$(jq -r .bg "$SCHEME_FILE")
    FG=$(jq -r .fg "$SCHEME_FILE")
    PRIMARY=$(jq -r .primary "$SCHEME_FILE")
    SECONDARY=$(jq -r .secondary "$SCHEME_FILE")
    ACCENT=$(jq -r .accent "$SCHEME_FILE")

    sed -e "s|@define-color bg .*|@define-color bg $BG;|" \
        -e "s|@define-color fg .*|@define-color fg $FG;|" \
        -e "s|@define-color primary .*|@define-color primary $PRIMARY;|" \
        -e "s|@define-color secondary .*|@define-color secondary $SECONDARY;|" \
        -e "s|@define-color accent .*|@define-color accent $ACCENT;|" \
        "$WAYBAR_TEMPLATE" > "$WAYBAR_CSS"

    # Reload Waybar
    pkill -SIGUSR2 waybar
else
    echo "⚠️ No matching color scheme for $BASENAME"
fi
