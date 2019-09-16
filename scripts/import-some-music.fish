#!/usr/bin/env fish

set name "import-some-music"
set purpose "music"

set src "/Volumes/Files/Music/Archive"
set dst ~/"Files/Music"

check_rsync_version $name
check_hostname $name
check_needed_dirs $name 'source' $src
check_needed_dirs $name 'target' $dst
check_needed_files $name 'Can only run this script on Fuji' $dst"/.fuji-music"

print_backup_start $purpose $name $dada_hostname "Music import script"
print_last_backup_time $name
print_backup_dirs $src $dst

copy_rsync_delete $src"/Music" $dst"/Music"
copy_rsync_delete $src"/Stuff" $dst"/Stuff"
print_backup_finish $name
set_last_backup $name
