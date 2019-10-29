# Dada Shell Theme © 2019

# Processing command for iSakura TV. Crops 22px off the top and converts to jpg.
function img_isakura
  set files $argv[1..-1]
  magick mogrify -format jpg -gravity North -chop 0x22 $files
end

# Processing command for iSakura TV. Crops 22px off the top and bottom and converts to jpg.
# Archived because that's no longer needed now that the monitor has changed.
#function img_isakura_old
#  set files $argv[1..-1]
#  magick mogrify -format jpg -shave 0x22 $files
#end

# Used to cut off the edges from any image.
function img_trim
  set files $argv[1..-1]
  magick mogrify -trim $files
end
