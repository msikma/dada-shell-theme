# Dada Shell Theme © 2019

# Location used to retrieve the weather.
set -g _weather_loc "~Rotterdam+2e+Stampioendwarsstraat"

function doc
  mdv $argv | less -r
end

function weather --description "Queries wttr.in for the weather"
  #       .-.      Drizzle
  #      (   ).    13 °C
  #     (___(__)   ↗ 7 km/h
  #      ‘ ‘ ‘ ‘   10 km
  #     ‘ ‘ ‘ ‘    0.0 mm
  # Note: for help, run "curl wttr.in/:help" - or visit <https://github.com/chubin/wttr.in>.
  # Note: uses negative head value to erase the author name at the bottom.
  curl -s "wttr.in/$_weather_loc" \
    -H "Accept-Language: $dada_acceptlang" \
    | \
    ghead -n -2
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

function jv --description "Quick display of JSON files"
  set -x jv_json_file (pwd)/$argv[1]
  node -e "console.log(JSON.parse(require('fs').readFileSync(process.env.jv_json_file, 'utf8')));"
  set -e jv_json_file
end

function scrapemp3s
  wget -r -l1 -H -t3 -nd -N -np -A.mp3 -erobots=off $argv
end

function headers
  curl -sILk $argv | sed '$d'
end

function urlredirs --description "Displays URL redirects"
  if not count $argv > /dev/null
    echo 'usage: urlredirs "http://example.com/"'
    return
  end
  wget $argv[1] 2>&1 | grep 'Location:'
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
