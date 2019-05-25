# Dada Shell Theme © 2019

# Base directory for Cron job cache.
set -g _c_dir '/Users/'(whoami)'/.cache/dada/cron'
# Placeholder for the full path to the Cron log (has a date added to it).
set -g _c_file_full $_c_dir'/cron_DATE.log'
# Filename of the Cron log.
set -g _c_file_short 'cron_DATE.log'

# Weather cache location.
set -g _weather_cache '/Users/'(whoami)'/.cache/dada/weather.txt'

# Prints out the cached weather data.
function _get_weather
  if not test -e $_weather_cache
    _cache_weather
  end
  cat ~/.cache/dada/weather.txt
end

# Caches the weather output, but only the first item.
function _cache_weather
  weather | sed -n 3,7p > $_weather_cache
end


function _cron_run_cmd \
  --description "Runs a command and prints its output to the screen and log" \
  --argument-names cmd
  for line in ($cmd)
    _cron_print $line
  end
end

function _cron_print_cmd \
  --description "Prints a command we're running" \
  --argument-names cmd str dots
  if [ ! -n "$str" ]
    set str 'Running'
  end
  if [ ! -n "$dots" ]
    set dots '...'
  end
  _cron_print (set_color yellow)$str" "(set_color normal)"$cmd"(set_color yellow)$dots(set_color normal)
end

function _cron_path \
  --description "Prints the full path to the current Cron log file"
  echo $_c_file_full
end

function _cron_print \
  --description "Prints command and saves it to file"
  echo $argv
  echo "["(date -u +"%Y-%m-%dT%H:%M:%SZ")"]" $argv | stripcolor >> $_c_file_full
end

function _cron_log \
  --description "Prints command only to the log, not to stdout"
  echo $argv >> $_c_file_full
end

function _cron_ensure_file \
  --description "Ensures the cache directory and file exists"
  mkdir -p $_c_dir
  set -g _c_file_full $_c_dir'/cron_'(date +"%Y%m")'.log'
  set -g _c_file_short 'cron_'(date +"%Y%m")'.log'
  touch $_c_file_full
end

function _cron_add_start_log \
  --description "Marks the start of a new log section"
  _cron_log '---- Cron start: '(date)
end
