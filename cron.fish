# Dada Shell Theme © 2019, 2020

# This file contains a Cron job function that runs periodically.
# The Cron job cache is located in ~/.cache/dada/cron/, and the log files
# contain a year and month such as 'cron_201905.log' for May 2019.

# Base directory for timestamps of Cron commands.
set -g _cron_date_dir $home"/.cache/dada/cron_timestamps"

set cron_name com.dada.crontab
set cron_plist $cron_name.plist
set cron_plist_path ~/Library/LaunchAgents/$cron_plist

# Note: somehow set_color commands causes lines not to be logged properly,
# even when the colors are stripped out before saving them to the file.
# This only occurs when the script is being run by launchd.
# Presumably there's a problem with set_color when Fish Shell doesn't have a tty.
function dada-cron \
  --description "Runs Cron job commands"
  _cron_ensure_dir
  _cron_add_start_log

  _cron_print "Dada Shell Theme: Cron job running"

  _cron_print "Time: "(date +"%a, %b %d %Y %X")
  _cron_print "File: "(_cron_file)

  # It's possible that creating mail alerts could fail, in case
  # the cookie we're using for Gmail is outdated.
  # In that case, create an alert notifying this.
  _cron_print_cmd "mail alerts" "Creating"
  if not _make_new_alerts
    #make_alert 'gmail' 'Gmail' 'warning' "-" "0" "Unable to log in with provided cookie file"\n"No alerts will be generated until this is resolved. See the cookie file in ~/.config/ms-gmail-js/cookies.txt and update it so that 'ms-gmail-cli --action list --no-cache --output json' can run successfully again. To open Gmail in basic HTML mode, use this link: https://mail.google.com/mail/u/0/h/1pq68r75kzvdr/?v%3Dlui."
  end

  # Run video archiving script.
  cron_cmd_timeago "vidarc" "3600"
  if [ "$status" -eq 0 ]
    vidarc --check &> /dev/null
    if [ "$status" -eq 0 ]
      _cron_print_cmd "vidarc"
      _cron_run_cmd "vidarc" "--archive"
    else
      _cron_print "vidarc is not set up properly"
    end
  else
    _cron_print "Deferring running vidarc"
  end

  _cron_print_cmd "yt-dlp" "Upgrading"
  pip3 install yt-dlp --upgrade

  if [ -d "$SLSK_CHAT_LOGS_DIR_SRC" ]
    _cron_print "Moving Soulseek chat logs"
    mkdir -p "$SLSK_CHAT_LOGS_DIR_DST"
    cp -r "$SLSK_CHAT_LOGS_DIR_SRC" "$SLSK_CHAT_LOGS_DIR_DST"
    rm -rf "$SLSK_CHAT_LOGS_DIR_SRC"
  end

  # Run Bryce conversion script if the directory exists.
  if [ -d "$DADA_BRYCE_DIR" ]
    _cron_print_cmd "convert_bryce.fish"
    echo 'd' "$DADA_BRYCE_DIR"
    convert_bryce.fish
  end

  _cron_print_cmd "Jira tasks" "Caching"
  _cache_tasks

  if [ -d ~/.config/ekizo ]
    _cron_print_cmd "ekizo"
    _cron_run_cmd "ekizo"
    if [ "$status" -ne 0 ]
      _cron_print "ekizo did not run properly"
    end
  end
  _cron_print_cmd "weather" "Caching"
  _cache_weather_safe

  _cron_print "Done."
end

function cron_cmd_timeago \
  --description "Checks if it's been a certain period of time since a cron command was last run" \
  --argument-names cmd timelimit
  # Note: this is used to check if we should run a cron command.
  # Some cron commands don't need to run very often, so a timestamp is used
  # to check how long it's been since it last ran.
  # If this returns true, the command should be run.
  set file "$_cron_date_dir/$cmd.txt"
  timeago_file "$file" "$timelimit"
end

function timeago_file \
  --description "Checks if it's been a certain period of time since the last command execution" \
  --argument-names tsfile timelimit
  # If the file does not exist, it means we never ran this command before.
  if [ ! -e "$tsfile" ]
    true
    return
  end
  set now (date +%s)
  set then (date -jf "%a, %b %d %Y %X %z" (cat "$tsfile") +%s)
  timeago "$now" "$then" "$timelimit"
end

function timeago \
  --description "Checks if it's been a certain period of time since the last command execution" \
  --argument-names time_a time_b timelimit
  set diff (math "$time_b" + "$timelimit")
  test "$time_a" -gt (math "$time_b" + "$timelimit")
end

set cron_cmds \
  "vidarc"            "Backs up Twitch account" \
  "ekizo"                "Scrapes Mandarake cel auctions" \

function cron-info \
  --description "Displays latest Cron job results"
  mkdir -p "$_cron_date_dir"
  echo
  echo "Status of Cron jobs for "(set_color green)"$dada_uhostname_local"(set_color normal)":"
  echo
  set cron_times \
    "Last run:"         (backup_time_str "$_cron_date_dir/vidarc.txt") \
    "Last run:"         (backup_time_str "$_cron_date_dir/ekizo.txt") \

  set cols_all
  set -a cols_all (_add_cmd_colors (set_color red) $cron_cmds)
  set -a cols_all (_add_cmd_colors (set_color magenta) $cron_times)
  _iterate_help $cols_all
  echo
  cron-installed
  echo
end

function cron-installed \
  --description "Displays info about the active Cron job"
  set interval (cat $cron_plist_path | sed -e '/key>StartInterval/,/integer/!d' | grep -o "\([0-9]\+\)")
  set active (launchctl list | grep $cron_name)
  if [ (count $active) -eq 0 ]
    echo "cron-installed: error: Cron script is not installed."
    return 1
  else
    echo "Cron script is installed and runs every $interval seconds."
  end
end

function cron-log \
  --description "Opens the latest Cron log"
  _cron_ensure_dir
  tail -n 500 -f (_cron_path)
end

function cron-install \
  --description "Ensures that the Cron script is installed"
  if [ "$DADA_FISH_ENV" != "desktop" ]
    echo "Can't install cron script due to environment being "(set_color green)"server"(set_color normal)"."
    return
  end
  set installed (launchctl list | grep com.dada.crontab | wc -l | bc)
  if not test -e $cron_plist_path
    cp "$DADA"etc/$cron_plist $cron_plist_path
    launchctl load $cron_plist_path
    echo "Installed launch agent "(set_color yellow)"$cron_plist"(set_color normal)"."
  else
    echo "Launch agent "(set_color yellow)"$cron_plist"(set_color normal)" is already installed."
  end
end
