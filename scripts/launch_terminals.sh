#!/bin/bash
# hi :3

# Start first terminal
FISH_MOO=1 exec kitty --class basic-term &
sleep 0.2

# Start second terminal
kitty --class pipes -e pipes.sh &
sleep 0.2

# Start third terminal
kitty --class bonsai -e cbonsai -l &
sleep 0.2

# Start fourth terminal
kitty --class fastfetch -e fish -c "fastfetch; exec fish" &
