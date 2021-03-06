#!/usr/bin/env fish

set name "backup-music"
set purpose "music"

set archive "/Volumes/Files/Music/"
set src ~/"Files/Music/"
set dst $archive"Archive/"

check_rsync_version $name
check_hostname $name
check_needed_dirs $name 'source' $src
check_needed_dirs $name 'target' $dst

print_backup_start $purpose $name $dada_hostname
print_last_backup_time $name $archive
print_backup_dirs $src $dst

copy_rsync_delete $src $dst
set_last_backup "."$name $archive
print_backup_finish $name
