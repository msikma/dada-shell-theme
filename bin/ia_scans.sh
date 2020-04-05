#!/usr/bin/env bash

PROJECT="ia_imgs"
DESCRIPTION="Prints an Internet Archive item's description along with a table of scans."
SELF="ia_imgs.sh"
VERSION="1.0.0"
PREREQUISITES=('ia' 'jq')

function check_prerequisites {
  for tool in "${PREREQUISITES[@]}"; do
    if ! command -v $tool >/dev/null 2>&1; then
      echo "$SELF: error: the '$tool' command is not available"
      exit
    fi
  done
}

# Lists all original files whose title starts with 'Scan [0-9]'.
function list_scans {
  ia list -l --columns=name,source "$1" | grep "original\$" | grep -i "/scan.[0-9]\+" | cut -d $'\t' -f1 | sort | tr '\n' '\0'
}

function print_desc {
  ia metadata "$1" | jq -r '.metadata.description'
}

function print_item {
  echo "<tr><td>$4</td><td><a href=\"$1\"><img src=\"$2\" alt=\"Thumbnail of $3\" style=\"display:block\"></a></td></tr>"
}

function print_items_start {
  echo "<p><hr></p><p><strong>Scans:</strong></p><table border=\"1\"><tr><th>Name</th><th>Image</th></tr>"
}

function print_items_end {
  echo "</table>"
}

function print_desc_with_images {
  # Create an array of URLs to scans, e.g. 'https://archive.org/download/IDENTIFIER/Scan 01 - Cover.jpg'.
  files=()
  while IFS= read -r -d $'\0'; do
    files+=("$REPLY")
  done < <(list_scans "$1")

  # The original description.
  print_desc "$1"

  # Now we'll loop through each scan and output an HTML item for each one.
  print_items_start
  for file in "${files[@]}"; do
    # The plain filename without URL path.
    fn=$(echo $file | sed -n 's/.*\/download\/.*\/\(.*\)$/\1/p')
    # The title of the scan (e.g. 'Cover' for 'Scan 01 - Cover.jpg')
    name=$(echo $fn | sed -n 's/[^-]* - \(.*\)\..*/\1/p')
    # Attach _thumb at the end to get the thumbnail URL.
    thumb=$(echo $file | sed -e 's/.\([a-z]*\)$/_thumb.\1/')
    print_item "$file" "$thumb" "$fn" "$name"
  done
  print_items_end
  #
  #echo $desc
  #echo 'TODO'
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
