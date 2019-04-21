#!/usr/bin/env fish

set name "backup-music"
set purpose "music"

set src ~/"Files/Music/"
set dst "/Volumes/Files/Music/Archive/"

check_rsync_version $name
check_hostname $name
check_needed_dirs $name 'source' $src
check_needed_dirs $name 'target' $dst

print_backup_start $purpose $name
print_last_backup_time $name
print_backup_dirs $src $dst

copy_rsync $src $dst

print_backup_finish $name
set_last_backup $name
