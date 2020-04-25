# Dada Shell Theme © 2019, 2020

function get_dot_underbars \
  --argument-names dir \
  --description "Returns the amount of dot-underbar files in a given base dir"
  set files (string trim -- (find $dir | grep -i "\._" | grep -v "\._Icon" | wc -l))
  echo $files
end

function clean_dot_underbars \
  --argument-names dir \
  --description "Cleans up the dot-underbar files in a given base dir"
  set files (find $dir | grep -i "\._" | grep -v "\._Icon")
  for file in $files
    rm $file
  end
end

function get_disk_usage
  # Note: get all information in 1024kb blocks for easier arithmetic.
  set amount (df -k / | tail -n1)
  set total (echo $amount | awk '{print $2}')
  set avail (echo $amount | awk '{print $4}')
  set use (echo $amount | awk '{print $5}')

  set avail_h (math --scale=1 "(($avail) * 1024) / 1000000000")
  set total_h (math --scale=1 "(($total) * 1024) / 1000000000")

  echo "$use ($avail_h/$total_h GB available)"
end

function _filesize_bytes --description "Prints the size of a file in bytes"
  stat -f%z $argv[1]
end

function _filesize --description "Prints a human readable filesize"
  ls -la $argv[1] | cut -f2 -d' '
end

function _filelines --description "Returns number of lines in a file as an integer"
  wc -l < $argv[1] | tr -d '[:space:]'
end

function _file_extension \
  --argument-names fn \
  --description "Prints the extension part of a filename (without leading dot)"
  # Note: for 'foo.bar.js', returns 'js'.
  echo $fn | sed -E 's/.+\.([^.]+)$/\1/g'
end

function _file_basename \
  --argument-names fn \
  --description "Prints the basename part of a filename (without trailing dot)"
  # Note: for 'foo.bar.js', returns 'foo.bar'.
  echo $fn | sed -E 's/\.[^.]+$//g'
end

function _ensure_trailing_slash \
  --argument-names dirn \
  --description "Add a trailing slash to a path if it doesn't have one"
  # Split the given directory to see if we need a trailing slash.
  # If the last item of the split isn't an empty string, we do.
  set spl (string split "/" "$dirn")
  if [ -n "$spl[-1]" ]
    echo "$dirn"/
  else
    echo "$dirn"
  end
end

function _clean_py_ext \
  --argument-names ext \
  --description "Turns 'py2' and 'py3' into just 'py' for Python shell scripts; leaves others intact"
  switch $ext
  case 'py2'
    echo 'py'
  case 'py3'
    echo 'py'
  case '*'
    echo $ext
  end
end

function _ext_shebang \
  --argument-names ext \
  --description "Prints an appropriate shebang for a file extension"
  # Global prefix for each type.
  echo -n '#!/usr/bin/env '

  switch $ext
  case 'js'
    echo 'node'
  case 'py'
    echo 'python3'
  case 'py2'
    echo 'python2'
    echo '# coding=utf8'
  case 'py3'
    echo 'python3'
  case 'php'
    echo 'php'
  case 'rb'
    echo 'ruby'
  case 'sh'
    echo 'bash'
  case 'bash'
    echo 'bash'
  case 'fish'
    echo 'fish'
  case '*'
    echo '?'
  end
end
