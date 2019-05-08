# Dada Shell Theme © 2019

# Minimal required rsync protocol version; checked when running backup scripts.
# Use rsync --help to see the version.
set _rsync_min_prot_version 31

# List of backup commands.
set backup_cmd \
  "backup-3ds"        "Backs up 3DS SD card" \
  "backup-config"     "Backs up ~/.config/ dirs" \
  "backup-dbs"        "Backs up SQL databases" \
  "backup-files"      "Backs up various other things" \
  "backup-ftp"        "Backs up FTP bookmarks" \
  "backup-games"      "Backs up game content" \
  "backup-music"      "Backs up music" \
  "backup-src"        "Backs up source code directories" \
  "backup-zoo"        "Backs up music to the Happy Zoo" \

function backup --description "Displays backup commands and info"
  echo
  echo "Backup commands and status for "(set_color green)"$dada_uhostname_local"(set_color normal)":"
  echo
  # Make a list of all last backup times.
  set backup_prefix "$home/.cache/dada"
  set backup_times \
    "3DS SD backup:"    (backup_time_str "$backup_prefix/backup-3ds") \
    "Config backup:"    (backup_time_str "$backup_prefix/backup-config") \
    "MySQL backup:"     (backup_time_str "$backup_prefix/backup-dbs") \
    "Files backup:"     (backup_time_str "$backup_prefix/backup-files") \
    "FTP backup:"       (backup_time_str "$backup_prefix/backup-ftp") \
    "Games backup:"     (backup_time_str "$backup_prefix/backup-games") \
    "Music backup:"     (backup_time_str "$backup_prefix/backup-music") \
    "Source backup:"    (backup_time_str "$backup_prefix/backup-src") \
    "Zoo backup:"       (backup_time_str "$backup_prefix/backup-zoo") \

  # Merge together with the backup commands.
  set cols_all
  set -a cols_all (_add_cmd_colors (set_color red) $backup_cmd)
  set -a cols_all (_add_cmd_colors (set_color magenta) $backup_times)
  _iterate_help $cols_all
  echo
end

function get_last_backup \
  --argument-names script abs \
  --description "Returns last backup time for a script"
  backup_time_rel $home"/.cache/dada/"$script $abs
end

function set_last_backup \
  --argument-names script \
  --description "Saves the current timestamp as the latest backup time"
  mkdir -p $home"/.cache/dada"
  echo (date +"%a, %b %d %Y %X %z") > $home"/.cache/dada/"$script
end

# Runs rsync on a source and destination directory.
#
# The arguments used to run rsync are -ahEANS8, which expands to the following:
#
# -a, --archive          archive mode; equals -rlptgoD (no -H,-A,-X)
#  └ -r, --recursive     recurse into directories
#  └ -l, --links         copy symlinks as symlinks
#  └ -p, --perms         preserve permissions
#  └ -t, --times         preserve modification times
#  └ -g, --group         preserve group
#  └ -o, --owner         preserve owner (super-user only)
#  └ -D                  same as --devices --specials
#     └ --devices        preserve device files (super-user only)
#     └ --specials       preserve special files
# -h, --human-readable   output numbers in a human-readable format
# -E, --executability    preserve the file's executability
# -A, --acls             preserve ACLs (implies --perms)
# -N, --crtimes          preserve create times (newness)
# -S, --sparse           turn sequences of nulls into sparse blocks
# -8, --8-bit-output     leave high-bit chars unescaped in output
#
# This DOES NOT delete files that already exist in the destination directory.
#
# Note: this doesn't copy extended attributes (-X) which won't work on btrfs.
# Change if we're upgrading to a better fs.
#
function copy_rsync \
  --argument-names src dst \
  --description "Copies files from source to destination using rsync"
  rsync -ahEANS8 --progress --exclude=".*" --exclude="Icon*" --stats $src $dst
end

# As copy_rsync, but with --delete.
function copy_rsync_delete \
  --argument-names src dst \
  --description "Copies files from source to destination using rsync"
  rsync -ahEANS8 --delete --progress --exclude=".*" --exclude="Icon*" --stats $src $dst
end

# Prints out the latest backup time in YYYY-mm-dd and ('x days ago') format.
function backup_time_str --description 'Prints the time a backup was last performed'
  set bfile $argv[1]
  set now (date +%s)

  # If a backup is older than a week, display the value in yellow.
  # If it's older than a month, display the value in red.
  set yellow_cutoff 604800
  set red_cutoff 2628000

  if test -e $bfile
    set bu (cat $bfile)
    set bu_unix (backup_date_unix $bu)
    set bu_abs (date -r $bu_unix +%Y-%m-%d)
    set bu_rel (time_ago $now $bu_unix)
    set bu_diff (math "$now - $bu_unix")
    set color (set_color normal)
    set warn ""
    if [ $bu_diff -gt $yellow_cutoff ]
      set color (set_color yellow)
      set warn " ⚠️"
    end
    if [ $bu_diff -gt $red_cutoff ]
      set color (set_color red)
      set warn " ⚠️"
    end
    echo "$color$bu_abs ($bu_rel)$warn"(set_color normal)
  else
    echo 'unknown'
  end
end

# Converts a timestamp used for backups into Unix time.
function backup_date_unix --description 'Converts a backup timestamp back to Unix time'
  date -jf "%a, %b %d %Y %X %z" $argv[1] +%s
end

function backup_list_dirs \
  --description "Returns a list of directories inside a base directory" \
  --argument-names basedir
  ls -d1 --color=never $basedir"/"*"/"
end

function backup_get_latest_file \
  --description "Prints the file with the latest modification date" \
  --argument-names src
  gfind "$src" -printf '%T@ %p\0' | gsort -zk 1nr | gsed -z 's/^[^ ]* //' | tr '\0' '\n' | head -1
end

function backup_dir_to_file_needed \
  --description "Checks whether a backup is needed (if the destination doesn't exist or is older than the source)" \
  --argument-names src dst
  if not test -d $src
    # Source directory does not exist, so there's nothing to backup.
    echo 0
    return
  end
  if not test -e $dst
    # Destination file does not exist; backup needed.
    echo 1
    return
  end
  # If both targets exist, check their modification dates.
  # Return the difference between the two. If the value is 0 or less, we won't backup.
  # If the value is above 0, the value represents how many seconds newer our source is.
  set src_latest_file (backup_get_latest_file $src)
  set src_age (stat -f "%m" $src_latest_file)
  set dst_age (stat -f "%m" $dst)
  set diff (math "$src_age - $dst_age")
  echo $diff
end

function backup_dir_to_file \
  --description "Backs up a directory to a zip file" \
  --argument-names src_base_dir dst_base_dir all_dst_base_dir type_dir src_dir_name dst_file dst_fn age_diff
  # Make a shorter version of the source directory for display purposes.
  set src_dir "$src_base_dir/$src_dir_name"
  set home_escaped (echo $home | sed "s/\//\\\\\//g")
  set src_short (echo $src_dir | sed "s/$home_escaped\\///")
  # Check whether the backup is needed.
  if [ $age_diff -le 0 ]
    # Target is identical in age, or even newer, than the source.
    echo (set_color cyan)"No backup needed for "(set_color yellow)"$src_short"(set_color cyan)" - skipping"(set_color normal)
    return
  end

  # Create the zip file *without node_modules directory*, which is unnecessary and slow to pack.
  set exclude ""
  if test -d "$src_dir/node_modules"
    set exclude "-x $src_dir/node_modules/**"
  end
  pushd $src_base_dir
  zip -r9qu $dst_file $src_dir_name -x "/**/.DS_Store" $exclude
  popd
  pushd $all_dst_base_dir
  set size (du -h $type_dir/$dst_fn)
  popd
  # Check the size of the file we made.
  # And the age difference before the backup.
  # Unless it's 1, which indicates the file didn't exist before now.
  set diff ""
  set diff_xtra ""
  set src_latest_file (backup_get_latest_file $src_dir)
  set src_time (stat -f "%m" $src_latest_file)
  set now_time (date +%s)
  set src_age (math "$now_time - $src_time")
  if [ $age_diff -eq 1 ]
    set diff "- last modified "(set_color blue)(_time_unit "$src_age")" ago"(set_color yellow)
    set diff_xtra " - initial backup"
  end
  if [ $age_diff -gt 1 ]
    set diff "(was "(_time_unit $age_diff)" older)"
  end
  # Report the result.
  printf "%s%-42s%s%-42s%s%s\n" (set_color green) "$size" (set_color yellow) "$diff" "$diff_xtra" (set_color normal)
end

# Prints out the latest backup time in YYYY-mm-dd and ('x days ago') format.
function backup_time_rel --description "Prints the time a backup was last performed, relative only"
  set bfile $argv[1]
  set abs $argv[2]
  set now (date +%s)
  if test -e $bfile
    set bu (cat $bfile)
    set bu_unix (backup_date_unix $bu)
    set bu_abs (date -r $bu_unix +"%Y-%m-%d %X %z")
    set bu_rel (time_ago $now $bu_unix)
    set bu_diff (math "$now - $bu_unix")
    if [ -n "$abs" ]
      # Display absolute value and relative value.
      echo "$bu_rel ($bu_abs)"
    else
      # Display only relative value.
      echo "$bu_rel"
    end
  else
    echo '(unknown)'
  end
end

function print_backup_dir \
  --description "Prints one directory we'll be copying files to" \
  --argument-names src dst
  echo (set_color red)"Copying "(set_color normal)"$src"(set_color red)" -> "(set_color normal)$dst
end

function print_backup_dirs \
  --description "Prints what directories we'll be copying files to and from"
  for n in (seq 1 2 (count $argv))
    set src $argv[$n]
    set dst $argv[(math $n + 1)]
    echo (set_color red)"Copying from "(set_color normal)"$src"(set_color red)" -> "(set_color normal)$dst
  end
end

function print_backup_start \
  --argument-names purpose script hn \
  --description "Prints the purpose of this backup script and starts the timer; to be done right before a backup starts"
  echo
  echo -n (set_color yellow)"Backup script for "(set_color cyan)"$purpose"(set_color yellow)
  if set -q hn
    echo " on "(set_color cyan)"$hn"(set_color yellow)":"(set_color normal)
  else
    echo ":"(set_color normal)
  end
  timer_start
end

function print_backup_finish \
  --argument-names script \
  --description "Stops the timer and prints how long the backup took"
  set timer_val (timer_end)
  set timer_h (duration_humanized $timer_val)
  echo
  echo (set_color cyan)"Done in $timer_h."(set_color normal)
  echo
end

function print_last_backup_time \
  --argument-names script abs \
  --description "Prints out when the last backup was done"
  echo (set_color green)"Last backup was "(get_last_backup $script $abs)"."(set_color normal)
  echo
end

function check_hostname \
  --argument-names script \
  --description "Checks if a hostname is set"
  if not set -q dada_hostname
    echo $script": Error: \$dada_hostname is not set"
    exit 1
  end
end

function check_needed_dirs \
  --argument-names script dtype \
  --description "Checks if an array of directories exists and is accessible"
  set needdirs $argv[3..-1]
  for n in (seq (count $needdirs))
    set s $needdirs[$n]
    if not test -d $s
      echo $script": Error: Can't access $dtype directory: "$s
      exit 1
    end
  end
end

function backup_error_exit \
  --argument-names script reason \
  --description "Prints an error message and exits"
  echo $script": Error: "$reason
  exit 1
end

function check_rsync_version \
  --argument-names script \
  --description "Check whether rsync's version is new enough for the backup scripts"

  if set -q script
    set prefix $script": Error:"
  end
  set rsv (_get_rsync_version)
  if [ $rsv -lt $_rsync_min_prot_version ]
    echo $prefix "rsync protocol version is too low ($rsv); update to a newer version (at least $_rsync_min_prot_version) to use this script."
    exit 1
  end
end

function _get_rsync_version --description "Returns rsync's protocol version"
  rsync --version | grep -oi "protocol version .*\$" | cut -d' ' -f3
end
