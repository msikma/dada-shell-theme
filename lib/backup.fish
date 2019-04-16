set _rsync_min_prot_version 31

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
