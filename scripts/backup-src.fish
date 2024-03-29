#!/usr/bin/env fish

set name "backup-src"
set purpose "source code and projects"

set type_c "Client projects"
set type_p "Projects"
set type_s "Source"
set type_d "Design projects"

set src_base "$home"
set src_c "$src_base/$type_c"
set src_p "$src_base/$type_p"
set src_s "$src_base/$type_s"
set src_d "$src_base/$type_d"

set dst_base "/Volumes/Files/Backups/$dada_hostname"
set dst_c "$dst_base/$type_c"
set dst_p "$dst_base/$type_p"
set dst_s "$dst_base/$type_s"
set dst_d "$dst_base/$type_d"

check_hostname $name
check_needed_dirs $name 'source' $src_c $src_p $src_s $src_d
check_needed_dirs $name 'target' $dst_c $dst_p $dst_s $dst_d

print_backup_start $purpose $name $dada_hostname
print_last_backup_time_abs $name
print_backup_dirs $src_p $dst_p $src_c $dst_c $src_s $dst_s $src_d $dst_d

set types $type_p $type_c $type_s $type_d
set src $src_p $src_c $src_s $src_d
set dst $dst_p $dst_c $dst_s $dst_d

# Turn off 'proj' hook temporarily, as we pushd/popd between project directories.
set -x NO_DIRPREV_HOOK 1

for n in (seq 1 (count $src))
  set src_item $src[$n]
  set dst_item $dst[$n]
  set dst_dir $types[$n]
  set dirs (backup_list_dirs $src_item)
  for project in $dirs
    set projname (basename $project)
    set project_src "$src_item/$projname"
    set project_dst "$dst_item/$projname.7z"
    set project_fn "$projname.7z"

    # Check if the backup is needed.
    set needs_update (backup_dir_to_file_needed $project_src $project_dst)
    # Run the backup if the target file is older than the source.
    backup_dir_to_file $src_item $dst_item $dst_base $dst_dir $projname $project_dst $project_fn $needs_update
  end
end

set -x NO_DIRPREV_HOOK 0

print_backup_finish $name
set_last_backup $name
