#!/usr/bin/env fish

function convert_bmp_to_png \
  --argument-names bmp_file remove_original \
  --description "Replaces a .bmp file with a .png file"
  set base (echo $bmp_file | strip_ext)
  set dest "$base.png"
  convert "$bmp_file" "$dest"
  if [ -n "$remove_original" -a "$remove_original" -eq '1' ]
    rm "$bmp_file"
  end
end

function dir_bmp_to_png \
  --argument-names dir remove_original \
  --description "Converts all .bmp files in a directory to .png files"
  if [ -z "$remove_original" ]
    set remove_original '0'
  end
  set bmp_files "$dir/"*".bmp"
  set bmp_count (count $bmp_files)
  echo (set_color yellow)"Converting all "(set_color cyan)".bmp"(set_color yellow)" files to "(set_color cyan)".png"(set_color yellow)" in "(set_color normal)"$dir"
  if [ $bmp_count -eq 0 ]
    echo (set_color green)"No .bmp images found."(set_color normal)
    return
  end
  set n 0
  for bmp in $bmp_files
    convert_bmp_to_png $bmp $remove_original
    set n (math $n + 1)
    echo -en (set_color green)"\e[0K\rWorking: "(set_color normal)"$n"(set_color green)" images copied and converted."(set_color normal)
  end
  echo ""
end

function dada_bryce_dir_cv --argument-names dir
  if [ -d "$dir" ]
    dir_bmp_to_png "$dir" "0"
  else
    echo 'convert_bryce.fish: error: can\'t find directory: '"$dir"
    return 1
  end
end

dada_bryce_dir_cv $DADA_BRYCE_DIR
