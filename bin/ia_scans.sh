#!/usr/bin/env bash

PROJECT="ia_imgs"
DESCRIPTION="Prints an Internet Archive item's description with a table of scans."
SELF="ia_imgs.sh"
VERSION="1.0.0"
PREREQUISITES=('ia')

function check_prerequisites {
  for tool in "${PREREQUISITES[@]}"; do
    if ! command -v $tool >/dev/null 2>&1; then
      echo "$SELF: error: the '$tool' command is not available"
      exit
    fi
  done
}

function print_desc {
  ia metadata "$1" | jq '.metadata.description'
}

function print_desc_with_images {
  desc=$(print_desc "$1")
  echo $desc
  echo 'TODO'
}

function argparse {
  if [[ ( -z "$1" ) || ( "$1" == "-h" ) ]]; then
    echo "usage: $SELF [-v] [-h] descriptor"
    if [ "$1" == "-h" ]; then
      echo "$DESCRIPTION"
      exit 0
    fi
    exit 1
  fi
  if [ "$1" == "-v" ]; then
    echo "$PROJECT-$VERSION"
    exit
  fi

  check_prerequisites
  print_desc_with_images "$@"
}

if [[ "${BASH_SOURCE[0]}" = "${0}" ]]; then
  argparse $@
fi
