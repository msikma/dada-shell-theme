# Dada Shell Theme © 2019

# Strips colors (and all other escape sequences) from text
alias strip_color="gsed -r 's/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[mGK]//g'"

# Strips the extension from a filename
alias strip_ext="sed -e 's/\.[^/]*\$//'"

# Converts text to all lowercase
alias lowercase="tr '[:upper:]' '[:lower:]'"

# Converts text to all uppercase
alias uppercase="tr '[:lower:]' '[:upper:]'"

# lfext ./dir/ ".ext"
# Lists all files of a certain extension inside a directory.
# Doesn't break when there are zero matches.
function lfext \
  --argument-names dir ext
  if not test -d $dir
    return
  end
  find "$dir" -maxdepth 1 -mindepth 1 -type f -name "$ext"
end
