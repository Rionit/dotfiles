#!/bin/bash

# Base path to your mounted Jellyfin Samba folder
BASE_PATH="/mnt/smb-media/music"

# Prompt for playlist URL
read -p "Enter the YouTube playlist URL: " PLAYLIST_URL

# Prompt for artist and album
read -p "Enter the artist name: " ARTIST
read -p "Enter the album name (leave empty to use playlist title): " ALBUM

# Temporary directory to fetch playlist info
TMP_DIR=$(mktemp -d)

# Fetch playlist title if album not provided
if [ -z "$ALBUM" ]; then
    ALBUM=$(yt-dlp --get-title --flat-playlist "$PLAYLIST_URL" | head -n 1)
fi

# Sanitize folder names (replace / with -)
SAFE_ARTIST="${ARTIST//\//-}"
SAFE_ALBUM="${ALBUM//\//-}"

# Create destination directory
DEST_DIR="$BASE_PATH/$SAFE_ARTIST/$SAFE_ALBUM"
mkdir -p "$DEST_DIR"

# Download playlist with numbered tracks
yt-dlp -x --audio-format mp3 -o "$DEST_DIR/%(playlist_index)02d - %(title)s.%(ext)s" "$PLAYLIST_URL"

# Cleanup
rm -rf "$TMP_DIR"

echo "Download complete! Files are in $DEST_DIR"

