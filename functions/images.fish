# Dada Shell Theme © 2019, 2020

set -g screenshot_dir ~/"Desktop/"

# Resizes to 50% to a new file
function img_r50p
  _img_resize "1" "50%" "0" $argv[1..-1]
end

# Resizes to 400% to a new file, nearest neighbor
function img_r400p
  _img_resize "1" "400%" "1" $argv[1..-1]
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

# Converts the latest .png screenshots (made in the last 5 minutes).
function jpeg_scr
  for file in (find "$screenshot_dir" -type f -depth 1 -mmin -5 -name "*.png")
    set base (_file_basename $file)
    if [ ! -f "$base.jpg" ]
      img_jpeg "$file"
    end
  end
end

# Processing command for iSakura TV. Crops 22px off the top and converts to jpg.
# Archived because the site changed.
#function img_isakura
#  set files $argv[1..-1]
#  magick mogrify -format jpg -gravity North -chop 0x22 $files
#end

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
