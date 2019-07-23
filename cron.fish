# Dada Shell Theme © 2019

# This file contains a Cron job function that runs periodically.
# The Cron job cache is located in ~/.cache/dada/cron/, and the log files
# contain a year and month such as 'cron_201905.log' for May 2019.

set cron_name com.dada.crontab
set cron_plist $cron_name.plist
set cron_plist_path ~/Library/LaunchAgents/$cron_plist

# Note: somehow set_color commands causes lines not to be logged properly,
# even when the colors are stripped out before saving them to the file.
# This only occurs when the script is being run by launchd.
# Presumably there's a problem with set_color when Fish Shell doesn't have a tty.
function dada-cron \
  --description "Runs Cron job commands"
  _cron_ensure_file
  _cron_add_start_log

  _cron_print "Dada Shell Theme: Cron job running"

  _cron_print "Time: "(date +"%a, %b %d %Y %X")
  _cron_print "File: "(_cron_file)

  if test -d ~/.config/ekizo-dl
    _cron_print_cmd "ekizo-dl"
    _cron_run_cmd "ekizo-dl.py"
  end
  _cron_print_cmd "weather" "Caching"
  _cache_weather_safe

  _cron_print "Done."
end

function cron-info \
  --description "Displays info about the active Cron job"
  set interval (cat $cron_plist_path | sed -e '/key>StartInterval/,/integer/!d' | grep -o "\([0-9]\+\)")
  set active (launchctl list | grep $cron_name)
  if [ (count $active) -eq 0 ]
    echo "cron-info: error: Cron script is not installed."
    return 1
  else
    echo "cron-info: Cron script is installed and runs every $interval seconds."
  end
end

function cron-log \
  --description "Opens the latest Cron log"
  _cron_ensure_file
  tail -n 100 -f (_cron_path)
end

function cron-install \
  --description "Ensures that the Cron script is installed"
  set installed (launchctl list | grep com.dada.crontab | wc -l | bc)
  if not test -e $cron_plist_path
    cp "$DADA"etc/$cron_plist $cron_plist_path
    launchctl load $cron_plist_path
    echo "Installed launch agent "(set_color yellow)"$cron_plist"(set_color normal)"."
  else
    echo "Launch agent "(set_color yellow)"$cron_plist"(set_color normal)" is already installed."
  end
end
