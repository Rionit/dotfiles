#!/bin/bash
# hi :3

# Start first terminal
kitty --class basic-term &
sleep 0.2

# Start second terminal
kitty --class pipes -e pipes.sh &
sleep 0.2

# Start third terminal
kitty --class bonsai -e cbonsai -l &
sleep 0.2

# Start fourth terminal
kitty --class fastfetch -e sh -c "fastfetch; exec bash" &
