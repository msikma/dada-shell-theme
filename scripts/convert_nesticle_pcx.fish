#!/usr/bin/env fish

function convert_pcx_png --argument-names dir
  if not test -d "$dir"
    echo 'convert_nesticle_pcx.fish: error: can\'t find directory: '"$dir"
    return 1
  end
  for a in "$dir"/*.PCX
    set base (echo $a | strip_ext)
    set dest "$a.png"
    convert $a png24:$dest
  end
end

set -q DADA_NESTICLE_DIR; or set DADA_NESTICLE_DIR ~/"Files/Games/DOSBox/Computers/Delphi/C/Games/nesticle/"
convert_pcx_png $DADA_NESTICLE_DIR
