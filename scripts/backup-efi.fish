#!/usr/bin/env fish

set name "backup-efi"
set purpose "the EFI partition"

set src "/Volumes/EFI"
set dst "/Volumes/Files/Backups/$dada_hostname/EFI"

check_rsync_version $name
check_hostname $name
check_needed_dirs $name 'source' $src
check_needed_dirs $name 'target' $dst

print_backup_start $purpose $name $dada_hostname
print_last_backup_time $name
print_backup_dirs $src $dst

copy_rsync_delete $src $dst

print_backup_finish $name
set_last_backup $name
