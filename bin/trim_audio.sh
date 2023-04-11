#!/usr/bin/env fish

set NAME "trim_audio.sh"
set DESCRIPTION "Trims silence from the end of lossy audio files."

set threshold "-50dB"

function trim_silence --argument-names file outdir
  # Path we want to save the file to.
  set file_path (dirname "$file")
  set file_outpath "$outdir/$file_path"
  set file_out "$file_outpath/"(basename "$file")
  mkdir -p "$file_outpath"
  
  # Total length of the file. Used to check if a detected silence is at the end.
  set file_len (ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$file")
  
  # Timestamps for the start/end of a detected silence.
  set s_start ""
  set s_end ""
  
  # Whether we can trim the current file or not (if not, just copy it over instead).
  set can_trim "0"
  
  # Variables for the start/end silence timestamps for the start and end of the file.
  set start_s "0"
  set start_e "0"
  set end_s "$file_len"
  set end_e ""
  
  # Detect silence. This will output multiple lines, one for the start timestamp and one for the end.
  for line in (ffmpeg -i "$file" -af silencedetect=noise="$threshold":d=1 -f null - 2>| grep -i "silencedetect")
    set s (echo "$line" | grep -o "silence_start: \([0-9.]\+\)" | cut -d' ' -f2)
    set e (echo "$line" | grep -o "silence_end: \([0-9.]\+\)" | cut -d' ' -f2)
    
    if [ -n "$s" ]
      set s_start "$s"
    end
    
    if [ -n "$e" ]
      set s_end "$e"
    end
    
    # Check if we've got a start and end time, in which case we can split the file.
    if [ -n "$s_start" -a -n "$s_end" ]
      # If "start" is 0, this is silence at the start of the file.
      # If not, check for the length to see if it's the end of the file.
      if [ "$s_start" -eq "0" ]
        set start_s "$s_start"
        set start_e "$s_end"
        set can_trim "1"
      else
        # If the difference is less than 1 second, consider it the end.
        set s_diff (math "abs($file_len - $s_end)")
        if [ "$s_diff" -le 1 ]
          set end_s "$s_start"
          set end_e "$s_end"
          set can_trim "1"
        end
      end
      set s_start ""
      set s_end ""
    end
  end
  
  # If we do not need to trim the file, copy it over verbatim.
  if [ "$can_trim" -eq 0 ]
    echo (set_color yellow)"copy: $file [no silence detected]"(set_color normal)
    cp "$file" "$file_out"
  else
    # For some reason we need to reduce the start time with 0.05s.
    # If we don't, the file starts just slightly too late.
    if [ "$start_e" -ne "0" ]
      set start_e (math "$start_e" - "0.05")
    end
    
    set file_new_len (math "$end_s" - "$start_e")
    echo (set_color green)"trim: $file [start=$start_e, end=$end_s, len=$file_new_len, orig=$file_len]"(set_color normal)
    ffmpeg -y -v error -i "$file" -acodec copy -ss (math "$start_e" - "0.1") -to "$end_s" "$file_out"
  end
end

function trim_files --argument-names in_dir out_dir
  set files (find "$in_dir" -type f \( -iname "*.opus" -o -iname "*.mp3" -o -iname "*.m4a" -o -iname "*.ogg" \) -not -path "$out_dir/*" | sort)
  mkdir -p "$out_dir"
  for f in $files
    trim_silence "$f" "$out_dir"
  end
end

function print_usage
  echo "usage: $NAME [--help] in_dir [out_dir]"
  echo
  echo "$DESCRIPTION"
end

function args
  set usage "usage: $NAME [--help] in_dir [out_dir]"
  for arg in $argv
    if [ (string match -r '^-h$|^--help$' -- "$arg") ]
      print_usage
      return
    end
  end
  
  set in_dir $argv[1]
  set out_dir $argv[2]
  if [ -z "$in_dir" ]
    print_usage
    return 1
  end
  if [ -z "$out_dir" ]
    set out_dir "./_trimmed"
  end
  
  trim_files "$in_dir" "$out_dir"
end

args $argv
