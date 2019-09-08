#!/usr/bin/env fish

set name "backup-files"
set purpose "misc. files"

set src_files "$home/Files/"
set src_desktop "$home/Desktop/"
set src_documents "$home/Documents/"

set dst_files "/Volumes/Files/Backups/$dada_hostname/Files"
set dst_desktop "/Volumes/Files/Backups/$dada_hostname/Desktop"
set dst_documents "/Volumes/Files/Backups/$dada_hostname/Documents"

check_rsync_version $name
check_hostname $name
check_needed_dirs $name 'source' $src_files $src_desktop $src_documents
check_needed_dirs $name 'target' $dst_files $dst_desktop $dst_documents

print_backup_start $purpose $name $dada_hostname
print_last_backup_time $name
print_backup_dirs $src_files $dst_files $src_desktop $dst_desktop $src_documents $dst_documents

copy_rsync_delete $src_files $dst_files 0 "VMs"
copy_rsync_delete $src_desktop $dst_desktop 0
copy_rsync_delete $src_documents $dst_documents 0

print_backup_finish $name
set_last_backup $name
