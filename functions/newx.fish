
# Makes a new executable script. Invoke like: 'newx file.fish' or 'newx file.js', etc.
function newx \
  --argument-names fn \
  --description "Makes a new executable script (note: a filename ending in .py2 or .py3 will result in a .py file with appropriate shebang)"
  # Retrieve file extension and filename (even in cases like my.file.js; it will yield 'my.file' and 'js').
  set bn (_file_basename $fn)
  set ext (_file_extension $fn)

  # Ensure we keep linebreaks.
  _ext_shebang $ext | read -lz she

  # When using .py2 or .py3 we really want .py in the actual filename.
  set ext (_clean_py_ext $ext)

  # If no file extension, give a warning.
  if [ $bn = $ext ]
    echo 'newx: warning: no file extension was given (using bash shebang)'
    set she (_ext_shebang 'bash')
    set fn "$bn"
  else
    set fn "$bn.$ext"
  end

  echo "$she" > $fn
  chmod +x $fn
  stat -f "%Sp %N:" $fn
  echo -n $she
end
