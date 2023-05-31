#!/usr/bin/env fish

function main --argument-names dir
  if [ -z "$dir" ]
    set dir "."
  end
  set outdir "__images"
  set exts (string join \| $_image_exts)
  echo (set_color yellow)"Collecting images from: "(set_color cyan)"$dir"(set_color normal)
  echo (set_color yellow)"Saving to: "(set_color cyan)"$outdir"(set_color normal)
  mkdir -p "$outdir"
  for n in (find -E "$dir" -type f -regex ".*\.($exts)")
    set fullsplit (string split -r -m1 . -- "$n")
    set fullfn (echo "$fullsplit[1]" | sed -e 's/[^[:alnum:]]/-/g' | tr -s '-' | tr A-Z a-z | string trim --chars="-")".$fullsplit[2]"
    cp "$n" ./"$outdir"/"$fullfn"
  end
  for n in (find ./$outdir -type f)
    set tmr (cat "$n" | grep -i "<h1>Too Many Requests</h1>")
    set fnf (cat "$n" | grep -i "<H1>Not Found</H1>")
    set fnf2 (cat "$n" | grep -i "<h1>404Not Found</h1>")
    
    if [ -n "$tmr" -o -n "$fnf" -o -n "$fnf2" ]
      echo (set_color red)Removing: (set_color magenta)"$n"(set_color normal)
      rm "$n"
      set m (math "$m" + 1)
    end
  end
  echo (set_color yellow)"Done. Removed "(set_color cyan)"$m"(set_color yellow)" images (invalid image signature, probably a 404)."(set_color normal)
  echo (set_color yellow)"Run "(set_color brgreen)"cd $outdir; make_contact_sheet.sh"(set_color yellow)" to make a contact sheet."(set_color normal)
end

main $argv
