#!/usr/bin/env fish

set name "backup-arc-src"
set purpose "archived project source code"

set src ~/"Archive"
set dst "/Volumes/Files/Backups/Programming archive"

function main
  # Prevent the project overview hook from activating.
  set -g NO_DIRPREV_HOOK 1

  check_hostname $name
  check_needed_dirs $name 'source' $src
  check_needed_dirs $name 'target' $dst
  print_backup_start $purpose $name $dada_hostname
  print_last_backup_time $name

  echo (set_color red)Zipping archived projects:(set_color normal)

  pushd "$src"
  set dirs (find "$src" -type d -mindepth 1 -maxdepth 1)
  for dir in $dirs
    pushd "$dir"
    set dirn (basename "$dir")
    set projs (find "$dir" -type d -mindepth 1 -maxdepth 1)
    for proj in $projs
      set proj_name (basename "$proj")
      set proj_parent (dirname "$proj")
      set proj_date ""
      set proj_touch ""

      # Check the last commit date.
      pushd "$proj"
      set proj_date (git log -1 --format=%cd --date=short 2> /dev/null)
      set proj_touch (git log -1 --format=%cd --date=format:'%Y%m%d%H%M' 2> /dev/null)
      popd

      if [ ! "$proj_date" ]
        # If we don't have a commit date, get the last file date.
        set proj_x (gfind ./"$proj_name" \( ! -name ".DS_Store" ! -name "node_modules" \) ! -path "*/node_modules*" -type f -exec gstat --printf="%Y\n" \{\} \; | sort -n -r | head -n 1)
        if [ ! "$proj_x" ]
          # And if we don't have that, get the last modification date of the directory itself.
          set proj_x (gstat "$proj" --printf="%Y\n")
        end
        set proj_date (date -r "$proj_x" +'%Y-%m-%d')
        set proj_touch (date -r "$proj_x" +'%Y%m%d%H%M')
      end

      set source_fn "./$proj_name"
      set target_fn "$proj_name $proj_date.zip"

      zip -r9q "$target_fn" "$source_fn" -x "/**/.DS_Store" -x "$source_fn""/node_modules/**"
      if [ "$status" -ne 0 ]
        echo (set_color red)"Error: "(set_color yellow)"$dirn"(set_color normal)"/"(set_color yellow)"$proj_name"(set_color normal)" did not successfully zip"
        rm -f "./$target_fn"
        continue
      end

      set size (du -h "$target_fn")

      set dst_dir "$dst/"(basename $dir)
      mkdir -p "$dst_dir"
      mv "$target_fn" "$dst_dir"
      if [ "$status" -ne 0 ]
        echo (set_color red)"Error: "(set_color yellow)"$dirn"(set_color normal)"/"(set_color yellow)"$proj_name"(set_color normal)" could not be moved to the destination dir: "(set_color yellow)"$dst_dir"(set_color normal)
        rm -f "./$target_fn"
        continue
      end

      touch -t "$proj_touch" "$dst_dir/$target_fn"
      rm -rf "$source_fn"
      set tgfn (set_color yellow)"$dirn"(set_color normal)"/"(set_color yellow)"$proj_name"
      printf "%s%-52s%s%-39s%s\n" (set_color green) "$size" (set_color yellow) "$tgfn" (set_color normal)
    end
    popd
  end

  print_backup_finish $name
  set_last_backup $name
end

main
