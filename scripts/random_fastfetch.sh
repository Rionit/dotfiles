#!/usr/bin/env bash

FASTFETCH="$HOME/.config/fastfetch"

commands=(
"kitten icat -n --place 40x40@13x3 --align left $FASTFETCH/sisyphus-loop.gif | fastfetch --logo-width 60 --raw -"

"kitten icat -n --place 40x40@13x3 --align left $FASTFETCH/chair-guys-loop.gif | fastfetch --logo-width 60 --raw -"

"kitten icat -n --place 40x40@13x3 --align left $FASTFETCH/wizard-loop.gif | fastfetch --logo-width 60 --raw -"
)

# Choose a random index
index=$((RANDOM % ${#commands[@]}))

# Execute the chosen command
eval "${commands[$index]}"
