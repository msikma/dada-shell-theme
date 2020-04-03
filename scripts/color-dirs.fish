#!/usr/bin/env fish

function get_tech --argument-names dir
  if [ -e $dir/package.json ]
    echo 'node'; return
  end
  echo 'unknown'
end

function get_color --argument-names type
  if [ "$type" = 'node' ]
    echo 'green'; return
  end
  echo 'generic'
end

echo 'color-dirs: TODO'
exit
set dirs (ls -d */)
for dir in $dirs
  set t (get_tech $dir)
  set c (get_color $t)
  echo (set_color yellow)"Directory: "(set_color red)"$dir"(set_color yellow)" - tech "(set_color white)"$t"(set_color yellow)", color "(set_color white)"$c"
end
