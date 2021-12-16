#!/usr/bin/env bash

PROJECT="@msikma/webscrape"
DESCRIPTION="Script for scraping entire websites using wget"
SELF="webscrape.sh"
VERSION="1.0.0"

RED='\033[0;31m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
GREEN='\033[0;32m'
MAGENTA='\033[0;35m'
NC='\033[0m'

function check_prerequisites {
  arr=('wget')
  for tool in "${arr[@]}"; do
    if ! command -v $tool >/dev/null 2>&1; then
      echo "$SELF: error: the '$tool' command is not available"
      exit
    fi
  done
}

function make_domain {
  echo "$1" | awk -F/ '{print $3}'
}

function scrape {
  printf "\n${BLUE}wget${CYAN} -m -k -p -E -e -e ${BLUE}robots=${MAGENTA}off${CYAN} -l ${NC}15${CYAN} -t ${NC}30${CYAN} -w ${NC}1${CYAN} -D ${YELLOW}\"%s\" \"%s\"${NC}\n\n" "$2" "$1"
  wget -m -k -p -E -e robots=off -l 15 -t 30 -w 1 -D "$2" "$1"
}

function argparse {
  if [[ ( -z "$1" ) || ( "$1" == "-h" ) ]]; then
    echo "usage: $SELF [-v] [-h] [URL...]"
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
  domain=$(make_domain "$@")
  scrape "$@" "$domain"
}

if [[ "${BASH_SOURCE[0]}" = "${0}" ]]; then
  argparse $@
fi
