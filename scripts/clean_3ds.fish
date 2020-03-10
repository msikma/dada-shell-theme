#!/usr/bin/env fish

set _name "clean_3ds"
set _purpose "3DS files"

# Check whether the 3DS SD card is mounted.
set _bootfile (find "/Volumes" -maxdepth 2 -type f -name "boot.3dsx")
if set -q $_bootfile
  backup_error_exit $_name "Could not find 3DS SD card."
end

# Find the identity string.
set _3ds_root (dirname $_bootfile)
if not test -e $_3ds_root"/3ds_id.txt"
  backup_error_exit $_name "Could not find 3DS identity string: "$_3ds_root"/3ds_id.txt"
end
set id_str (string trim -- (cat $_3ds_root"/3ds_id.txt"))

set saves_found 0
set save_dir ""
set save_dirs "_saves/" "3ds/Checkpoint/saves/"
for dir in $save_dirs
  set dir $_3ds_root/$dir
  if test -d $dir
    set saves_found 1
    set save_dir $dir
    break
  end
end
if [ $saves_found -eq 0 ]
  backup_error_exit $_name "Could not find save files directory"
end

set _files (get_dot_underbars $save_dir)
if [ $_files -eq 0 ]
  exit 0
end
echo (set_color yellow)"Cleaning up "(set_color cyan)"$_files"(set_color yellow)" dot-underbar files in the save files directory."(set_color normal)
clean_dot_underbars $save_dir
