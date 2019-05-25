# Dada Shell Theme © 2019

# This file contains a Cron job function that runs periodically.
# The Cron job cache is located in ~/.cache/dada/cron/, and the log files
# contain a year and month such as 'cron_201905.log' for May 2019.

set cron_name com.dada.crontab
set cron_plist $cron_name.plist
set cron_plist_path ~/Library/LaunchAgents/$cron_name

function dada-cron \
  --description "Runs Cron job commands"
  _cron_ensure_file
  _cron_add_start_log

  _cron_print (set_color green)"Dada Shell Theme: "(set_color yellow)"Cron job running"(set_color normal)

  _cron_print (set_color yellow)"Time: "(set_color normal)(date +"%a, %b %d %Y %X")
  _cron_print (set_color yellow)"File: "(set_color normal)(_cron_file)

  if test -d ~/.config/ekizo-dl
    _cron_print_cmd "ekizo-dl"
    _cron_run_cmd "ekizo-dl.py"
  end
  _cron_print_cmd "weather" "Caching"
  _cache_weather

  _cron_print (set_color green)"Done."(set_color normal)
end

function cron-log \
  --description "Opens the latest Cron log"
  _cron_ensure_file
  tail -n 100 -f (_cron_path)
end

function cron-install \
  --description "Ensures that the Cron script is installed"
  set installed (launchctl list | grep com.dada.crontaab | wc -l | bc)
  if not test -e $cron_plist_path
    cp "$DADA"etc/$cron_plist $cron_plist_path
    launchctl load $cron_plist_path
    echo "Installed launch agent "(set_color yellow)"$cron_plist"(set_color normal)"."
  else
    echo "Launch agent "(set_color yellow)"$cron_plist"(set_color normal)" is already installed."
  end
end
