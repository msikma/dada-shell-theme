#!/usr/bin/env fish

function randstr
  LC_ALL=C tr -dc A-Za-z0-9 < /dev/urandom | head -c 13
end

function find_files --argument-names dir exts
  find -E "$dir" -type f -regex ".*\.($exts)"
end

function get_size --argument-names dir
  gdu -b "$dir" | tail -n 1 | awk '{ print $1 }'
end

function make_sheet --argument-names dir exts add_list
  set full_dir (realpath "$dir")
  set curr_dir (basename "$full_dir")
  set files (find_files "$dir" "$exts" | sort)
  set files_n (count $files)
  set total_size (get_size "$dir")
  set total_size_f (numfmt --to iec --format "%.2f" "$total_size")
  echo "<!doctype html>
<html>
<head>
<meta charset='utf-8'>
<title>Contact sheet for: $curr_dir</title>
<style>
.images { display: flex; flex-wrap: wrap; }
.image-outer { display: inline-block; padding: 0.1em 0.1em 0.1em 0; align-self: baseline; }
.image-outer:hover .image { border: 2px outset black; background-color: #ececec; }
.image-outer:target .image { border: 2px outset #ffff64; background-color: #ffff64; }
.image-outer:target:hover .image { border: 2px outset black; }
.image { display: inline-block; margin: 0.1em 0.1em 0.1em 0; padding: 0.5em; border: 2px solid transparent; text-align: center; }
.image p { margin-bottom: 0; }
.image-list summary { margin-block-start: 1em; margin-block-end: 1em; margin-left: 0.3em; }
.image-list ol { column-width: 160px; }
label p { width: 16em; }
body.dark { background: black; color: white; }
body.dark a { color: cyan; }
body.dark .image-outer:hover .image { border: 2px outset #fff; background-color: #333; }
body.dark .image-outer:target .image { border: 2px outset #ffff64; background-color: #393900; }
body.dark .image-outer:target:hover .image { border: 2px outset #fff; }
body.minimal .image { margin: 0; padding: 0; display: block; }
body.minimal .image p { display: none; }
body.minimal .image img { display: block; }
body.limit-size .image img { max-height: 300px; width: auto; }
</style>
</head>
<body>
<p>Contact sheet for directory: <b>$curr_dir</b></p>
<p>Path: <code>$full_dir</code></p>
<table border='2'>
<tr><th>Files</th><td>$files_n</td></tr>
<tr><th>Total size</th><td>$total_size_f ($total_size bytes)</td></tr>
</table>
<label for='darkcheck'><p><input type='checkbox' id='darkcheck' onclick='toggleDark()'> Toggle dark mode</p></label>
<label for='sortcheck'><p><input type='checkbox' id='sortcheck' onclick='toggleSort()'> Sort by height</p></label>
<label for='minimalcheck'><p><input type='checkbox' id='minimalcheck' onclick='toggleMinimal()'> Minimal display</p></label>
<label for='limitsize'><p><input type='checkbox' id='limitsize' onclick='toggleLimitSize()'> Limit image display size</p></label>
<script>
let hasDetectedHeights = false;
let sortedByHeight = false;
function toggleDark() {
  document.body.classList.toggle('dark');
}
function toggleMinimal() {
  document.body.classList.toggle('minimal');
}
function toggleLimitSize() {
  document.body.classList.toggle('limit-size');
}
if (window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches) {
  toggleDark();
  document.querySelector('#darkcheck').checked = true;
}
toggleLimitSize();
toggleMinimal();
function sortChildren(parent, comparator) {
  parent.replaceChildren(...Array.from(parent.children).sort(comparator));
}
function sortByName() {
  sortChildren(document.querySelector('.images'), (elA, elB) => Number(elA.id.slice(1)) < Number(elB.id.slice(1)) ? 0 : 1);
}
function sortByHeight() {
  makeHeightSortOrder();
  sortChildren(document.querySelector('.images'), (elA, elB) => {
    const aHeight = Number(elA.getAttribute('data-image-height').slice(1));
    const bHeight = Number(elB.getAttribute('data-image-height').slice(1));
    if (aHeight === bHeight) {
      return Number(elA.id.slice(1)) < Number(elB.id.slice(1)) ? 0 : 1;
    }
    return aHeight < bHeight ? 0 : 1;
  });
}
function toggleSort() {
  if (sortedByHeight) sortByName();
  if (!sortedByHeight) sortByHeight();
  sortedByHeight = !sortedByHeight;
}
function makeHeightSortOrder() {
  if (hasDetectedHeights) return;
  const images = [...document.querySelectorAll('.images > div.image-outer')];
  images.forEach(image => {
    const img = image.querySelector('img');
    const height = img.naturalHeight;
    if (!height) {
      console.log('could not get height', image.querySelector('p'), image.querySelector('p').textContent);
    }
    image.setAttribute('data-image-height', `h\${height}`);
  });
  hasDetectedHeights = true;
}
</script>"
  if [ "$add_list" -eq "1" ]
    echo "<details class='image-list'>"
    echo "<summary>List of files</summary>"
    echo "<div>"
    make_sheet_list "$dir" $files
    echo "</div>"
    echo "</details>"
  end
  echo "<div class='images'>"
  make_sheet_images "$dir" "$full_dir" $files | sort
  echo "</div>"
  echo "</body>"
  echo "</html>"
end

function make_sheet_list --argument-names dir
  set files $argv[2..-1]
  echo "<ol>"
  for n in (seq (count $files))
    set f $files[$n]
    set alt (basename "$f")
    echo "<li><a href='#f$n'>$alt</a></li>"
  end
  echo "</ol>"
end

function make_sheet_images --argument-names dir pathprefix
  set files $argv[3..-1]
  for n in (seq (count $files))
    set f $files[$n]
    set furl (echo "$pathprefix/$f" | sed "s/'/\&apos;/g" | sed "s/#/\%23/g" | sed "s/?/\%3f/g")
    set alt (basename "$f" | sed "s/'/\&apos;/g")
    set width (identify -ping -format '%w' "$f""[0]")
    set height (identify -ping -format '%h' "$f""[0]")
    set w_zero (string pad -w 10 -c 0 "$width")
    set h_zero (string pad -w 10 -c 0 "$height")
    set fn_zero (echo "$f" | strip_ext)
    echo "<!--h$h_zero|fn$fn_zero|w$w_zero-->""<div class='image-outer' id='f$n'><div class='image'><img src='file://$furl' alt='$alt'><p>$alt</p></div></div>"
  end
end

function main --argument-names dir add_list to_browser
  if [ -z "$dir" ]
    set dir "."
  end
  if [ -z "$add_list" ]
    set add_list "1"
  end
  if [ -z "$to_browser" ]
    set to_browser "1"
  end
  set fn "$TMPDIR"(randstr)".html"
  set exts (string join \| $_image_exts)
  if [ "$to_browser" -eq "1" ]
    set html (make_sheet "$dir" "$exts" "$add_list")
    echo "$html" > "$fn"
    open "$fn"
  else
    make_sheet "$dir" "$exts" "$add_list"
  end
end

main $argv
