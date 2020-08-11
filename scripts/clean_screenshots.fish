#!/usr/bin/env fish

# Removes all screenshots in ~/Desktop/ that do not have "(2)" in them,
# which are screenshots of the leftmost monitor.

function clean_scr \
  --argument-names desk_dir
  set files (find "$desk_dir" -name 'Screenshot*.png' -depth 1 | grep -iv '(2)')
  rm -f $files
  echo (set_color cyan)Deleted (set_color yellow)(count $files)(set_color cyan) screenshots.(set_color normal)
end

if [ ! $dada_hostname = 'Vesuvius' ]
  echo "clean_screenshots.fish: error: this should only be used on Vesuvius (tried to run on "(set_color yellow)"$dada_hostname"(set_color normal)")"
  exit 1
end

clean_scr ~/'Desktop/'
