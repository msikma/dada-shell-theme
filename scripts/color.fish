#!/usr/bin/env fish

set files (
  # Colored folder icons <https://github.com/msikma/osx-folder-icons>
  lfext ~/Projects/dada-folder-icons/icns "*.icns";
  # Dada custom icons <https://bitbucket.com/msikma/dada-icons>
  lfext ~/Projects/dada-icons/icns "*.icns";
  # Other icons (not self made)
  lfext ~/.config/icons/icns "*.icns"
)
set colors

# Reduce to the basename without extension.
for i in (seq (count $files))
  set colors[$i] (eval basename "$files[$i]" .icns)
end

function usage
  echo -n 'Usage: color DIRNAME {'
  for n in (seq (count $colors))
    if [ $n -gt 1 ]
      echo -n '|'
    end
    echo -n $colors[$n]
  end
  echo '}'
  exit
end

if not set -q argv[1]
  usage
end
if not set -q argv[2]
  usage
end

for i in (seq (count $colors))
  set c $colors[$i]
  if [ $c = $argv[2] ]
    fileicon set $argv[1] $files[$i]
    exit
  end
end

echo "color: error: could not find icon file ($argv[2])."
exit
