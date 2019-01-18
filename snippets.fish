# Don't run this, it's not a script.
echo "These are just snippets of code. It's not a script."
exit 1

# Rotate images, named e.g. 'Scan 74.jpg' -> '040.jpg'
# Requires ImageMagick
set m 37; for n in (seq 74 120); set m (math $m + 1); set mn (printf "%03u" $m);  set src "Scan $n.jpg"; set dst "$mn.jpg"; convert "$src" -rotate -90 "$dst"; echo $src" -> "$dst; end;
