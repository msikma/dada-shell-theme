#!/usr/bin/env fish

set name "backup-3ds"
set purpose "3DS files"

set dst_basedir "/Volumes/Files/Backups/Game data"
set powersaves_src_dir "/Users/"(whoami)"/Documents/Powersaves3DS/"
set powersaves_dst_dir "$dst_basedir/Nintendo 3DS Powersaves"
set sd_backups_dst_basedir "$dst_basedir/Nintendo 3DS backups"
set saves_dst_basedir "$dst_basedir/Nintendo 3DS save files"
set pictures_dst_basedir "$dst_basedir/Nintendo 3DS pictures"

# Check whether the 3DS SD card is mounted.
set bootfile (find "/Volumes" -maxdepth 2 -type f -name "boot.3dsx")
if set -q $bootfile
  backup_error_exit $name "Could not find 3DS SD card"
end

# Determine the base dir for backing up 3DS files.
set sd_backups_src_dir (dirname $bootfile)
if not test -e $sd_backups_src_dir"/3ds_id.txt"
  backup_error_exit $name "Could not find 3DS identity string: "$sd_backups_src_dir"/3ds_id.txt"
end
# Determine the destination directories based on the 3DS name.
# Note: the white 3DS: "NTSC-J Animal Crossing New Leaf 3DS LL"
# Note: the new 3DS HHA: "PAL-E Animal Crossing HHA N3DS XL"
set id_str (string trim -- (cat $sd_backups_src_dir"/3ds_id.txt"))

# Include the ID string in the destination directory.
set sd_backups_dst_dir "$sd_backups_dst_basedir/$id_str"

set pictures_src_dir $sd_backups_src_dir"/DCIM"
set saves_src_dir $sd_backups_src_dir"/3ds/Checkpoint/saves/"
set extdata_src_dir $sd_backups_src_dir"/3ds/Checkpoint/extdata/"
set screenshots_src_dir $sd_backups_src_dir"/luma/screenshots/"

set pictures_dst_dir $pictures_dst_basedir"/"$id_str
set saves_dst_dir $saves_dst_basedir"/saves"
set extdata_dst_dir $saves_dst_basedir"/extdata"
set screenshots_dst_dir $pictures_dst_dir"/screenshots"

check_rsync_version $name
check_hostname $name
check_needed_dirs $name 'source' $sd_backups_src_dir $saves_src_dir $extdata_src_dir $pictures_src_dir $powersaves_src_dir
check_needed_dirs $name 'target' $sd_backups_dst_dir $saves_dst_dir $extdata_dst_dir $pictures_dst_dir $powersaves_dst_dir

print_backup_start $purpose $name
print_last_backup_time $name
echo (set_color blue)"Backing up the following 3DS: "(set_color purple)"$id_str"(set_color normal)
echo
print_backup_dirs $sd_backups_src_dir $sd_backups_dst_dir $saves_src_dir $saves_dst_dir $extdata_src_dir $extdata_dst_dir $pictures_src_dir $pictures_dst_dir $screenshots_src_dir $screenshots_dst_dir $powersaves_src_dir $powersaves_dst_dir

copy_rsync_delete $sd_backups_src_dir $sd_backups_dst_dir 1
copy_rsync $saves_src_dir $saves_dst_dir 1
copy_rsync $extdata_src_dir $extdata_dst_dir 1
copy_rsync $pictures_src_dir $pictures_dst_dir 1
copy_rsync $powersaves_src_dir $powersaves_dst_dir 1

# Optionally copy over Luma screenshots if the SD card has those.
# Don't error out if they don't exist.
if test -d $screenshots_src_dir
  copy_rsync $screenshots_src_dir $screenshots_dst_dir 1
end

print_backup_finish $name
set_last_backup $name
