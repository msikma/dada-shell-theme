#!/usr/bin/env bash

SRC_DIRS=("/Users/$(whoami)/Projects" "/Users/$(whoami)/Client projects" "/Users/$(whoami)/Source")
DEST_DIRS=("/Volumes/Files/Backups/$dada_hostname/Projects" "/Volumes/Files/Backups/$dada_hostname/Client projects" "/Volumes/Files/Backups/$dada_hostname/Source")
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
WORK_DIR=`mktemp -d`

err="backup-src: Error:"

RED="\E[31m$3"
YELLOW="\E[33m$3"
CYAN="\E[36m$3"
GREEN="\E[32m$3"
NORMAL="\E[0m$3"

function cleanup {
  rm -rf "$WORK_DIR"
  cd "$DIR"
  echo "Deleted temp working directory: $WORK_DIR"
  echo
}

# Ensure we always clean up.
trap cleanup EXIT

if [ -z ${dada_hostname+x} ]; then
  echo "$err \$dada_hostname is not set"
  exit 1
fi

# Check whether our directories exist.
for ((a = 0; a < ${#SRC_DIRS[@]}; a++)); do
  src="${SRC_DIRS[a]}"
  dest="${DEST_DIRS[a]}"
  if [[ ! "$src" || ! -d "$src" ]]; then
    echo "$err Could not access source directory: $src"
    exit 1
  fi
  if [[ ! "$dest" || ! -d "$dest" ]]; then
    echo "$err Could not access destination directory: $dest"
    exit 1
  fi
done

# Create a temporary directory to store our zip files in.
if [[ ! "$WORK_DIR" || ! -d "$WORK_DIR" ]]; then
  echo "$err Could not create temp directory: $WORK_DIR"
  exit 1
fi

# Now run the backup script.
echo
echo -e $GREEN"Projects backup script running on "$RED$dada_hostname$NORMAL
echo
for ((a = 0; a < ${#SRC_DIRS[@]}; a++)); do
  src="${SRC_DIRS[a]}"
  dest="${DEST_DIRS[a]}"
  dest_c=$YELLOW$(echo -e ${dest//$dada_hostname/$RED$dada_hostname$YELLOW})
  echo -e $CYAN"Backing up directory ($((a+1))/${#SRC_DIRS[@]}): $GREEN$src$NORMAL"
  echo -e $YELLOW"Copying to: "$dest_c$NORMAL

  for b in "$src/"*; do
    base="${b##*/}"
    zipf="$base.zip"
    tmp="$WORK_DIR/$zipf"
    zipdest="$dest/$zipf"

    if [ -d "$b" ]; then
      cd "$src"
      zip -r9q "$tmp" "$base" -x "$base/"node_modules/**\*
      fs=`stat -f%z "$tmp"`

      if [[ "$zipdest" && -f "$zipdest" ]]; then
        # If the destination file exists, check if the new zip file has a different size.
        # Copy over the file if that's the case.
        oldstat=`stat -f%z "$tmp"`
        newstat=`stat -f%z "$zipdest"`
        if [[ "$oldstat" -ne "$newstat" ]]; then
          cp "$tmp" "$zipdest"
          echo "@ Updated: $base"
        else
          echo "- No need to update: $base"
        fi
        # Remove our temporary file.
        rm "$tmp"

      else
        # If not, copy it over right away.
        cp "$tmp" "$zipdest"
        echo "+ New backup: $base"
      fi
    fi
  done
done

mkdir -p ~/.cache/dada
echo `date +"%a, %b %d %Y %X %z"` > ~/.cache/dada/backup-src
