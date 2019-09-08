#!/usr/bin/env fish

# Colored folder icons <https://github.com/msikma/osx-folder-icons>
set files_folders (lfext ~/Projects/dada-folder-icons/icns "*.icns" | sort)
# Dada custom icons <https://bitbucket.com/msikma/dada-icons>
set files_others (lfext ~/Projects/dada-icons/icns "*.icns" | sort)

set icons_folders
set icons_others

# Reduce to the basename without extension.
for i in (seq (count $files_folders))
  set icons_folders[$i] (eval basename "$files_folders[$i]" .icns)
end
for i in (seq (count $files_others))
  set icons_others[$i] (eval basename "$files_others[$i]" .icns)
end

set files_all $files_folders $files_others
set icons_all $icons_folders $icons_others

# Lists the available icons (for a single category).
function icon_list
  # Skip the first argument, which is the label.
  set icons $argv[2..-1]
  set label $argv[1]

  set max_limit 58
  set max_width_first (math $max_limit - (string length $label))
  set max_width_second $max_limit
  set max_width $max_width_first
  set width 0
  set n 0

  echo -n "  "$label
  for item in (seq (count $icons))
    # Skip icons starting with an underscore.
    # These icons are not meant for the 'color' command.
    set first (string sub -s 1 -l 1 $icons[$item])
    if [ $first = '_' ]
      continue
    end
    set n (math $n + 1)
    if [ $n -gt 1 ]
      echo -n ', '
    end
    set width (math $width + (string length $icons[$item]) + 2)
    if [ $width -gt $max_width ]
      set max_width $max_width_second
      set width 6
      echo -en "\n      "
    end
    echo -n (set_color yellow)$icons[$item](set_color reset)
  end
  echo
end

# Displays the usage guide.
function usage
  echo 'usage: color '(set_color -u)'dirname'(set_color reset)' '(set_color -u)'icon-name'(set_color reset)
  echo
  icon_list "Colored folders: " $icons_folders
  icon_list "Other icons: " $icons_others
  exit
end

if not set -q argv[1]
  usage
end
if not test -d $argv[1]; and not test -f $argv[1]
  echo "color: error: could not find target file or directory ($argv[1])"
  exit
end
if not set -q argv[2]
  usage
end

# The user has passed a valid directory. Loop through the icons, set the icon and exit.
# If we run out of icons the user will be told their indicated icon doesn't exist.
for i in (seq (count $icons_all))
  set c $icons_all[$i]
  if [ $c = $argv[2] ]
    fileicon set $argv[1] $files_all[$i]
    exit
  end
end

echo "color: error: could not find icon file ($argv[2])"
exit
