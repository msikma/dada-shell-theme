# Dada Shell Theme © 2019

# Passes on a list of directories to the zipdir function.
function _zipdir
  set all $argv[2..-1]
  set ctype $argv[1]
  if [ -z "$ctype" ]
    set ctype '9'
  end
  for dirn in $all
    _zipdir_single $dirn $ctype
  end
end

# Zips a directory to a file.
# The resulting zip file will contain the given directory from the perspective of its
# parent directory. Can use compression -0, -1 and -9. After the zip file is created,
# its metadata (creation date, etc.) will be set to that of the original directory;
# so if the directory's creation date is 2002, the zip file will also appear from 2002.
function _zipdir_single \
  --description 'Zips a single directory' \
  --argument-names dirn ctype
  if [ -z "$ctype" ]
    set ctype '9'
  end
  
  # Check for input restrictions.
  set curr (pwd)
  set target (realpath $dirn)
  if [ "$curr" = "$target" ]
    echo 'zipdir: cannot zip current working directory'
    return 1
  end
  if [ ! -d "$target" ]
    echo "zipdir: not a directory: $target"
    return 1
  end

  # Determine the base dir and target filename.
  set basedir (realpath "$target/..")
  set targetdir (basename $dirn)
  set zipn "$targetdir.zip"
  set targetfile "$curr"/"$zipn"

  echo (set_color yellow)"Zipping to: "(set_color cyan)$zipn(set_color normal)
  if [ "$ctype" = "9" ]
    echo (set_color green)"Using best compression (-9)"(set_color normal)
  end
  if [ "$ctype" = "1" ]
    echo (set_color green)"Using fastest compression (-1)"(set_color normal)
  end
  if [ "$ctype" = "0" ]
    echo (set_color green)"Not using compression (-0)"(set_color normal)
  end
  echo
  pushd $basedir
  zip -$ctype -db -Xovr "$targetfile" "./$targetdir"
  touch -r "./$targetdir" "$targetfile"
  echo
  popd
  stat -x "$zipn" | grep -i "file:\|size:\|modify:"
end

function zipdir0 --description 'Zips a list of directories using no compression (-0)'
  _zipdir '0' $argv[1..-1]
end

function zipdir1 --description 'Zips a list of directories using fastest compression (-1)'
  _zipdir '1' $argv[1..-1]
end

function zipdir9 --description 'Zips a list of directories using best compression (-9)'
  _zipdir '9' $argv[1..-1]
end

alias zipdir="zipdir9"
