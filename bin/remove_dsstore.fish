#!/usr/bin/env fish

function remove_dsstore_dir --argument-names dry_run dir
  set args
  set -a args "-print"
  if [ "$dry_run" -eq "0" ]
    set -a args "-delete"
  end
  
  if [ ! -d "$dir" ]
    echo "remove_dsstore.fish: directory not found: $dir"
  end

  find "$dir" -name ".DS_Store" -type f $args
end

function args
  set usage "usage: remove_dsstore.fish [--help] [--dry-run] dirs"
  set dry_run "0"
  set dirs
  for arg in $argv
    if [ (string match -r '^-h$|^--help$' -- "$arg") ]
      echo "$usage"
      echo
      echo "Removes .DS_Store files recursively from one or more given directories."
      echo "Run with --dry-run to only print the files instead."
      return
    end
    if [ (string match -r '^--dry-run$' -- "$arg") ]
      set dry_run "1"
    end
    if [ ! (string match -r '^--' -- "$arg") ]
      set -a dirs "$arg"
    end
  end
  
  if ! set -q "dirs[1]"
    echo "$usage"
    return 1
  end
  for dir in $dirs
    remove_dsstore_dir "$dry_run" "$dir"
  end
end

args $argv
