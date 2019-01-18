#!/usr/bin/env bash

## Encodes a WAV file to FLAC using maximum compression.
## Copyright (C) 2018, Michiel Sikma <michiel@sikma.org>

# Don't operate on FLAC files.
declare -a invalid=("flac")
# Path to FLAC encoder.
declare flaccmd="flac"

# Attempt to run pathhelper. This ensures we should have the same setup
# as a blank Bash terminal window. Important when using Automator.
if [ -x /usr/libexec/path_helper ]; then eval `/usr/libexec/path_helper -s`; fi

## Processes a single file or directory path.
function process_item {
  # Run process on directory if this is one.
  if [ -d "$1" ]; then
    process_directory "$1"
    return
  fi

  # Ignore if extension is invalid or if file does not exist.
  local ext="${1##*.}"
  if [[ " ${invalid[@]} " =~ " ${ext} " ]] || \
     [[ ! -f "$1" && ! -d "$1" ]]; then
    return
  fi

  echo -n "$(basename "$1 ")"
  $flaccmd --best --replay-gain --preserve-modtime "$1" 2> /dev/null
}

## Runs process_item on all files inside a directory.
function process_directory {
  find "$1" -type f | while read f; do
    process_item "$f"
  done
}

echo "-"
echo "$@"
echo "="
for f in "$@"; do
  # e.g. $f becomes '/Users/msikma/Desktop/file.wav'.
  process_item "$f"
done

