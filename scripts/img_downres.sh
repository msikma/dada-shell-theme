#!/usr/bin/env bash

declare PROJECT="@msikma/img_downres"
declare DESCRIPTION="Script for downscaling images (to prepare for .cbz files, for example)"
declare SELF="img_downres.sh"
declare VERSION="1.0.0"

declare -a valid=("jpg" "jpeg")
declare search_ext="*.jpg"
declare quality="88"

## Checks whether all prerequisites are installed.
function check_prerequisites {
  arr=('magick')
  for tool in "${arr[@]}"; do
    if ! command -v $tool >/dev/null 2>&1; then
      echo "$SELF: error: the '$tool' command is not available"
      exit
    fi
  done
}

## Processes a directory.
function process_dir {
  local res_src="$1"
  local res_dst="$2"
  local target="$3"
  find "$target" \( -iname "$search_ext" \) -maxdepth 1 | while read f; do
    process_item "$res_src" "$res_dst" "$f"
  done
}

## Processes a single file. If a directory is passed, files are iterated over.
function process_item {
  local res_src="$1"
  local res_dst="$2"
  local target="$3"

  if [ -d "$target" ]; then
    process_dir "$res_src" "$res_dst" "$target"
    return
  fi

  # Ignore if extension is invalid or if file does not exist.
  local ext="${target##*.}"
  if ! [[ " ${valid[@]} " =~ " ${ext} " ]] && \
       [[ -f "$target" || -d "$target" ]]; then
    return
  fi

  local scale="$(awk "BEGIN {print ($res_dst/$res_src)*100}")"
  local fn_base="${target%.*}"
  local fn_ext="${target##*.}"
  local fn_new="$fn_base""_res"$res_dst".$fn_ext"
  magick convert "$target" -filter Cubic -resize "$scale"% -quality $quality -density "$res_dst" "$fn_new"
}

## Parses arguments passed to the script and errors out if they're incorrect.
function argparse {
  if [ "$1" == "-v" ]; then
    echo "$PROJECT-$VERSION"
    exit
  fi
  if [[ ( -z "$1" ) || ( -z "$2" ) || ( -z "$3" ) || ( "$1" == "-h" ) ]]; then
    echo "usage: $SELF [-v] [-h] src_res dst_res [files...]"
    if [ "$1" == "-h" ]; then
      echo "$DESCRIPTION"
      exit 0
    fi
    exit 1
  fi

  check_prerequisites
  for f in "${@:3}"; do
    process_item "$1" "$2" "$f"
  done
}

if [[ "${BASH_SOURCE[0]}" = "${0}" ]]; then
  argparse "$@"
fi
