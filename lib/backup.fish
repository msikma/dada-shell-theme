# Dada Shell Theme © 2019

set _rsync_min_prot_version 31

function backup --description "Displays backup commands and info"
  # Colors
  set c0 (set_color white)
  set c1 (set_color red)     # Backup commands
  set c2 (set_color purple)  # Backup info
  set c3 (set_color green)   # User info

  # Get a string of when the backup was done
  set backup_3ds (backup_time_str "/Users/"(whoami)"/.cache/dada/backup-3ds")
  set backup_config (backup_time_str "/Users/"(whoami)"/.cache/dada/backup-config")
  set backup_dbs (backup_time_str "/Users/"(whoami)"/.cache/dada/backup-dbs")
  set backup_files (backup_time_str "/Users/"(whoami)"/.cache/dada/backup-files")
  set backup_ftp (backup_time_str "/Users/"(whoami)"/.cache/dada/backup-ftp")
  set backup_games (backup_time_str "/Users/"(whoami)"/.cache/dada/backup-games")
  set backup_music (backup_time_str "/Users/"(whoami)"/.cache/dada/backup-music")
  set backup_src (backup_time_str "/Users/"(whoami)"/.cache/dada/backup-src")
  set backup_zoo (backup_time_str "/Users/"(whoami)"/.cache/dada/backup-zoo")

  echo
  echo "Backup commands and status for $c3"(whoami)'@'(uname -n)"$c0:"
  echo
  draw_columns $c1"backup-3ds      "$c0"Backs up 3DS SD card"\
               $c2"3DS SD backup:  "$c0"$backup_3ds"\
               $c1"backup-config   "$c0"Backs up ~/.config/ dirs"\
               $c2"Config backup:  "$c0"$backup_config"\
               $c1"backup-dbs      "$c0"Backs up SQL databases"\
               $c2"MySQL backup:   "$c0"$backup_dbs"\
               $c1"backup-files    "$c0"Backs up various other things"\
               $c2"Files backup:   "$c0"$backup_files"\
               $c1"backup-ftp      "$c0"Backs up FTP bookmarks"\
               $c2"FTP backup:     "$c0"$backup_ftp"\
               $c1"backup-games    "$c0"Backs up game content"\
               $c2"Games backup:   "$c0"$backup_games"\
               $c1"backup-music    "$c0"Backs up music"\
               $c2"Music backup:   "$c0"$backup_music"\
               $c1"backup-src      "$c0"Backs up source code directories"\
               $c2"Source backup:  "$c0"$backup_src"\
               $c1"backup-zoo      "$c0"Backs up music to the Happy Zoo"\
               $c2"Zoo backup:     "$c0"$backup_zoo"\

  echo
end

function get_last_backup \
  --argument-names script \
  --description "Returns last backup time for a script"
  backup_time_rel $home"/.cache/dada/"$script
end

function set_last_backup \
  --argument-names script \
  --description "Saves the current timestamp as the latest backup time"
  mkdir -p $home"/.cache/dada"
  echo (date +"%a, %b %d %Y %X %z") > $home"/.cache/dada/"$script
end

function copy_rsync \
  --argument-names src dst \
  --description "Copies files from source to destination using rsync"
  # Note: doesn't copy extended attributes (-X). Change if we're upgrading to a better fs.
  rsync -ahrEAtNS8 --progress --exclude=".*" --exclude="Icon*" --stats $src $dst
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

# Prints out the latest backup time in YYYY-mm-dd and ('x days ago') format.
function backup_time_rel --description "Prints the time a backup was last performed, relative only"
  set bfile $argv[1]
  set now (date +%s)
  if test -e $bfile
    set bu (cat $bfile)
    set bu_unix (backup_date_unix $bu)
    set bu_rel (time_ago $now $bu_unix)
    set bu_diff (math "$now - $bu_unix")
    echo "$bu_rel"
  else
    echo '(unknown)'
  end
end

function check_needed_dirs --description "Checks if an array of directories exists and is accessible"
  for n in (seq (count $needdirs))
    set s $needdirs[$n]
    if not test -d $s
      echo "$err Can't access target directory: "$s
      exit 1
    end
  end
end

function check_rsync_version \
  --argument-names script \
  --description "Check whether rsync's version is new enough for the backup scripts"

  if set -q script
    set prefix $script": Error:"
  end
  set rsv (_get_rsync_version)
  if [ $rsv -lt $_rsync_min_prot_version ]
    echo $prefix "rsync protocol version is too low ($rsv); update to a newer version to use this script."
  end
end

function _get_rsync_version --description "Returns rsync's protocol version"
  rsync --version | grep -oi "protocol version .*\$" | cut -d' ' -f3
end
