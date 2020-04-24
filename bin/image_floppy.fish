#!/usr/bin/env fish

# Floppy imaging script for OSX
# Requires gdd, diskutil and python (either 2 or 3).
#
# Waits until a new floppy is inserted, then automatically images it to
# the indicated directory. Set the directory in $FLOPPY_IMAGING_PATH.
#
# We will calculate the CRC32 of the first 500 bytes of the floppy
# as part of the filename, along with the floppy partition name.

# TODO:
# mdir -i

set err "image_floppy.fish: Error:"
if [ (whoami) != "root" ]
  echo "$err Must run as root to access floppy device"
  exit
end
# Remove trailing slash from the floppy path if it's there.
set dst (echo $FLOPPY_IMAGING_PATH | string replace -r '/$' '')
if test -z "$dst"
  echo "$err Set a FLOPPY_IMAGING_PATH envvar first"
  exit
end

set missing 0
if not type "gdd" > /dev/null 2>&1
  echo "$err Missing command: gdd (GNU Core Utilities version of dd: install with 'brew install coreutils')"
  set missing 1
end
if not type "diskutil" > /dev/null 2>&1
  echo "$err Missing command: diskutil"
  set missing 1
end
if not type "python" > /dev/null 2>&1
  echo "$err Missing command: python (either Python 2 or Python 3)"
  set missing 1
end
if [ $missing -eq '1' ]
  exit
end

echo
echo "Floppy disk imaging script"
echo
echo (set_color yellow)"Target dir:     "(set_color normal)$dst
mkdir -p $dst

if not test -d $dst
  echo "$err Could not create or access FLOPPY_IMAGING_PATH: $FLOPPY_IMAGING_PATH"
  exit
end

function make_crc32
  # Prints the CRC32 of the first 500 bytes of the floppy disk.
  # No 0x prefix.
  set floppy $argv[1]
  head -c500 $floppy \
    | python -c "import zlib; import sys; print(format(zlib.crc32((sys.stdin.buffer if sys.version_info[0] >= 3 else sys.stdin).read(500)) & 0xFFFFFFFF, '08x'));"
end

function check_floppy
  set floppy $argv[1]
  # List partitions on the floppy disk device and strip to the volume name.
  set list (diskutil list $floppy \
    | tail -n +3 \
    | grep "1.5 MB" \
    | sed 's/^ *[0-9]*: *//g' \
    | string sub -s 1 -l 11)
  echo $list
end

function find_floppy_drive
  set drive (diskutil list \
    | awk '/^\// { device=$1 }
           $1 == "0:" && $4 == "*1.5" { print device }')
  echo $drive
end

function save_floppy
  set src $argv[1]
  set fn $argv[2]
  gdd if=$src status=progress bs=1024 count=1440 > $fn
end

function drive_size
  set drive $argv[1]
  set out (df -Hl | grep -i "$drive" | awk '{print $2"|"$3"|"$4"|"$5}')
  echo $out
end

function is_unnamed
  if [ "$argv[1]" = "NO NAME    " ]
    echo '1'
  end
  echo '0'
end

function main
  set session_n '0'
  # Detect the floppy drive and begin listening for new disks.
  while true
    set drive (find_floppy_drive)
    set rawdrive (echo $drive | sed 's/\/disk/\/rdisk/')
    if test -n "$drive"
      echo (set_color yellow)"Floppy drive:   "(set_color normal)"$drive (detected)"
      break
    end
    sleep 1
  end
  while true
    set floppy (check_floppy $drive)

    # If no floppy drive found, sleep and try again.
    if test -z "$floppy"
      sleep 1
      continue
    end

    # Retrieve disk label and CRC32 of the first 500 bytes for uniqueness.
    set crc (make_crc32 $rawdrive)
    # Convert :\/."' and spaces to underscores for safety.
    set label (echo $floppy | sed 's/[ :\/\\\."\']/_/g')

    set out (drive_size $drive)
    set total (echo $out | cut -d'|' -f1)
    set used (echo $out | cut -d'|' -f2)
    set free (echo $out | cut -d'|' -f3)
    set usage (echo $out | cut -d'|' -f4)

    # Sometimes we arrive here before the disk has been mounted.
    # In that case we've actually taken *1.5 MB, the diskutil size,
    # as though it's the partition label.
    # If that's so, drive_size will have no output.
    if test -z "$total"
      sleep 2
      continue
    end

    # Print disk information before ripping.
    echo
    echo (set_color green)"Found new disk."(set_color white)
    echo (set_color blue)"Floppy size:    "(set_color normal)"$used ($total total; $usage)"
    echo -n (set_color blue)"Disk label:     "(set_color -u white)"$floppy"(set_color normal)
    if [ (is_unnamed "$label") = '1' ]
      echo -n (set_color red)" (unnamed)"(set_color normal)
    end
    echo -en "\n"
    echo (set_color blue)"CRC32 hash:     "(set_color white)"$crc"(set_color normal)
    read -P (set_color yellow)"Custom label:   "(set_color normal) custom_label

    # Add session counter.
    set session_n (math "$session_n + 1")
    set session_nn (printf "%03g" "$session_n")
    if [ "$custom_label" = "" ]
      set fn "$dst"/"$session_nn $label - $crc"".img"
    else
      set fn "$dst"/"$session_nn $custom_label ($label) - $crc"".img"
    end
    set fn_base (_file_basename $fn)
    set mdir_target "$fn_base.txt"

    echo (set_color purple)"Filename:       "(set_color white)"$fn"(set_color normal)
    save_floppy $rawdrive $fn
    mdir -i "$fn" > "$mdir_target"
    
    echo "Saved: $fn"
    echo "Saved: $mdir_target"
    echo (set_color green)"Finished imaging disk. Insert next disk and press enter, or exit using CTRL+C."(set_color normal)
    read -P ''
  end

  check_floppy
end

main
