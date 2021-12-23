# Dada Shell Theme © 2019-2021

set _image_exts "gif" "png" "jpg" "jpeg" "bmp" "tiff" "psd" "pdf" "eps" "ai" "webp" "avif"
set _interactive_exts "fla" "swf"
set _video_exts "mp4" "m4p" "m4v" "mkv" "avi" "webm" "mpg" "mts" "m2ts" "ts" "yuv" "rm" "rmvb" "asf" "amv" "mp2" "mpeg" "mpe" "mpv" "m2v" "ogm" "3gp" "3g2" "wmv" "mov" "qt" "flv" "f4v" "f4p" "f4a" "f4b"
set _audio_exts "mp3" "ac3" "amr" "mp1" "spx" "wma" "aac" "mpc" "vqf" "ots" "swa" "vox" "voc" "ogg" "flac" "8svx" "16svx" "aiff" "aif" "aifc" "au" "bwf" "cdda" "dsf" "dff" "raw" "wav" "ra" "rm" "ape" "brstm" "ast" "aw" "psf"

set _media_extensions $_image_exts $_interactive_exts $_video_exts $_audio_exts 

function mirror_website --description "Mirrors an entire website using wget" --argument-names url
  set wget_args $argv[2..-1]
  echo (set_color yellow)Mirroring website:(set_color green)" $url"(set_color normal)
  wget --mirror --convert-links --page-requisites --adjust-extension --level 15 --tries 30 --retry-connrefused --wait 1 $wget_args "$url"
end

function scrape_media --description "Downloads media files from a website using wget" --argument-names url
  set wget_args $argv[2..-1]
  echo (set_color yellow)Downloading media files from(set_color green)" $url"
  printf (set_color yellow)"Media files we'll download: "
  for ext in $_media_extensions
    printf (set_color cyan)"$ext "
  end
  printf (set_color normal)"\n"
  wget --mirror --level 15 --no-directories --span-hosts --page-requisites --tries 30 --retry-connrefused --wait 1 --execute robots=off --accept (string join , $_media_extensions) $wget_args "$url"
end
