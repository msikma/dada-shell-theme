# Don't run this, it's not a script.
echo "These are just snippets of code. It's not a script."
exit 1

# Rotate images, named e.g. 'Scan 74.jpg' -> '040.jpg'
# Requires ImageMagick
set m 37; for n in (seq 74 120); set m (math $m + 1); set mn (printf "%03u" $m);  set src "Scan $n.jpg"; set dst "$mn.jpg"; convert "$src" -rotate -90 "$dst"; echo $src" -> "$dst; end;


# I forgot what this is
function drewdrew
  for x in (seq 500)
    set y (math $x + 1)
    ffmpeg -y -i drew$x.mp4 -vf fps=20,scale=320:-1:flags=lanczos,palettegen palette.png
    ffmpeg -i drew$x.mp4 -i palette.png -filter_complex "fps=20,scale=320:-1:flags=lanczos[x];[x][1:v]paletteuse" drew$x.gif
    rm palette.png
    ffmpeg -f gif -i drew$x.gif drew$y.mp4
  end
end


function video2gif
  ffmpeg -y -i $argv[1] -vf fps=20,scale=320:-1:flags=lanczos,palettegen palette.png
  ffmpeg -i $argv[1] -i palette.png -filter_complex "fps=20,scale=320:-1:flags=lanczos[x];[x][1:v]paletteuse" $argv[1].gif
  rm palette.png
end


function findfile
  find / -name $argv 2> /dev/null
end
