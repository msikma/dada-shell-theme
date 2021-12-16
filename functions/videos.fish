# Dada Shell Theme © 2019-2021

# For picking specific video/audio streams, if there are multiple:
# -map 0:v:0 -map 0:a:2

function _notify_encode --argument-names src dst type
  echo (set_color yellow)Encoding: (set_color blue)"$src"(set_color reset)
  echo (set_color yellow)Using preset: (set_color cyan)"$type"(set_color reset)
end

function enc_x265_hq --argument-names src dst
  _notify_encode "$src" "$dst" "High quality x265/aac"
  ffmpeg -i "$src" -c:v libx265 -preset slow -crf 20 -c:a aac -pix_fmt yuv444p10 -y -stats "$dst"
end

function enc_vg_up4x --argument-names src dst
  _notify_encode "$src" "$dst" "Video game (with 4x upscale)"
  ffmpeg -i "$src" -c:v libx265 -preset slow -filter:v scale="iw*4:ih*4:flags=neighbor" -crf 20 -c:a aac -pix_fmt yuv420 -y -stats "$dst"
end

function enc_vg_up2x --argument-names src dst
  _notify_encode "$src" "$dst" "Video game (with 2x upscale)"
  ffmpeg -i "$src" -c:v libx265 -preset slow -filter:v scale="iw*2:ih*2:flags=neighbor" -crf 20 -c:a aac -pix_fmt yuv420 -y -stats "$dst"
end

function enc_old_anime4k --argument-names src dst
  _notify_encode "$src" "$dst" "Old anime 4K (grainy; audio copy)"
  ffmpeg -i "$src" -c:v libx265 -x265-params bframes=8:limit-sao=1:psy-rd=1.5:psy-rdoq=2:aq-mode=3:deblock=-1,-1 -preset slow -crf 20 -pix_fmt yuv444p10 -c:a copy -y -stats "$dst"
end

function enc_x264_y4ll --argument-names src dst
  _notify_encode "$src" "$dst" "x264 yuv444 lossless (libx264, crf 0; audio flac)"
  ffmpeg -y -i "$src" -threads 8 -c:a flac -c:v libx264 -preset slow -crf 0 -pix_fmt yuv444p -profile:v high444 -x264-params "keyint=300:ref=16:no-fast-pskip:bframes=16:merange=64:subme=9:trellis=2:partitions=all:no-dct-decimate" -stats "$dst"
end

function enc_x264_rgbll --argument-names src dst
  _notify_encode "$src" "$dst" "x264 rgb lossless (libx264rgb, crf 0; audio flac)"
  ffmpeg -y -i "$src" -threads 8 -c:a flac -c:v libx264rgb -preset slow -crf 0 -x264-params "keyint=300:ref=16:no-fast-pskip:bframes=16:merange=64:subme=9:trellis=2:partitions=all:no-dct-decimate" -stats "$dst"
end

function x264_vg --description "Encodes x264 for 2D video games (upscaling 4x)"
  if [ (count $argv) -eq 0 ]
    echo 'x264ll: usage: x264ll filename1.avi[, filenameN.avi[, ...]]'
    return 1
  end
  for file in $argv[1..-1]
    set base (_file_basename $file)
    set ext (_file_extension $file)
    set target $base'.m4v'

    echo "Converting "(set_color yellow)"$file"(set_color reset)" to "(set_color green)"$target"(set_color reset)"."
    ffmpeg -y -i "$file" -c:v libx264 -pix_fmt yuv444p -filter:v scale="iw*4:ih*4:flags=neighbor" -profile:v high444 -crf 20 -preset:v ultrafast -v quiet -stats "$target"
  end
end
