# Dada Shell Theme © 2019

# ~/.cache/dada
# ~/.cache/dada/<backup timestamps are here>
# ~/.cache/dada/cron
# ~/.cache/dada/cron/cron_<ts>.log

set -g c_dir '/Users/'(whoami)'/.cache/dada/cron'
set -g c_file $c_dir'/cron_.log'

function __print --description "Prints command and saves it to file"
  echo $argv
  #echo $argv >> $c_file
end

function __dada_cron_open_file --description "Ensures the cache directory and file exists"
  mkdir -p $c_dir
  touch $c_file
end

function __print_cols
  #
end

#       .-.      Drizzle
#      (   ).    13 °C          
#     (___(__)   ↗ 7 km/h       
#      ‘ ‘ ‘ ‘   10 km          
#     ‘ ‘ ‘ ‘    0.0 mm  
function dadacron3
  curl -s "wttr.in" | sed -n 3,7p
end

function dadacron2
  set -l IFS
  set wtr (dadacron3)
  echo $wtr
end

function dada-cron --description "Runs cron job commands"
  set -l datestr (date +"%a, %b %d %Y %X")
  set -l c0 (set_color normal)
  set -l c1 (set_color yellow)
  set -l c2 (set_color blue)
  #__dada_cron_open_file
  
  __print -ne (set_color green)
  __print -n 'Dada Shell Theme: '
  __print (set_color yellow)"Cron job running"
  __print
  
  __print (set_color yellow)"Time:           "(set_color normal)$datestr
  
  __print_cols $c1"Timestamp:      "$c0"Backs up SQL databases"\
               $c2"Theme version:  "$c0"asdasd"\
               $c1"Something:      "$c0"ASDf "
end
