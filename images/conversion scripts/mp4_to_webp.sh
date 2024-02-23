#!/bin/bash

# Define the base directory where the MP4 files are located
BASEDIR="/Users/alien/Pictures/images"

# Target directories for converted WebP files
TARGETDIR_LOSSLESS="/Users/alien/Pictures/images/target_webp_mp4_lossless"
TARGETDIR_LOSSY="/Users/alien/Pictures/images/target_webp_mp4_lossy"

# Create target directories if they don't exist
mkdir -p "$TARGETDIR_LOSSLESS"
mkdir -p "$TARGETDIR_LOSSY"

# Loop through all MP4 files in the directory
for file in "$BASEDIR"/*.mp4; do
  base_name=$(basename "$file" .mp4)

  # Get original width of the video
  orig_width=$(ffprobe -v error -select_streams v:0 -show_entries stream=width -of csv=p=0 "$file")

  # Calculate the new width for lossy conversion based on percentage
  if [ "$orig_width" -gt 1080 ]; then
    new_width=$((orig_width * 50 / 100)) # 50% reduction for videos over 1080p
  elif [ "$orig_width" -gt 720 ]; then
    new_width=$((orig_width * 60 / 100)) # 40% reduction for videos over 720p
  elif [ "$orig_width" -gt 480 ]; then
    new_width=$((orig_width * 70 / 100)) # 30% reduction for videos over 480p
  elif [ "$orig_width" -gt 360 ]; then
    new_width=$((orig_width * 80 / 100)) # 20% reduction for videos over 360p
  else
    new_width=$((orig_width * 90 / 100)) # 10% reduction for smaller videos
  fi

  # Convert to lossless WebP and store in lossless folder
  ffmpeg -i "$file" -vcodec libwebp -vf "fps=10,scale=${orig_width}:-1" -lossless 1 -loop 0 "$TARGETDIR_LOSSLESS/${base_name}_lossless.webp"

  # Convert to lossy WebP with scaled width and store in lossy folder
  ffmpeg -i "$file" -vcodec libwebp -vf "fps=10,scale=${new_width}:-1" -compression_level 6 -quality 80 -loop 0 "$TARGETDIR_LOSSY/${base_name}_lossy.webp"
done

  fi

  # Convert to lossless WebP
  ffmpeg -i "$file" -vcodec libwebp -vf "fps=10,scale=${orig_width}:-1" -lossless 1 -loop 0 "$TARGETDIR/${base_name}_lossless.webp"

  # Convert to compressed WebP with scaled width
  ffmpeg -i "$file" -vcodec libwebp -vf "fps=10,scale=${new_width}:-1" -compression_level 6 -quality 80 -loop 0 "$TARGETDIR/${base_name}_compressed.webp"
done