# Dada Shell Theme © 2019

set -g _jpg_quality "92"

function img_resize50
  for file in $argv[1..-1]
    set base (_file_basename $file)
    set ext (_file_extension $file)
    set target $base'_img_resize50.'$ext
    if [ $ext = 'jpg' -o $ext = 'jpeg' ]
      magick convert "$file" -resize 50% -quality $_jpg_quality "$target"
    else
      magick convert "$file" -resize 50% "$target"
    end
  end
end

# Converts images to jpeg. Files that are already .jpg or .jpeg are skipped.
function img_jpeg
  for file in $argv[1..-1]
    set base (_file_basename $file)
    set ext (_file_extension $file)
    if [ $ext = 'jpg' -o $ext = 'jpeg' ]
      echo 'img_jpeg: skipping: '$file
      continue
    end

    set target $base'.jpg'
    magick convert -format jpg -compress jpeg -quality $_jpg_quality $file $target
  end
end

# Processing command for iSakura TV. Crops 22px off the top and converts to jpg.
function img_isakura
  set files $argv[1..-1]
  magick mogrify -format jpg -gravity North -chop 0x22 $files
end

# Used to cut off the edges from any image.
function img_trim
  set files $argv[1..-1]
  magick mogrify -trim $files
end

# Processing command for iSakura TV. Crops 22px off the top and bottom and converts to jpg.
# Archived because that's no longer needed now that the monitor has changed.
#function img_isakura_old
#  set files $argv[1..-1]
#  magick mogrify -format jpg -shave 0x22 $files
#end
