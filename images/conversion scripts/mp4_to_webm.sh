#!/bin/bash

# Define the base directory where the MP4 files are located
BASEDIR="/Users/alien/Pictures/images"

# Target directories for converted WebM files
TARGETDIR_LOSSLESS="/Users/alien/Pictures/images/target_webm_lossless"
TARGETDIR_LOSSY="/Users/alien/Pictures/images/target_webm_lossy"

# Create target directories if they don't exist
mkdir -p "$TARGETDIR_LOSSLESS"
mkdir -p "$TARGETDIR_LOSSY"

# Loop through all MP4 files in the directory
for file in "$BASEDIR"/*.mp4; do
  base_name=$(basename "$file" .mp4)

  # Get original width of the video
  orig_width=$(ffprobe -v error -select_streams v:0 -show_entries stream=width -of csv=p=0 "$file")

  # Calculate the new width based on percentage
  if [ "$orig_width" -gt 1080 ]; then
    new_width=$((orig_width * 80 / 100)) # 20% reduction for videos over 1080p
  else
    new_width=$orig_width
  fi

  # Convert to lossless WebM
  ffmpeg -i "$file" -c:v libvpx-vp9 -lossless 1 "$TARGETDIR_LOSSLESS/${base_name}_lossless.webm"

  # Convert to lossy WebM with scaled width
  ffmpeg -i "$file" -vf "scale=${new_width}:-1" -c:v libvpx-vp9 -b:v 1M "$TARGETDIR_LOSSY/${base_name}_lossy.webm"
done
