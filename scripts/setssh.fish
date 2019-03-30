#!/usr/bin/env fish

if not count $argv > /dev/null
  echo 'usage: setssh {on,off,check}'
  exit 1
end

set o $argv[1]

switch $o
case "on" "off"
  sudo systemsetup -f -setremotelogin $o
  sudo systemsetup -getremotelogin
case "check"
  sudo systemsetup -getremotelogin
  exit 0
case "*"
  echo 'usage: setssh {on,off,check}'
  exit 1
end
