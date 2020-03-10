#!/usr/bin/env fish

set bryce_dir ~/"Files/VMs/FujiXP/FujiXP HDD/Bryce/"

function convert_bmp_to_png \
  --argument-names bmp_file \
  --description "Replaces a .bmp file with a .png file"
  set base (echo $bmp_file | strip_ext)
  set dest "$base.png"
  convert "$bmp_file" "$dest"
  rm "$bmp_file"
end

function dir_bmp_to_png \
  --argument-names dir \
  --description "Converts all .bmp files in a directory to .png files"
  set bmp_files "$dir/"*".bmp"
  set bmp_count (count $bmp_files)
  echo (set_color yellow)"Converting all "(set_color cyan)".bmp"(set_color yellow)" files to "(set_color cyan)".png"(set_color yellow)" in "(set_color normal)"$dir"
  if [ $bmp_count -eq 0 ]
    echo (set_color green)"No .bmp images found."
    return
  end
  set n 0
  for bmp in $bmp_files
    convert_bmp_to_png $bmp
    set n (math $n + 1)
    echo -en (set_color green)"\e[0K\rWorking: "(set_color normal)"$n"(set_color green)" images copied and converted."(set_color normal)
  end
  echo ""
end

dir_bmp_to_png "$bryce_dir"
