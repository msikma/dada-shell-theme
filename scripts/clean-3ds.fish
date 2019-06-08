#!/usr/bin/env fish

set name "clean-3ds"
set purpose "3DS files"

# Check whether the 3DS SD card is mounted.
set bootfile (find "/Volumes" -maxdepth 2 -type f -name "boot.3dsx")
if set -q $bootfile
  backup_error_exit $name "Could not find 3DS SD card."
end

# Find the identity string.
set 3ds_root (dirname $bootfile)
if not test -e $3ds_root"/3ds_id.txt"
  backup_error_exit $name "Could not find 3DS identity string: "$3ds_root"/3ds_id.txt"
end
set id_str (string trim -- (cat $3ds_root"/3ds_id.txt"))

set saves_found 0
set save_dir ""
set save_dirs "_saves/" "3ds/Checkpoint/saves/"
for dir in $save_dirs
  set dir $3ds_root/$dir
  if test -d $dir
    set saves_found 1
    set save_dir $dir
    break
  end
end
if [ $saves_found -eq 0 ]
  backup_error_exit $name "Could not find save files directory"
end

set files (get_dot_underbars $save_dir)
if [ $files -eq 0 ]
  echo (set_color yellow)"No need to remove dot-underbar files in the save files directory."(set_color normal)
  exit 0
end
echo (set_color yellow)"Cleaning up "(set_color cyan)"$files"(set_color yellow)" dot-underbar files in the save files directory."(set_color normal)
clean_dot_underbars $save_dir
