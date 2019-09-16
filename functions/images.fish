# Dada Shell Theme © 2019

# Processing command for iSakura TV. Crops 22px off the top and bottom and converts to jpg.
function img_isakura
  set files $argv[1..-1]
  magick mogrify -format jpg -shave 0x22 $files
end

# Used to cut off the edges from any image.
function img_trim
  set files $argv[1..-1]
  magick mogrify -trim $files
end
