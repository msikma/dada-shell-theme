# Dada Shell Theme © 2019, 2020

set -g __fish_git_prompt_showdirtystate 1
set -g __fish_git_prompt_showstashstate 1
set -g __fish_git_prompt_showuntrackedfiles 1
set -g __fish_git_prompt_describe_style 'branch'
set -g __fish_git_prompt_showcolorhints 1
set -g __fish_git_prompt_show_informative_status 1

set -g __fish_git_prompt_char_stateseparator ' '
set -g __fish_git_prompt_char_dirtystate '+'
set -g __fish_git_prompt_char_invalidstate '×'
set -g __fish_git_prompt_char_untrackedfiles '…'
set -g __fish_git_prompt_char_stagedstate '*'
set -g __fish_git_prompt_char_cleanstate '✓'

set -g __fish_git_prompt_color_prefix yellow
set -g __fish_git_prompt_color_suffix yellow
set -g __fish_git_prompt_color_branch yellow
set -g __fish_git_prompt_color_cleanstate green

set -g __fish_prompt_cwd (set_color cyan)
set -g __fish_prompt_normal (set_color normal)

# Display the hostname in the prompt if we're running on a server.
if [ "$IS_DADA_SERVER" = "1" ]
  set -gx dada_left_prompt_prefix "$dada_hostname "
end

# In case we want to make a network request.
# This is modified to the correct value when fish_greeting is run.
set -gx dada_ua "Dada Shell Theme/unknown"

# On what column the weather should be shown.
set -g _weather_col 68

function _greeting_weather --description "Shows the weather in the greeting message"
  set weather (_get_weather)
  # Don't do anything if the weather file is empty.
  # This happens if the server is down.
  if test -z "$weather"
    return
  end
  # It can also contain an HTML error, or an error if the service ran out of API calls.
  if string match -q -- "*nginx*" $weather
    return
  end
  if string match -q -- "*default city*" $weather
    return
  end
  # Display the weather at the right place.
  for n in (seq (count $weather))
    set -l m (math $n + 1)
    echo -ne "\033[$m;""$_weather_col""H"
    echo $weather[$n]
  end
  # Move the cursor back to the start position.
  echo -ne "\033[2;0H"
end

# Returns colors for use in the Fish greeting.
function _theme_greeting_color \
  --argument-names color \
  --description "Returns colors for use in the greeting"
  if [ "$color" = "green" ]
    echo "🌿"
    echo (set_color "green")
    echo (set_color "2b4e03")
  end
  if [ "$color" = "blue" ]
    echo "🌎"
    echo (set_color "blue")
    echo (set_color "1b2b9c")
  end
  if [ "$color" = "red" ]
    echo "🔥"
    echo (set_color "red")
    echo (set_color "703")
  end
end

# Prints a greeting message when logging in.
# This displays some basic information such as the current user and time,
# as well as information about the latest backups.
function fish_greeting --description 'Display the login greeting'
  # Prints the current weather
  _greeting_weather
  # Sets the current Dada Shell Theme version, e.g. master-12-abcdef
  # Make sure we return to where we were.
  pushd $DADA
  set theme_version_main (get_version_short)
  set theme_version_hash (get_version_hash)
  set theme_version "$theme_version_main [$theme_version_hash]"
  set last_commit (get_last_commit)
  set last_commit_rel (get_last_commit_rel)
  popd

  # Modify our user agent to contain the version string.
  set -gx dada_ua "Dada Shell Theme/$theme_version_main ($dada_hostname_local)"

  # Display the gray uname section.
  set_color brblack
  echo (get_short_uname)
  echo (uptime)
  echo

  # Sets the colors used in the theme version name.
  set colors (_theme_greeting_color "green")

  # Display the theme name.
  echo -n $colors[1]
  echo -n $colors[2]
  echo -n " Dada shell theme"
  echo -n $colors[3]
  echo -n " on "
  echo -n $colors[2]
  echo (get_system_version)
  echo -n $colors[3]
  echo -n "Type "
  echo -n $colors[2]
  echo -n "help"
  echo -n $colors[3]
  echo " to see available commands"
  echo

  # Display columns containing user and theme information.
  set main_cols \
    "User:"             "$dada_uhostname_local ("(get_curr_ip)")" \
    "Disk usage:"       (get_disk_usage) \

  set theme_cols \
    "Theme version:"    "$theme_version" \
    "Last commit:"      "$last_commit ($last_commit_rel)" \

  # Retrieves dates for when we last backed up important data.
  set backup_cols \
    "MySQL backup:"     (backup_time_str "$_backup_dir/backup-dbs") \
    "Music backup:"     (backup_time_str "$backup_dir_music") \
    "Source backup:"    (backup_time_str "$_backup_dir/backup-src") \
    "Files backup:"     (backup_time_str "$_backup_dir/backup-files") \

  # Print all columns.
  set cols_all
  set -a cols_all (_add_cmd_colors (set_color yellow) $main_cols)
  set -a cols_all (_add_cmd_colors (set_color blue) $theme_cols)
  if [ "$DADA_FISH_ENV" = "desktop" ]
    set -a cols_all (_add_cmd_colors (set_color magenta) $backup_cols)
    _iterate_help $cols_all
  end
  if [ "$DADA_FISH_ENV" = "server" ]
    if type -q landscape-sysinfo
      landscape-sysinfo | read -d \n -z info
      set uptime_val (uptime | sed 's/^.*load/load/' | cut -d':' -f2 | string sub -s 2)
      set mem (echo $info | sed '3q;d' | string sub -s 26)
      set swap (echo $info | sed '4q;d' | string sub -s 26)
      set proc (echo $info | sed '5q;d' | string sub -s 26)
      
      set info_cols \
        "System load:"    "$uptime_val" \
        "Memory usage:"   "$mem" \
        "Swap usage:"     "$swap" \
        "Processes:"      "$proc"
      
      set -a cols_all (_add_cmd_colors (set_color red) $info_cols)
      _iterate_help $cols_all
    end
  end
  echo

  # Run whatever else we need to do specifically for this environment.
  source $DADA"env/welcome/$DADA_FISH_ENV.fish"
end

# Copied from one of the default prompts and edited a bit.
# Displays a shortened cwd and VCS information.
function fish_prompt --description 'Write out the left prompt'
  announce_next_alert
  if test -n "$STY"
    set dada_screen_prompt (set_color yellow)"($STY) "(set_color normal)
  end
  echo -n -s $dada_left_prompt_prefix $dada_screen_prompt "$__fish_prompt_cwd" (prompt_pwd) "$__fish_prompt_normal" (in_git_dir_or_subdir) "$__fish_prompt_normal" '> '
end

# Right side prompt. Displays a timestamp, and a warning emoji on error.
function fish_right_prompt --description 'Write out the right prompt'
  set -l exit_code $status
  set -l datestr (date +"%a, %b %d %Y %X")
  if test $exit_code -ne 0
    echo -n "⚠️  "
  end

  set_color 222
  echo $datestr
  set_color normal
end

# Displays additional help info if specified.
function display_help_txt \
  --description 'Displays additional help text' \
  --on-variable dirprev

  if status --is-command-substitution
    return
  end

  if [ ! -f ./help.projinfo.txt ]
    return
  end

  if begin
    [ "$NO_DIRPREV_HOOK" = 1 ]; or \
    [ (count $dirprev) -lt 3 ]; end
    return
  end

  cat ./help.projinfo.txt
end

# Displays project info on directory change.
function display_project_info \
  --description 'Displays project info after changing to a project directory' \
  --on-variable dirprev

  # Run a quick check to see if this is a project directory.
  if begin
    [ ! -f ./package.json ]; and \
    [ ! -f ./requirements.txt ]; and \
    [ ! -f ./setup.py ]; and \
    [ ! -f ./setup.cfg ]; and \
    [ ! -f ./composer.json ]; end
    return
  end

  # Return if this is isn't a command directly run by the user themselves in the shell.
  if status --is-command-substitution
    return
  end

  # Check if displaying project info has temporarily been turned off, e.g. for a script.
  if begin
    [ "$NO_DIRPREV_HOOK" = 1 ]; or \
    [ (count $dirprev) -lt 3 ]; end
    return
  end

  # Display project info.
  projinfo
end
