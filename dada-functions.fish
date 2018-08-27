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

# Displays help.
function help
  set c0 (set_color blue)
  set c1 (set_color white)
  set c2 (set_color purple)
  set c3 (set_color red)
  set c4 (set_color yellow)
  
  echo
  #echo -n "🌿"
  #echo (set_color green)" Dada shell theme"
  set_color normal
  echo "The following commands are available:"
  echo
  
  set lines $c0"sphp           $c1 Changes PHP version"\
            $c2"gits / g       $c1 Git status"\
            $c0"devices        $c1 Displays local computers"\
            $c2"gb             $c1 Last Git commits per branch"\
            $c0"headers        $c1 Displays headers for a URL"\
            $c2"gl             $c1 Git log with merge lines"\
            $c0"scrapemp3s     $c1 Scrapes MP3 files from a URL"\
            $c2"gsl            $c1 Git short log (one liners)"\
            $c0"cdbackup       $c1 Changes directory to backup dir"\
            $c2"gc             $c1 Displays Git commands help"\
            $c0"fdupes         $c1 Finds duplicate files by hash"\
            $c3"backup-music   $c1 Backs up music"\
            $c0"color          $c1 Adds a colored icon to a folder"\
            $c3"backup-files   $c1 Backs up ~/Files"\
            $c0"empty-trash    $c1 Empties the trash bin"\
            $c3"backup-zoo     $c1 Copies some music to Happy Zoo"\
            $c0"tldr <cmd>     $c1 Displays simple command help"\
            $c3"backup-src     $c1 Backs up source code dirs"\
            $c0"tree           $c1 Runs ls with tree structure"\
            $c3"backup-dbs     $c1 Backs up MySQL databases"\
  
  draw_columns $lines
  # Now the rest of the commands - all external applications.
  # Only things that are not part of Dada shell theme.
  draw_columns $c4"youtube-dl$c1      Downloads videos from Youtube"\
               $c4"streamlink$c1      Opens internet streams in VLC"\
               $c4"ascr$c1            Downloads art from social media"\
               $c4"weather$c1         Displays the current weather"\
               $c4"bat$c1             Improved version of cat"\
               $c4"glances$c1         Computer monitoring tool"\
               $c4"bbedit <file>$c1   Opens a file in BBEdit"\
               $c4"fd <str>$c1        Searches for files (alt. to find)"\
               $c4"ncdu$c1            Displays disk space usage"
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

function devices
  echo
  echo "The following devices are on the network:"
  echo
  set c0 (set_color red)
  set c1 (set_color white)
  cat /etc/hosts | grep --color=no -i "10.0.1" | sed "s/[^[:blank:]]\{1,\}/$c0&$c1/1"
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
