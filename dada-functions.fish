source $DADA"functions/backup.fish"
source $DADA"functions/help.fish"
source $DADA"functions/mysql.fish"
source $DADA"functions/rip-files.fish"

set a_secs
set a_ms

function timer_start --description "Saves the current time in ms to compare later"
  set a_secs (gdate +%s)
  set a_ms (gdate +%N)
end

function timer_end --description "Prints the difference between timer_start and now"
  set b_secs (gdate +%s)
  set b_ms (gdate +%N)

  awk "BEGIN{ print $b_secs.00$b_ms - $a_secs.00$a_ms; }"
end

function weather --description "Queries wttr.in for the weather"
	# Note: uses negative head value to erase the author name at the bottom.
	curl -s "wttr.in" \
		-H "Accept-Language: $dada_acceptlang" \
		| \
		ghead -n -2
end

function jv --description "Quick display of JSON files"
  set -x jv_json_file (pwd)/$argv[1]
  node -e "console.log(JSON.parse(require('fs').readFileSync(process.env.jv_json_file, 'utf8')));"
  set -e jv_json_file
end

# Opens 'code' or 'code-insiders' if that's the one we use on this machine.
# Use like e.g.: code . # opens current dir in code
function code
  if not test -d "$argv"
    echo "code: Error: can't find ""$argv"
    return 1
  end
  code-insiders $argv
end

# I forgot what this is
function drewdrew
  for x in (seq 500)
    set y (math $x + 1)
    ffmpeg -y -i drew$x.mp4 -vf fps=20,scale=320:-1:flags=lanczos,palettegen palette.png
    ffmpeg -i drew$x.mp4 -i palette.png -filter_complex "fps=20,scale=320:-1:flags=lanczos[x];[x][1:v]paletteuse" drew$x.gif
    rm palette.png
    ffmpeg -f gif -i drew$x.gif drew$y.mp4
  end
end

function urlredirs --description "Displays URL redirects"
  if not count $argv > /dev/null
    echo 'usage: urlredirs "http://example.com/"'
    return
  end
  wget $argv[1] 2>&1 | grep 'Location:'
end

# Makes a new Fish script. Invoke like: 'newfish file.fish'.
function newfish --description "Makes a new Fish script"
  echo "#!/usr/bin/env fish"\n > $argv[1]; chmod +x $argv[1];
end

function keys --description "Displays keys installed for this user"
  echo
  echo "Installed keys for "(set_color green)(whoami)(set_color normal)" in "(set_color yellow)"~/.ssh/"(set_color normal)
  echo
  set c0 (set_color yellow)
  set c1 (set_color normal)
  set c2 (set_color blue)
  set col 20

  set pubs (ls ~/.ssh/*.pub)
  set active (ssh-add -l)
  for key in $pubs
    set key (basename $key | sed 's/\.[^.]*$//')
    set installed 0
    for act in $active
      set sz (echo $act | cut -d' ' -f1)
      set type (echo $act | cut -d' ' -f4)
      set path (echo $act | cut -d' ' -f3)
      if [ (echo $path | grep -i "$key\$") ];
        set len (string length $key)
        set rem (math "$col - $len")
        echo -n $c0$key
        echo -n (string repeat ' ' -n $rem)
        echo $sz bit $type - installed$c1
        set installed 1
      end
    end
    if [ $installed -eq 0 ];
      set len (string length $key)
      set rem (math "$col - $len")
      echo -n $c2$key
      echo -n (string repeat ' ' -n $rem)
      echo not installed$c1
    end
  end
  echo
end

# Updates the shell theme
function update
  pushd "/Users/"(whoami)"/.config/dada/"
  set old (get_version_short)
  set nvm (git pull)
  set new (get_version_short)
  if [ $old != $new ]
    echo "Updated Dada Shell Theme from "(set_color blue)$old(set_color normal)" to version "(set_color red)$new(set_color normal)"."
  else
    echo "You are already on the latest version of Dada Shell Theme, "(set_color red)$new(set_color normal)"."
  end
  popd
end

function filesize_bytes --description "Prints the size of a file in bytes"
  stat -f%z $argv[1]
end

function filesize --description "Prints a human readable filesize"
  ls -la $argv[1] | cut -f2 -d' '
end

function filelines --description "Returns number of lines in a file as an integer"
  wc -l < $argv[1] | tr -d '[:space:]'
end

function in_git_dir --description "Returns whether we're inside of a Git project"
	test -f ./.git/index
end

function cdbackup
  if not set -q dada_hostname
    echo "$err \$dada_hostname is not set"
    return
  end
  set bdir "/Volumes/Files/Backups/"$dada_hostname
  if not test -d $bdir
    echo "Error: Can't access backup directory: $bdir"
    return
  end
  echo $bdir
  cd $bdir
end

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

function devices
  echo
  echo "The following devices are on the network:"
  echo
  set c0 (set_color red)
  set c1 (set_color white)
  cat /etc/hosts | grep --color=no -i "#device" | sed "s@ #device@@" | sed "s/[^[:blank:]]\{1,\}/$c0&$c1/1"
  echo
end

function servers
  echo
  echo "The following servers are available:"
  echo
  set c0 (set_color green)
  set c1 (set_color white)
  cat /etc/hosts | grep --color=no -i "#server" | sed "s@ #server@@" | sed "s/[^[:blank:]]\{1,\}/$c0&$c1/1"
  echo
end

function video2gif
  ffmpeg -y -i $argv[1] -vf fps=20,scale=320:-1:flags=lanczos,palettegen palette.png
  ffmpeg -i $argv[1] -i palette.png -filter_complex "fps=20,scale=320:-1:flags=lanczos[x];[x][1:v]paletteuse" $argv[1].gif
  rm palette.png
end

function scrapemp3s
  wget -r -l1 -H -t3 -nd -N -np -A.mp3 -erobots=off $argv
end

function findfile
  find / -name $argv 2> /dev/null
end

function headers
  curl -sILk $argv | sed '$d'
end
