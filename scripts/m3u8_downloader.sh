#!/bin/bash

# Simple m3u8 downloader using ffmpeg
# Works on Arch Linux (requires ffmpeg installed)

echo -n "Enter m3u8 link: "
read link

if [[ -z "$link" ]]; then
    echo "Error: No link provided."
    exit 1
fi

echo -n "Enter output filename (without extension): "
read filename

if [[ -z "$filename" ]]; then
    echo "Error: No filename provided."
    exit 1
fi

# Run ffmpeg
ffmpeg -i "$link" -bsf:a aac_adtstoasc -vcodec copy -c copy -crf 50 "${filename}.mp4"

