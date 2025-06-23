#!/bin/bash

# list of cows
custom_cows=("actually" "alpaca" "default" "blowfish" "bong" "bud-frogs" "bunny" "cower" "elephant" "elephant-in-snake" "eyes" "flaming-sheep" "hellokitty" "koala" "kosh" "llama" "luke-koala" "moofasa" "moose" "mutilated" "sheep" "skeleton" "small" "supermilker" "sus" "three-eyes" "tux" "udder" "vader" "vader-koala" "www")

# Pick a random cow
random_cow=${custom_cows[$RANDOM % ${#custom_cows[@]}]}

# 50% chance to use lolcat
if (( RANDOM % 2 == 0 )); then
    fortune -s | cowsay -f "$random_cow" | lolcat
else
    fortune -s | cowsay -f "$random_cow"
fi
