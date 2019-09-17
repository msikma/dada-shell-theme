#!/usr/bin/env fish

set name "import-some-music"
set purpose "music"

set src_main "/Volumes/Files/Music/Archive"
set dst ~/"Files/Music"

check_rsync_version $name
check_hostname $name
check_needed_dirs $name 'source' $src_main
check_needed_dirs $name 'target' $dst
check_needed_files $name 'Can only run this script on Fuji' $dst"/.fuji-music"

print_backup_start $purpose $name $dada_hostname "Music import script"
print_last_backup_time $name
print_backup_dirs $src_main $dst

mkdir -p $dst"/Music/Classical"
mkdir -p $dst"/Music/Tracker"
mkdir -p $dst"/Music/Game music"
mkdir -p $dst"/Music/Game music covers"

copy_rsync_delete $src_main"/Music/Classical" $dst"/Music"
copy_rsync_delete $src_main"/Music/Tracker" $dst"/Music"
copy_rsync_delete $src_main"/Music/Game music" $dst"/Music"
copy_rsync_delete $src_main"/Music/Game music covers" $dst"/Music"

print_backup_finish $name
set_last_backup $name
