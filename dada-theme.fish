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

# CWD color
set -g __fish_prompt_cwd (set_color cyan)
set -g __fish_prompt_normal (set_color normal)

# Hostname, used in several backup scripts.
set -gx hostname (hostname -s)

# Copied from one of the default prompts and edited a bit.
# Displays a shortened cwd and VCS information.
function fish_prompt --description 'Write out the left prompt'
  echo -n -s "$__fish_prompt_cwd" (prompt_pwd) "$__fish_prompt_normal" (faster_vcs) "$__fish_prompt_normal" '> '
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

# Prints out the latest backup time in YYYY-mm-dd and ('x days ago') format.
function backup_time_str --description 'Prints the time a backup was last performed'
  set bfile $argv[1]
  set now (date +%s)
  
  # If a backup is older than a week, display the value in yellow.
  # If it's older than a month, display the value in red.
  set yellow_cutoff 604800
  set red_cutoff 2628000
  
  if test -e $bfile
    set bu (cat $bfile)
    set bu_unix (backup_date_unix $bu)
    set bu_abs (date -r $bu_unix +%Y-%m-%d)
    set bu_rel (time_ago $now $bu_unix)
    set bu_diff (math "$now - $bu_unix")
    set color (set_color normal)
    set warn ""
    if [ $bu_diff -gt $yellow_cutoff ]
      set color (set_color yellow)
      set warn " ⚠️"
    end
    if [ $bu_diff -gt $red_cutoff ]
      set color (set_color red)
      set warn " ⚠️"
    end
    echo "$color$bu_abs ($bu_rel)$warn"(set_color normal)
  else
    echo 'unknown'
  end
end

# Prints a greeting message when logging in.
# This displays some basic information such as the current user and time,
# as well as information about the latest backups.
function fish_greeting --description 'Display the login greeting'
  # Disk usage in %
  set disk_usage_perc (df / | tail -n1 | sed "s/  */ /g" | cut -d' ' -f 5 | cut -d'%' -f1)
  # Disk usage in GB, one decimal
  set disk_usage_gb (math --scale=1 "("(df / | tail -n1 | sed "s/  */ /g" | cut -d' ' -f 4)"*512)/1000000000")
  # Total disk size in GB, one decimal
  set disk_total_gb (math --scale=1 "("(df / | tail -n1 | sed "s/  */ /g" | cut -d' ' -f 2)"*512)/1000000000")
  # user@hostname
  set user (whoami)'@'(uname -n)
  # Current IP (10.0.1.3)
  set currip (ifconfig | grep inet | grep broadcast | cut -d' ' -f 2 | head -n 1)
  # Current Dada-theme version, e.g. master-12-abcdef
  # Make sure we return to where we were.
  set dir (pwd)
  cd ~/.config/dada
  set version (get_version)
  set last_commit (get_last_commit)
  set last_commit_rel (get_last_commit_rel)
  cd "$dir"
  
  set backup_dbs (backup_time_str "/Users/msikma/.cache/dada/backup-dbs")
  set backup_music (backup_time_str "/Users/msikma/.cache/dada/backup-music")
  set backup_files (backup_time_str "/Users/msikma/.cache/dada/backup-files")
  set backup_source (backup_time_str "/Users/msikma/.cache/dada/backup-source")
  
  # Display the gray uname section.
  set_color brblack
  echo (uname -v)
  uptime
  echo
  
  # Display the theme name.
  echo -n "🌿"
  set_color green
  #echo -n "🌎"
  #set_color blue
  #echo -n "🔥"
  #set_color red
  echo " Dada shell theme"
  set_color normal
  echo
  
  # Display the info columns.
  set c0 (set_color purple)
  set c1 (set_color white)
  set c2 (set_color blue)
  set c3 (set_color yellow)

  set l1 $c3"User:           $c1$user ($currip)"
  set l2 $c0"MySQL backup:   $c1$backup_dbs"
  set l3 $c3"Disk usage:     $c1$disk_usage_perc% ($disk_usage_gb/$disk_total_gb GB available)"
  set l4 $c0"Music backup:   $c1$backup_music"
  set l5 $c2"Theme version:  $c1$version"
  set l6 $c0"Source backup:  $c1$backup_source"
  set l7 $c2"Last commit:    $c1$last_commit ($last_commit_rel)"
  set l8 $c0"Files backup:   $c1$backup_files"
  set lines $l1 $l2 $l3 $l4 $l5 $l6 $l7 $l8
  
  draw_columns $lines
  set_color normal
end

# Converts a timestamp used for backups into Unix time.
function backup_date_unix --description 'Converts a backup timestamp back to Unix time'
  date -jf "%a, %b %d %Y %X %z" $argv[1] +%s
end

# Prints out a single time value with 'ago' after it.
function time_ago_echo --description 'Prints out a time ago string'
  echo -n $argv[1]
  if [ $argv[1] -eq 1 ]
    echo -n " $argv[2]"
  else
    echo -n " $argv[3]"
  end
  echo " ago"
end

# Calculates the relative difference between two Unix times.
# The difference is returned in a human-readable format,
# e.g. '5 years ago', '2 days ago', '20 minutes ago'.
function time_ago --description 'Formats the relative difference between two dates'
  set date1 $argv[1]
  set date2 $argv[2]
  set diff (math "$date1 - $date2")
  
  set year_l 31536000
  set month_l 2628000
  set week_l 604800
  set day_l 86400
  set hour_l 3600
  set minute_l 60
  
  set years (math "$diff / $year_l")
  if [ $years -gt 0 ]
    time_ago_echo $years "year" "years"
    return
  end
  set months (math "$diff / $month_l")
  if [ $months -gt 0 ]
    time_ago_echo $months "month" "months"
    return
  end
  set weeks (math "$diff / $week_l")
  if [ $weeks -gt 0 ]
    time_ago_echo $weeks "week" "weeks"
    return
  end
  set days (math "$diff / $day_l")
  if [ $days -gt 0 ]
    time_ago_echo $days "day" "days"
    return
  end
  set hours (math "$diff / $hour_l")
  if [ $hours -gt 0 ]
    time_ago_echo $hours "hour" "hours"
    return
  end
  set minutes (math "$diff / $minute_l")
  if [ $minutes -gt 0 ]
    time_ago_echo $minutes "minute" "minutes"
    return
  end
  time_ago_echo $diff "second" "seconds"
end

# Returns Git version (e.g. master-23 [a4fd3c]).
function get_version --description 'Returns version identifier string'
  set branch (git describe --all | sed s@heads/@@)
  set hash (git rev-parse --short head)
  set commits (git rev-list head --count)
  echo $branch-$commits [$hash]
end

# Last commit date in short format (YYYY-mm-dd).
function get_last_commit --description 'Returns last Git commit date'
  echo (git log -n 1 --date=format:%s --pretty=format:%cd --date=short)
end

# Last commit date in relative format ('x days ago').
function get_last_commit_rel --description 'Returns last Git commit date in relative format'
  echo (git log -n 1 --pretty=format:%cd --date=relative)
end

# Draws lines as columns. Used to draw two columns of text in the greeting.
function draw_columns --description 'Draws lines as columns'
  set lines $argv
  set linen (count $lines)
  set colwidth 60
  set columns 2
  for n in (seq $linen)
    set line $lines[$n]
    # Line length
    set len (string length $line)
    # Remainder
    set rem (math "$colwidth - $len")
    
    # Echo the string
    echo -n $line
    # Echo spaces until we reach the column width
    if [ $rem -gt 0 ]
      echo -n (string repeat ' ' -n $rem)
    end
    
    # Linebreak after 2 columns
    if [ (math "$n % $columns") -eq 0 ]
      echo
    end
  end
  # Add a last linebreak if we have an odd number of lines.
  if [ ! (math "$linen % $columns") -eq 0 ]
    echo
  end
end

# A slightly optimized helper function for VCS.
# Displaying the VCS part of the prompt is quite slow,
# so we check to see if ./.git or ../.git exists. If not, we exit early.
# This is a decent trade-off for the extra speed in most cases.
function faster_vcs
  # Speed up non-Git folders a bit
  if not test -d ./.git; and not test -d ../.git
    return
  end
  __fish_vcs_prompt
end
