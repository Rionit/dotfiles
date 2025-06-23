#!/usr/bin/env bash

WALLPAPER_DIR="$HOME/wallpapers"
COLORSCHEME_DIR="$HOME/wallpaper_schemes"
WAYBAR_CSS="$HOME/.config/waybar/style.css"
WAYBAR_TEMPLATE="$HOME/.config/waybar/style-base.css"
HYPRLAND_CONF="$HOME/.config/hypr/hyprland.conf"
DUNST_CONF="$HOME/.config/dunst/dunstrc"
WOFI_TEMPLATE="$HOME/.config/wofi/style-base.css"
WOFI_STYLE="$HOME/.config/wofi/style.css"
KITTY_TEMPLATE="$HOME/.config/kitty/kitty.conf.template"
KITTY_CONF="$HOME/.config/kitty/kitty.conf"
COLORSCHEME_TEMPLATE="$HOME/.config/color-schemes/WallpaperScheme-base.colors"
COLORSCHEME_FILE="$HOME/.config/color-schemes/WallpaperScheme.colors"
HYPRLOCK_CONF="$HOME/.config/hypr/hyprlock.conf"

# Get current wallpaper (if any)
CURRENT_WALL=$(hyprctl hyprpaper listloaded | grep -E '\.(jpg|png)$' | head -n1)
CURRENT_NAME=$(basename "$CURRENT_WALL")

# Function to apply wallpaper and style
apply_wallpaper() {
    local wallpaper="$1"
    local basename=$(basename "$wallpaper")
    local scheme_file="$COLORSCHEME_DIR/$basename.json"

    # Load wallpaper
    hyprctl hyprpaper unload all
    hyprctl hyprpaper preload "$wallpaper"
    MONITOR=$(hyprctl monitors | grep Monitor | awk '{print $2}')
    hyprctl hyprpaper wallpaper "$MONITOR,$wallpaper"

    # Apply color scheme
    if [[ -f "$scheme_file" ]]; then
        BG=$(jq -r .bg "$scheme_file")
        FG=$(jq -r .fg "$scheme_file")
        PRIMARY=$(jq -r .primary "$scheme_file")
        SECONDARY=$(jq -r .secondary "$scheme_file")
        ACCENT=$(jq -r .accent "$scheme_file")

        # Hyprland window border color
        sed -i -E "s|(col.active_border = ).*# AUTOGEN_BORDER|\1rgb(${PRIMARY#\#}) rgb(${ACCENT#\#}) 45deg  # AUTOGEN_BORDER|" "$HYPRLAND_CONF"
        hyprctl reload

        # Dunst colors
        echo "Writing to $DUNST_CONF" 
        sed -i -E "s|^\s*background\s*=.*|background = \"$BG\"|" "$DUNST_CONF"
        sed -i -E "s|^\s*foreground\s*=.*|foreground = \"$FG\"|" "$DUNST_CONF"
        sed -i -E "s|^\s*frame_color\s*=.*|frame_color = \"$PRIMARY\"|" "$DUNST_CONF"
        pkill dunst && dunst &

        # Wofi
        sed -e "s|\$BG|$BG|g" \
            -e "s|\$FG|$FG|g" \
            -e "s|\$PRIMARY|$PRIMARY|g" \
            -e "s|\$ACCENT|$ACCENT|g" \
            "$WOFI_TEMPLATE" > "$WOFI_STYLE"

        # Kitty
        sed -e "s|\$BG|$BG|g" \
            -e "s|\$FG|$FG|g" \
            -e "s|\$PRIMARY|$PRIMARY|g" \
            -e "s|\$SECONDARY|$SECONDARY|g" \
            -e "s|\$ACCENT|$ACCENT|g" \
            "$KITTY_TEMPLATE" > "$KITTY_CONF"
        kitty @ set-colors --all --config "$KITTY_CONF"

        # Hyprlock
        # sed -i -E \
        #    -e "s|^(\\s*background\\s*=).*|\1 $wallpaper|" \
        #    -e "s|^(\\s*color\\s*=).*|\\1 rgba(${FG#\#}dd)|" \
        #    -e "s|^(\\s*indicator\\s*\\{[^}]*color\\s*=).*|\\1 rgba(${PRIMARY#\#}cc)|" \
        #    -e "s|^(\\s*indicator\\s*\\{[^}]*wrong_color\\s*=).*|\\1 rgba(${ACCENT#\#}cc)|" \
        #    "$HYPRLOCK_CONF"
        # pkill -SIGUSR2 hyprlock

        # Dolphin
        sed -e "s|\$BG|$BG|g" \
            -e "s|\$FG|$FG|g" \
            -e "s|\$PRIMARY|$PRIMARY|g" \
            -e "s|\$SECONDARY|$SECONDARY|g" \
            -e "s|\$ACCENT|$ACCENT|g" \
            "$COLORSCHEME_TEMPLATE" > "$COLORSCHEME_FILE"

        # Waybar
        sed -e "s|@define-color bg .*|@define-color bg $BG;|" \
            -e "s|@define-color fg .*|@define-color fg $FG;|" \
            -e "s|@define-color primary .*|@define-color primary $PRIMARY;|" \
            -e "s|@define-color secondary .*|@define-color secondary $SECONDARY;|" \
            -e "s|@define-color accent .*|@define-color accent $ACCENT;|" \
            "$WAYBAR_TEMPLATE" > "$WAYBAR_CSS"

        pkill -SIGUSR2 waybar

        
    else
        echo "⚠️ No matching color scheme for $basename"
    fi
}

# Get wallpaper list
wallpapers=$(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.png" \) | sort)

# Mode: random or manual (default)
mode="${1:-manual}"

if [[ "$mode" == "random" ]]; then
    wallpaper=$(echo "$wallpapers" | grep -v "$CURRENT_NAME" | shuf -n 1)
    apply_wallpaper "$wallpaper"
else
    choices=$(echo -e "random Wallpaper  \n$wallpapers")
    selection=$(echo "$choices" | wofi --dmenu --prompt "Choose Wallpaper")

    [[ -z "$selection" ]] && exit

    if [[ "$selection" == "random Wallpaper  " ]]; then
        wallpaper=$(echo "$wallpapers" | grep -v "$CURRENT_NAME" | shuf -n 1)
    else
        wallpaper="$selection"
    fi

    apply_wallpaper "$wallpaper"
fi
