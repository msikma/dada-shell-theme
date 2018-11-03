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

# Displays help.
function help
  set c0 (set_color blue)    # Regular commands
  set c1 (set_color white)
  set c2 (set_color purple)  # Git commands
  set c3 (set_color red)     # Backup commands
  set c4 (set_color yellow)  # External applications
  set c5 (set_color green)   # Commands that show external servers
  set c6 (set_color cyan)    # Shell theme management commands

  echo
  set_color normal
  echo "The following commands are available:"
  echo

  set lines $c0"sphp           $c1 Changes PHP version"\
            $c2"g              $c1 Git status"\
            $c0"tree           $c1 Runs ls with tree structure"\
            $c2"gith           $c1 Displays Git commands help"\
            $c0"headers        $c1 Displays headers for a URL"\
            $c2"gl             $c1 Git log with merge lines"\
            $c0"scrapemp3s     $c1 Scrapes MP3 files from a URL"\
            $c2"gb             $c1 Last Git commits per branch"\
            $c0"cdbackup       $c1 Changes directory to backup dir"\
            $c3"backup         $c1 Displays backup commands and info"\
            $c0"color          $c1 Adds a colored icon to a folder"\
            $c3"backup-music   $c1 Backs up music"\
            $c0"trash          $c1 Sends files to the OSX trash"\
            $c3"backup-files   $c1 Backs up ~/Files"\
            $c0"empty-trash    $c1 Empties the trash bin"\
            $c3"backup-zoo     $c1 Copies some music to Happy Zoo"\
            $c0"tldr <cmd>     $c1 Displays simple command help"\
            $c3"backup-src     $c1 Backs up source code dirs"\
            $c0"crc32u <file>  $c1 Prints CRC32 hash of file"\
            $c3"backup-dbs     $c1 Backs up MySQL databases"\
            $c0"projects       $c1 Prints recently edited projects"\
            $c3"backup-ftp     $c1 Backs up Cyberduck bookmarks"\
            $c0"fdupes         $c1 Finds duplicate files by hash"\
            $c5"devices        $c1 Displays local computers"\
            $c0"keys           $c1 Lists installed SSH keys"\
            $c5"servers$c1         Displays a list of servers"\
            $c0"proj           $c1 Displays current project info"\
            $c6"update         $c1 Updates Dada shell theme and bins"\
            $c0"jira           $c1 Lists Jira issue branches in repo"\
            $c6"dada-cron      $c1 Runs the theme's hourly cron script"\
            $c0"code <dir>$c1      Opens directory in VS Code"\
            $c4"imgfloppy      $c1 Copy floppy data to .img file"\
            $c0"updrepos       $c1 Updates all project repos"\
            $c4"youtube-dl$c1      Downloads videos from Youtube"\
            $c0"newfish <file>$c1  Creates a new Fish script"\
            $c4"streamlink$c1      Opens internet streams in VLC"\
            $c4"ascr$c1            Downloads art from social media"\
            $c4"weather$c1         Displays the current weather"\
            $c4"bat$c1             Improved version of cat"\
            $c4"glances$c1         Computer monitoring tool"\
            $c4"bbedit <file>$c1   Opens a file or dir in BBEdit"\
            $c4"fd <str>$c1        Searches for files (alt. to find)"\
            $c4"ncdu$c1            Shows directory disk space usage"\
            $c4"doc <file>$c1      Reads Markdown file in terminal"\
            $c4"vgmpfdl <url>$c1   Downloads albums from vgmpf.com"\
            $c4"khinsider      $c1 Downloads OSTs from khinsider.com"\

  draw_columns $lines
  echo
end

function cdbackup
  if not set -q hostname
    echo "$err \$hostname is not set"
    exit 1
  end
  set bdir "/Volumes/Files/Backups/"$hostname
  if not test -d $bdir
    echo "Error: Can't access backup directory: $bdir"
    exit 1
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
  set backup_dbs (backup_time_str "/Users/"(whoami)"/.cache/dada/backup-dbs")
  set backup_music (backup_time_str "/Users/"(whoami)"/.cache/dada/backup-music")
  set backup_files (backup_time_str "/Users/"(whoami)"/.cache/dada/backup-files")
  set backup_src (backup_time_str "/Users/"(whoami)"/.cache/dada/backup-src")
  set backup_ftp (backup_time_str "/Users/"(whoami)"/.cache/dada/backup-ftp")
  set backup_zoo (backup_time_str "/Users/"(whoami)"/.cache/dada/backup-zoo")
  set backup_config (backup_time_str "/Users/"(whoami)"/.cache/dada/backup-config")

  echo
  echo "Backup commands and status for $c3"(whoami)'@'(uname -n)"$c0:"
  echo
  draw_columns $c1"backup-dbs      "$c0"Backs up SQL databases"\
               $c2"MySQL backup:   "$c0"$backup_dbs"\
               $c1"backup-music    "$c0"Backs up music"\
               $c2"Music backup:   "$c0"$backup_music"\
               $c1"backup-src      "$c0"Backs up source code directories"\
               $c2"Source backup:  "$c0"$backup_src"\
               $c1"backup-files    "$c0"Backs up various other things"\
               $c2"Files backup:   "$c0"$backup_files"\
               $c1"backup-zoo      "$c0"Backs up music to the Happy Zoo"\
               $c2"Zoo backup:     "$c0"$backup_zoo"\
               $c1"backup-ftp      "$c0"Backs up FTP bookmarks"\
               $c2"FTP backup:     "$c0"$backup_ftp"\
               $c1"backup-config   "$c0"Backs up ~/.config/ dirs"\
               $c2"Config backup:  "$c0"$backup_config"

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
