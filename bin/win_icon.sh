#!/usr/bin/env fish

function make_icon --argument-names filepath
  set base (echo "$filepath" | strip_ext)
  magick "$filepath" -background none \
    \( -clone 0 -resize 16x16 -extent 16x16 \) \
    \( -clone 0 -resize 32x32 -extent 32x32 \) \
    \( -clone 0 -resize 48x48 -extent 48x48 \) \
    \( -clone 0 -resize 64x64 -extent 64x64 \) \
    -delete 0 -alpha on "$base".ico
end

function args
  set usage "usage: win_icon.sh [--help] file"
  set dry_run "0"
  set files
  for arg in $argv
    if [ (string match -r '^-h$|^--help$' -- "$arg") ]
      echo "$usage"
      echo
      echo "Creates Windows icons from .png files."
      return
    end
    if [ ! (string match -r '^--' -- "$arg") ]
      set -a files "$arg"
    end
  end
  
  if ! set -q "files[1]"
    echo "$usage"
    return 1
  end
  for file in $files
    make_icon "$file"
  end
end

args $argv
