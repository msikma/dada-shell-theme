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

# CWD color
set -g __fish_prompt_cwd (set_color cyan)
set -g __fish_prompt_normal (set_color normal)

# Copied from one of the default prompts and edited a bit.
function fish_prompt --description 'Write out the prompt'
  echo -n -s "$__fish_prompt_cwd" (prompt_pwd) "$__fish_prompt_normal" (faster_vcs) "$__fish_prompt_normal" '> '
end

function fish_right_prompt --description 'Write out the right prompt'
  set -l exit_code $status
  set -l datestr (date +"%a, %b %d %Y %X")
  if test $exit_code -ne 0
    set_color red
    echo -n "! "
    set_color normal
  end
  
  set_color 222
  echo $datestr
  set_color normal
end

function fish_greeting
  # Disk usage in %
  set disk_usage_perc (df / | tail -n1 | sed "s/  */ /g" | cut -d' ' -f 5 | cut -d'%' -f1)
  # Disk usage in GB, one decimal
  set disk_usage_gb (math --scale=1 "("(df / | tail -n1 | sed "s/  */ /g" | cut -d' ' -f 4)"*512)/1000000000")
  # Total disk size in GB, one decimal
  set disk_total_gb (math --scale=1 "("(df / | tail -n1 | sed "s/  */ /g" | cut -d' ' -f 2)"*512)/1000000000")
  # user@hostname
  set user (whoami)'@'(uname -n)
  # Current IP (10.0.1.3)
  set currip (ifconfig | grep inet | grep broadcast | cut -d' ' -f 2)
  
  # TODO: check on backup status
  # /Volumes/Files/Backups/msikma
  echo 
  
  set_color brblack
  echo (uname -v)
  uptime
  echo
  
  set l1 "User:         $user ($currip)"
  set l2 "Disk usage: $disk_usage_perc% ($disk_usage_gb GB available)"
  set lines $l1 $l2
  
  draw_columns $lines
  set_color normal
end

function draw_columns --description 'Draws lines as columns'
  set lines $argv
  set colwidth 50
  set columns 2
  for n in (seq (count $lines))
    set line $lines[$n]
    # Line length
    set len (string length $line)
    # Remainder
    set rem (math "$colwidth - $len")
    
    # Echo the string
    echo -n $line
    # Echo spaces until we reach the column width
    echo -n (string repeat ' ' -n $rem)
    
    # Linebreak after 2 columns
    if [ (math "$n % $columns") -eq 0 ]
      echo
    end
  end
end

function faster_vcs
  # Speed up non-Git folders a bit
  if not test -d ./.git; and not test -d ../.git
    return
  end
  __fish_vcs_prompt
end