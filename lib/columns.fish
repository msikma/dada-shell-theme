# Dada Shell Theme © 2019

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
