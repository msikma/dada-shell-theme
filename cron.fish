# Dada Shell Theme © 2019

# This file contains a Cron job function that runs periodically.
# The Cron job cache is located in ~/.cache/dada/cron/, and the log files
# contain a year and month such as 'cron_201905.log' for May 2019.

function dada-cron \
  --description "Runs Cron job commands"
  _cron_ensure_file
  _cron_add_start_log

  _cron_print (set_color green)"Dada Shell Theme: "(set_color yellow)"Cron job running"(set_color normal)
  
  _cron_print (set_color yellow)"Time: "(set_color normal)(date +"%a, %b %d %Y %X")
  _cron_print (set_color yellow)"File: "(set_color normal)$c_file_short

  _cron_print_cmd "ekizo-dl"
  _cron_run_cmd "ekizo-dl.py"
  _cron_print_cmd "weather" "Caching"
  _cache_weather
end

function cron-log \
  --description "Opens the latest Cron log"
  _cron_ensure_file
  tail -n 100 -f (_cron_path)
end
