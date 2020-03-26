#!/usr/bin/env bash

self=`basename "$0"`
usage="usage: $self [-h] [-v] audio_dir image_dir out_dir"
homepage="https://github.com/msikma/makevids"

audio_dir="$1"
image_dir="$2"
out_dir="$3"

# Runs FFmpeg to create a single output file.
make_mp4() {
  in_audio="$1"
  in_image="$2"
  out_video="$out_dir/"$(basename "${in_audio%.*}.mp4")
  i="$3"
  echo "Creating video #$i"
  # -filter:v scale="iw*2:ih*2:flags=neighbor" \
  ffmpeg -y -loop 1 \
    -i "$in_image" \
    -i "$in_audio" \
    -c:v libx264 -crf 20 -tune stillimage -c:a aac -b:a 192k \
    -pix_fmt yuv420p -shortest \
    -v quiet -stats \
    "$out_video"
}

# Prints a set of files we'll combine together into a single output file.
print_infiles() {
  in_audio="$1"
  in_image="$2"
  out_video="$out_dir/"$(basename "${in_audio%.*}.mp4")
  i="$3"
  printf "  %02g ─┬\taudio\t%s\n" "$i" "${in_audio}"
  printf "  %s   ╰\timage\t%s\n" " " "${in_image}"
  printf "  %s   →\toutput\t%s\n" " " "${out_video}"
}

run_program() {
  echo "Using the following directories:"
  echo "  audio files:  $audio_dir/*"
  echo "  image files:  $image_dir/*"
  echo "  output dir:   $out_dir"

  shopt -s nullglob
  audio_files=("$audio_dir"/*.*)
  image_files=("$image_dir"/*.*)
  shopt -u nullglob
  audio_n="${#audio_files[@]}"
  image_n="${#image_files[@]}"
  echo ""
  echo "Found the following number of files:"
  echo "  audio files:  $audio_n"
  echo "  image files:  $image_n"

  if [ $audio_n -ne $image_n ]; then
    echo ""
    echo "$self: error: the audio and image source directories need the same number of files"
    exit 1
  fi

  echo ""
  echo "Pairing the following files:"
  for i in "${!audio_files[@]}"; do
    print_infiles "${audio_files[$i]}" "${image_files[$i]}" $((i+1))
  done

  # Generate the actual videos.
  mkdir -p "$out_dir"
  echo ""
  for i in "${!audio_files[@]}"; do
    make_mp4 "${audio_files[$i]}" "${image_files[$i]}" $((i+1))
  done
  echo ""
  echo "Converted $audio_n files."
  exit
}

case $1 in
  -v|--version)
    echo "$project ($version)"
    ;;
  *)
    if [[ $1 == "-h" || $1 == '--help' ]]; then
      cat << EOF
$usage

Script that runs FFmpeg to create single-image videos from image files
and audio files, for e.g. uploading music albums to Youtube.

Generates mp4 files using libx264 video and aac audio.

Example:

  $ $self ./audio ./images ./out_dir

Positional arguments:
  audio_dir             Directory containing audio files.
  image_dir             Directory containing image files.
  out_dir               Directory to place the generated video files.

Optional arguments:
  -h, --help            Show this help message and exit.
  -v, --version         Show program's version number and exit.

For more information, see <$homepage>.
EOF
      exit 0
    fi
    if [ -z "$3" ]; then
      cat << EOF
$usage
$self: error: too few arguments
EOF
      exit 1
    else
      run_program
    fi
    ;;
esac
