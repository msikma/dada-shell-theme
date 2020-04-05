#!/usr/bin/env fish

set name "backup-switch"
set purpose "Switch files"

set backups_basedir "/Volumes/Files/Backups/Game data"
set backups_basedir_pictures "$backups_basedir/Nintendo Switch pictures"

# Check whether the Nintendo Switch SD card is mounted.
set switch_id (find "/Volumes" -maxdepth 2 -type f -name ".switch-id")
if set -q $switch_id
  backup_error_exit $name "Could not find Switch SD card."
end

# Determine the base dir for backing up Nintendo Switch files.
set src_volume_dir (dirname $switch_id)
if [ ! -e $src_volume_dir"/.switch-id" ]
  backup_error_exit $name "Could not find Nintendo Switch identity string: "$src_volume_dir"/.switch-id"
end
# Determine the destination directories based on the Switch name.
set id_str (string trim -- (cat $src_volume_dir"/.switch-id"))
set src_dir_base "$src_volume_dir/Nintendo"
set dst_dir_base "$backups_basedir_pictures/$id_str"

set src_dir_pictures $src_dir_base"/Album/"
set dst_dir_pictures "$dst_dir_base/Album"

check_rsync_version $name
check_hostname $name
check_needed_dirs $name 'source' $src_dir_pictures $src_dir_pictures
check_needed_dirs $name 'target' $dst_dir_pictures $dst_dir_pictures

print_backup_start $purpose $name $dada_hostname
print_last_backup_time "."$name $dst_dir_base

echo (set_color blue)"Backing up the following Nintendo Switch: "(set_color purple)"$id_str"(set_color normal)
print_backup_dirs $src_dir_pictures $dst_dir_pictures

copy_rsync_delete $src_dir_pictures $dst_dir_pictures 0

print_backup_finish $name
set_last_backup "."$name $dst_dir_base
