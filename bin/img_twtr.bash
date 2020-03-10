#!/usr/bin/env bash

## Modifies images so that they look better on Twitter.
## Copyright (C) 2018, Michiel Sikma <michiel@sikma.org>

# Images are duplicated with the top left pixel made slightly transparent.
# If all pixels are fully opaque, Twitter will convert it to a low quality JPG
# even if the source file is a high quality PNG. Adding transparency prevents that.
#
# If an image is small (640x480 or smaller) we will additionally upscale the image.
# This allows pixel art to be displayed nicely.
#
# ONLY .png files are modified. Other file types are ignored.
#
# This script can be run through Automator application, in which case it will
# receive a list of files and folders to operator on. Thus we expect the passed
# cli arguments to contain one or multiple string paths of files or folders.
# If a folder is given, we operate on all files inside.
#
# Images are re-saved with an underscore at the start of the name.
#
# Requires Imagemagick. It's on Brew: 'brew install imagemagick'
#
# usage: img_twtr.bash infile [infile [infile...]]

# Only operate on png files (for now).
declare -a valid_exts=("png")
# Display a warning if we can't process an item.
declare warn="img_twtr: warning:"
# Max. number of pixels to force 4x resizing.
declare resize4x="82500" # 330*250 (e.g. PSX screenshot, 330x240).
# Max. number of pixels to force 2x resizing.
declare resize2x="480000" # 800x600

# Attempt to run pathhelper. This ensures we should have the same setup
# as a blank Bash terminal window. Important when using Automator.
if [ -x /usr/libexec/path_helper ]; then eval `/usr/libexec/path_helper -s`; fi

## Makes a copy of a file with modifications to prevent quality degradation on Twitter.
## Files will be copied from $orig to $dupe and possibly resized as well.
## This is called by process_item after checking if the item is likely processable.
function twtr_fix_file {
  local orig="$1" # '/Users/msikma/Desktop/file.png' which exists
  local dupe="$2" # '/Users/msikma/Desktop/_file.png' which does not exist yet

  # Now, using $orig, create the fixed version and save it as $dupe.
  # First we'll check if the image needs to be resized. If it's particularly small
  # we will resize it 4x. In some cases 2x. If it's larger, it won't be resized at all.
  # Either we make the new filename with the resize command, and then add the transparent pixel
  # or we simply copy the file to its new location and then add it.

  # Check for resizing.
  local size="$(get_img_px "$orig")"
  echo -n "Processing: "
  if [ "$size" -le "$resize4x" ]; then
    echo -n "4x; "
    resize_img "$orig" "$dupe" "400"
  elif [ "$size" -le "$resize2x" ]; then
    echo -n "2x; "
    resize_img "$orig" "$dupe" "200"
  else
    echo -n "    "
    cp "$orig" "$dupe"
  fi

  # Now we've got the either resized or exact duplicate in $dupe.
  # Modify its top left pixel to force transparency.
  add_trns_px "$dupe" "$dupe"
  echo "$dupe"
}

## Copies $inline to $outfile, while making the top left pixel 99% transparent.
## Essentially keeps an image unchanged if the pixel is already slightly transparent.
function add_trns_px {
  local infile="$1"
  local outfile="$2"
  magick "$infile" -alpha Set -region 1x1+0+0 -channel A -evaluate Multiply 0.99 +channel +region "$outfile"
}

## Resizes an image $infile by a certain percentage value (200 or 400) and saves it to $outfile.
function resize_img {
  local infile="$1"
  local outfile="$2"
  local perc="$3"
  convert "$infile" -interpolate Nearest -filter point -resize "$perc"% "$outfile"
}

## Returns the number of pixels in an image file (width * height).
## The printf() statement ensures we convert scientific notation into decimal notation,
## e.g. '1.2672e+06' to '1267200'.
function get_img_px {
  convert "$1" -ping -format "%[fx:w*h]" info:  | xargs printf "%0.0f"
}

## Processes a single file or directory path.
function process_item {
  # Run process on directory if this is one.
  if [ -d "$1" ]; then
    process_directory "$1"
    return
  fi

  # Extract filename information and determine new name.
  local ext="${1##*.}"
  local base="${1%.*}"

  # Ignore if extension is invalid or if file does not exist.
  if [[ ! " ${valid_exts[@]} " =~ " ${ext} " ]] || \
     [[ ! -f "$1" && ! -d "$1" ]]; then
    return
  fi

  # Generate the new filename.
  local basename="${base##*\/}"
  local basedir=$(dirname "$base")
  local nbase=$(twtr_new_name "$basedir" "$basename")

  # If we couldn't find a new name, error out for this item.
  if [ -z "$nbase" ]; then
    echo "$warn Could not find suitable new filename: $1"
    return
  fi

  # We now know we can (probably) process the file. Run the conversion code,
  # giving it the original filename and the new filename.
  local orig="$1"
  local dupe="$nbase.$ext"

  twtr_fix_file "$orig" "$dupe"
}

## Determines the new filename for the replacement file.
## Adds an underscore to the source file's filename. If another file already exists
## with that name, it will just add more underscores until it finds a free spot.
function twtr_new_name {
  local basedir="$1"  # '/Users/msikma/Desktop'
  local basename="$2" # 'file'
  local newname=""

  local i="1"
  while [ $i -lt 32 ]; do
    newname="$basedir/$(printf '_%.0s' $(seq 1 $i))$basename"
    if [[ ! -f "$newname" && ! -d "$newname" ]]; then
      echo "$newname"
      return
    fi
    i=$[$i+1]
  done
  return 1
}

## Runs process_item on all files inside a directory.
function process_directory {
  find "$1" -type f | while read f; do
    process_item "$f"
  done
}

for f in "$@"; do
  # e.g. $f becomes '/Users/msikma/Desktop/image.png'.
  process_item "$f"
done

