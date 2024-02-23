#!/bin/bash

# Define the base directory where the JPEG and PNG images are located
BASEDIR="/Users/alien/Pictures/images"

# Target directories for converted WebP files
TARGETDIR_JPEG_LOSSLESS="/Users/alien/Pictures/images/target_webp_jpeg_lossless"
TARGETDIR_JPEG_LOSSY="/Users/alien/Pictures/images/target_webp_jpeg_lossy"
TARGETDIR_PNG_LOSSLESS="/Users/alien/Pictures/images/target_webp_png_lossless"

# Create target directories if they don't exist
mkdir -p "$TARGETDIR_JPEG_LOSSLESS"
mkdir -p "$TARGETDIR_JPEG_LOSSY"
mkdir -p "$TARGETDIR_PNG_LOSSLESS"

# Loop through all JPEG and PNG files in the directory
for file in "$BASEDIR"/*.jpg "$BASEDIR"/*.jpeg "$BASEDIR"/*.png; do
  base_name=$(basename "$file")
  file_extension="${base_name##*.}"
  base_name_noext="${base_name%.*}"

  # Handle JPEG files
  if [[ "$file_extension" == "jpg" || "$file_extension" == "jpeg" ]]; then
    # Convert to lossless WebP and store in the JPEG lossless folder
    ffmpeg -i "$file" -vcodec libwebp -pix_fmt rgb24 -lossless 1 "$TARGETDIR_JPEG_LOSSLESS/${base_name_noext}_lossless.webp"
    # Convert to lossy WebP and store in the JPEG lossy folder
    ffmpeg -i "$file" -vcodec libwebp -pix_fmt yuv420p -compression_level 6 -qscale 80 "$TARGETDIR_JPEG_LOSSY/${base_name_noext}_lossy.webp"
  fi

  # Handle PNG files
  if [ "$file_extension" == "png" ]; then
    # Convert to lossless WebP and store in the PNG lossless folder
    ffmpeg -i "$file" -vcodec libwebp -lossless 1 "$TARGETDIR_PNG_LOSSLESS/${base_name_noext}_lossless.webp"
  fi
done


