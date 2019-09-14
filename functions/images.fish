# Dada Shell Theme © 2019

# Processing command for iSakura TV. Crops 22px off the top and bottom and converts to jpg.
function img_isakura --argument-names file_arg
  magick mogrify -format jpg -shave 0x22 "$file_arg"
end

# Used to cut off the edges from any image.
function img_trim --argument-names file_arg
  magick mogrify -trim "$file_arg"
end
