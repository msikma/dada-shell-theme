# Dada Shell Theme © 2019, 2020

set -g _jpg_quality "99"

# Base function for various resize scripts/functions.
function _img_resize \
  --argument-names rename amount point \
  --description "Base for various resizing functions"
  set files $argv[4..-1]

  for file in $files
    # Add the suffix to the filename if requested.
    if [ "$rename" -eq "1" ]
      set base (_file_basename $file)
      set ext (_file_extension $file)
      set target $base"_$amount.$ext"
    else
      set target $file
    end

    # Set quality value for lossy files.
    if [ $ext = 'jpg' -o $ext = 'jpeg' ]
      set quality "-quality $_jpg_quality"
    else
      set quality ""
    end

    # Set either bicubic or nearest neighbor resize filter.
    if [ "$point" -eq "1" ]
      set filter "Point"
    else
      set filter "Cubic"
    end
    
    magick convert "$file" -filter "$filter" -resize "$amount" "$quality" "$target"
  end
end
