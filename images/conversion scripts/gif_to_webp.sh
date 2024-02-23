#!/bin/bash

# Define the base directory where the GIF images are located
BASEDIR="/Users/alien/Pictures/images"

# Target directories for converted WebP files
TARGETDIR_LOSSLESS="/Users/alien/Pictures/images/target_webp_gif_lossless"
TARGETDIR_LOSSY="/Users/alien/Pictures/images/target_webp_gif_lossy"

# Create target directories if they don't exist
mkdir -p "$TARGETDIR_LOSSLESS"
mkdir -p "$TARGETDIR_LOSSY"

# Loop through all GIF files in the directory
for file in "$BASEDIR"/*.gif; do
  base_name=$(basename "$file" .gif)

  # Convert GIF images to lossless WebP
  ffmpeg -i "$file" -vcodec libwebp -lossless 1 "$TARGETDIR_LOSSLESS/${base_name}_lossless.webp"

  # Convert GIF images to lossy WebP
  # Adjust the quality factor (-qscale) as needed for desired compression
  ffmpeg -i "$file" -vcodec libwebp -qscale 50 "$TARGETDIR_LOSSY/${base_name}_lossy.webp"
done
