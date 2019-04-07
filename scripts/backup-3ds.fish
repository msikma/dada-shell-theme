#!/usr/bin/env fish

timer_start

set err "backup-3ds: Error:"
set last_backup (backup_time_rel "/Users/"(whoami)"/.cache/dada/backup-3ds")
set pwssrc "/Users/"(whoami)"/Documents/Powersaves3DS/"*
set pwsdir "/Volumes/Files/Backups/Game data/Nintendo 3DS Powersaves"
set dstdir "/Volumes/Files/Backups/Game data/Nintendo 3DS backups"
set svsdir "/Volumes/Files/Backups/Game data/Nintendo 3DS save files"
set picdir "/Volumes/Files/Backups/Game data/Nintendo 3DS pictures"

set needdirs $pwsdir $dstdir $svsdir $picdir

for n in (seq (count $needdirs))
  set s $needdirs[$n]
  if not test -d $s
    echo "$err Can't access target directory: "$s
    exit 1
  end
end

# Check whether the 3DS SD card is mounted.
set bootfile (find "/Volumes" -maxdepth 2 -type f -name "boot.3dsx")
if set -q $bootfile
  echo "$err Could not find 3DS SD card"
  exit
end

# Determine the base dir for backing up 3DS files.
# Note: the white 3DS: "NTSC-J Animal Crossing New Leaf 3DS LL"
# Note: the new 3DS HHA: "PAL-E Animal Crossing HHA N3DS XL"
set dir (dirname $bootfile)
if not test -e $dir"/3ds_id.txt"
  echo "$err Could not find 3DS identity string: "$dir"/3ds_id.txt"
  exit
end
set idstr (string trim -- (cat $dir"/3ds_id.txt"))
set dst "$dstdir/$idstr"
set picsrcdir $dir"/DCIM"
set picdstdir $picdir"/"$idstr

echo
echo (set_color cyan)"Backing up 3DS SD card: "(set_color yellow)$idstr(set_color normal)
echo (set_color green)"Last backup was "$last_backup"."(set_color normal)
echo (set_color green)"Backing up to: "(set_color yellow)"$dst"(set_color normal)
echo
mkdir -p "$dst"

# Copy over everything.
rsync -ahvrESH8 --delete --progress --stats --exclude=".*/" --exclude=".*" $dir $dst

# Separately copy over the save files as well. Don't delete anything.
mkdir -p $svsdir"/saves"
mkdir -p $svsdir"/extdata"
rsync -ahvrESH8 --progress --stats --exclude=".*/" --exclude=".*" $dir"/3ds/Checkpoint/saves/" $svsdir"/saves"
rsync -ahvrESH8 --progress --stats --exclude=".*/" --exclude=".*" $dir"/3ds/Checkpoint/extdata/" $svsdir"/extdata"

# Copy over the pictures in an ID sandboxed directory.
mkdir -p "$picdstdir"
rsync -ahvrESH8 --progress --stats --exclude=".*/" --exclude=".*" $picsrcdir $picdstdir

# Finally, copy over any Powersaves backups we have.
mkdir -p "$pwsdir"
rsync -ahvrESH8 --progress --stats --exclude=".*/" --exclude=".*" $pwssrc $pwsdir

set result (timer_end)
echo (set_color cyan)"Done in $result s."(set_color normal)
echo

# Save last backup timestamp.
mkdir -p ~/.cache/dada
echo (date +"%a, %b %d %Y %X %z") > ~/.cache/dada/backup-3ds
