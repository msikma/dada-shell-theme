#!/usr/bin/env fish

function strip_ext
  echo (string split -r -m1 . $argv[1])[1]
end

function merge_vids
  # Use a temp directory to work in.
  set mergedir (mktemp -d)
  set files (realpath $argv | sort -z)
  set -l ts_files
  set orig (pwd)
  
  pushd "$mergedir"
  for n in $files
    # Sort apparently adds an extra line. Not sure how to remove it.
    if [ "$n" = "" ]; continue; end
    
    set ts (strip_ext (basename "$n"))".ts"
    set -a ts_files "$ts"
    ffmpeg -i "$n" -c copy -bsf:v h264_mp4toannexb -f mpegts "./$ts"
  end
  
  set out (basename (mktemp))
  set ts_files (string join '|' $ts_files)
  ffmpeg -i "concat:$ts_files" -c copy -bsf:a aac_adtstoasc "$out".mp4
  mv "$out".mp4 "$orig"
  popd
  
  echo "$orig"
  
  rm -rf $mergedir
end

function args
  set usage "usage: merge_vids.sh [--help] files"
  for arg in $argv
    if [ (string match -r '^-h$|^--help$' -- "$arg") ]
      echo "$usage"
      echo
      echo "Converts multiple video files into a single .mp4 file."
      echo "Uses source copy; files must be bytestream compatible."
      return
    end
  end
  if [ (count $argv) -eq 0 ]
    echo "$usage"
    return 1
  end
  
  merge_vids $argv
end

args $argv
