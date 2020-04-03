# Dada Shell Theme © 2019

function x264ll --description "Converts to lossless x264"
  if [ (count $argv) -eq 0 ]
    echo 'x264ll: usage: x264ll filename1.avi[, filenameN.avi[, ...]]'
    return 1
  end
  for file in $argv[1..-1]
    set base (_file_basename $file)
    set ext (_file_extension $file)
    set target $base'.m4v'

    echo "Converting "(set_color yellow)"$file"(set_color reset)" to "(set_color green)"$target"(set_color reset)"."
    ffmpeg -y -i "$file" -c:v libx264 -pix_fmt yuv444p -profile:v high444 -crf 0 -preset:v slow -v quiet -stats "$target"
    # scaling: -filter:v scale="iw*4:ih*4:flags=neighbor"
  end
end
