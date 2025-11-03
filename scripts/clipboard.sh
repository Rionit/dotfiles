#!/bin/bash
# Open fzf with cliphist, copy selection to clipboard
cliphist list | fzf --no-sort --preview 'cliphist decode {1}' | cliphist decode | wl-copy

# THANK YOU!!! normal exit just didn't work, this kills even the parent kitty
# https://askubuntu.com/questions/611648/exit-terminal-after-running-a-bash-script#:~:text=of%20your%20script%3A-,kill%20%2D9%20%24PPID,-This%20will%20send
kill -9 $PPID
