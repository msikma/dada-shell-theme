#!/usr/bin/env fish

set base ~/
set locs "Client projects" "Projects" "Source" "Utilities"

function main
  set -g NO_DIRPREV_HOOK "1"
  set first "0"
  for loc in $locs
    if [ ! -d "$base""$loc" ]
      continue
    end
    if [ "$first" = "0" ]
      echo (set_color yellow)"┌───────────────────────────────────────┐"(set_color normal)
      set first "1"
    else
      echo (set_color yellow)"├────────────────────────────────╨──────┤"(set_color normal)
    end
    printf (set_color yellow)"│ %-30s   %-4s │\n" "$loc" ""
    echo (set_color yellow)"├────────────────────────────────╥──────┤"(set_color normal)
    set path "$base""$loc"
    pushd "$path"
    set dirs (find . -type d -mindepth 1 -maxdepth 1 | sort)
    for projpath in $dirs
      pushd "$projpath"
      set changes (string trim (git status --porcelain=v2 2>/dev/null | wc -l))
      if [ "$changes" = "0" ]
        popd
        continue
      end
      printf (set_color yellow)"│ "(set_color cyan)"%-30s "(set_color yellow)"║ "(set_color red)"%-4s"(set_color yellow)" │\n" (string sub -s 3 "$projpath") "$changes"
      popd
    end
    popd
  end
  echo (set_color yellow)"└────────────────────────────────╨──────┘"(set_color normal)
  set -g NO_DIRPREV_HOOK "0"
end

main
