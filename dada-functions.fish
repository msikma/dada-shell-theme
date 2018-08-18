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
  
  echo
  #echo -n "🌿"
  #echo (set_color green)" Dada shell theme"
  set_color normal
  echo "The following commands are available:"
  echo
  
  set l1 $c0"sphp         $c1 Changes PHP version"
  set l2 $c0"devices      $c1 Displays local computers"
  set l3 $c0"scrapemp3s   $c1 Scrapes MP3 files from a URL"
  set l4 $c0"headers      $c1 Displays headers for a URL"
  set l5 $c2"gb           $c1 Last Git commits per branch"
  set l6 $c2"gits / g     $c1 Git status"
  set l7 $c2"gl           $c1 Git log with merge lines"
  set l8 $c2"gsl          $c1 Git short log (one liners)"
  set l9 $c3"backup-dbs   $c1 Backs up MySQL databases"
  set la $c3"backup-music $c1 Backs up music"
  set lb $c3"backup-files $c1 Backs up ~/Files"
  set lc $c3"backup-src   $c1 Backs up source code dirs"
  set le $c3"backup-zoo   $c1 Copies some music to Happy Zoo"
  
  set lines $l1 $l6 $l2 $l5 $l4 $l7 $l3 $l8 $l9 $la $lb $lc $le
  
  draw_columns $lines
  echo
  set_color normal
end

function devices
  cat /etc/hosts | grep --color=no -i "10.0.1"
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
