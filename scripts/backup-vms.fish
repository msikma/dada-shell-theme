#!/usr/bin/env fish

set name "backup-vms"
set purpose "VMs"

set src_vms "$home/Files/VMs/"
set dst_vms "/Volumes/Files/Backups/$dada_hostname/VMs"

check_rsync_version $name
check_hostname $name
check_needed_dirs $name 'source' $src_vms
check_needed_dirs $name 'target' $dst_vms

print_backup_start $purpose $name $dada_hostname
print_last_backup_time $name
print_backup_dirs $src_vms $dst_vms

copy_rsync_delete $src_vms $dst_vms

print_backup_finish $name
set_last_backup $name
