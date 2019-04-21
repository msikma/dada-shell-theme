# Dada Shell Theme © 2019

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

# In case we want to make a network request.
# This is modified to the correct value when fish_greeting is run.
set -gx dada_ua "Dada Shell Theme/unknown"

# Prints a greeting message when logging in.
# This displays some basic information such as the current user and time,
# as well as information about the latest backups.
function fish_greeting --description 'Display the login greeting'
  # Current Mac OS X version
  set osx_version (defaults read loginwindow SystemVersionStampAsString)
  set darwin_version (uname -v | sed -e 's/:.*;/;/g')
  # Disk usage in %
  set disk_usage_perc (df / | tail -n1 | sed "s/  */ /g" | cut -d' ' -f 5 | cut -d'%' -f1)
  # Disk usage in GB, one decimal
  set disk_usage_gb (math --scale=1 "("(df / | tail -n1 | sed "s/  */ /g" | cut -d' ' -f 4)"*512)/1000000000")
  # Total disk size in GB, one decimal
  set disk_total_gb (math --scale=1 "("(df / | tail -n1 | sed "s/  */ /g" | cut -d' ' -f 2)"*512)/1000000000")
  # user@hostname
  set curr_uname (uname -n)
  set user (whoami)"@$curr_uname"
  # Current IP (10.0.1.3)
  set currip (ifconfig | grep inet | grep broadcast | cut -d' ' -f 2 | head -n 1)
  # Current Dada-theme version, e.g. master-12-abcdef
  # Make sure we return to where we were.
  set dir (pwd)
  cd ~/.config/dada
  set theme_version_main (get_version_short)
  set theme_version_hash (get_version_hash)
  set theme_version "$theme_version_main [$theme_version_hash]"
  set last_commit (get_last_commit)
  set last_commit_rel (get_last_commit_rel)
  cd "$dir"
  # Modify our user agent to contain the version string.
  set -gx dada_ua "Dada Shell Theme/$theme_version_main ($curr_uname)"

  set backup_dbs (backup_time_str "/Users/"(whoami)"/.cache/dada/backup-dbs")
  set backup_music (backup_time_str "/Users/"(whoami)"/.cache/dada/backup-music")
  set backup_files (backup_time_str "/Users/"(whoami)"/.cache/dada/backup-files")
  set backup_src (backup_time_str "/Users/"(whoami)"/.cache/dada/backup-src")

  # Display the gray uname section.
  set_color brblack
  echo $darwin_version
  uptime
  echo

  # Display the theme name.
  echo -n "🌿"
  set_color green
  #echo -n "🌎"
  #set_color blue
  #echo -n "🔥"
  #set_color red
  echo -n " Dada shell theme"
  set_color 2b4e03
  echo -n " on "
  set_color green
  echo "OSX $osx_version"
  set_color 2b4e03
  echo -n "Type "
  set_color green
  echo -n "help"
  set_color 2b4e03
  echo " to see available commands"
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
  set l5 $c2"Theme version:  $c1$theme_version"
  set l6 $c0"Source backup:  $c1$backup_src"
  set l7 $c2"Last commit:    $c1$last_commit ($last_commit_rel)"
  set l8 $c0"Files backup:   $c1$backup_files"
  set lines $l1 $l2 $l3 $l4 $l5 $l6 $l7 $l8

  draw_columns $lines
  echo
  set_color normal
end

# Copied from one of the default prompts and edited a bit.
# Displays a shortened cwd and VCS information.
function fish_prompt --description 'Write out the left prompt'
  echo -n -s "$__fish_prompt_cwd" (prompt_pwd) "$__fish_prompt_normal" (in_git_dir_or_subdir) "$__fish_prompt_normal" '> '
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

# Displays project info on directory change.
function check_node_project \
  --description 'Display project info if we changed to a Node project directory' \
  --on-variable dirprev

  # Don't display project info if:
  status --is-command-substitution; # this is command substitution \
  	or test "$NO_DIRPREV_HOOK" = 1;
    or not test -f ./package.json; # there's no package.json \
    or [ (count $dirprev) -lt 3 ]; # we've just opened a new Terminal session \
    # On second thought, whether we came from a lower directory isn't very important.
    # Note: this has to be -eq 2, since we change directories in the fish_greeting that runs before this.
    # or [ (count (string split $PWD $dirprev[-1])) -eq 2 ]; # we came from a lower directory in the hierarchy \
    and return

  # Displays project name, version, and a list of bin files, npm scripts and docs.
  node-project.js
end
