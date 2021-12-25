#!/usr/bin/env fish

function randstr
  LC_ALL=C tr -dc A-Za-z0-9 < /dev/urandom | head -c 13
end

function find_files --argument-names dir exts
  find -E "$dir" -type f -regex ".*\.($exts)"
end

function make_sheet --argument-names dir exts
  set full_dir (realpath "$dir")
  set curr_dir (basename "$full_dir")
  set files (find_files "$dir" "$exts" | sort)
  set files_n (count $files)
  set total_size (gstat -c %s -- $files | paste -d+ -s - | bc)
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
body.minimal .image { margin: 0; padding: 0; }
body.minimal .image p { display: none; }
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
<script>
let hasDetectedHeights = false;
let sortedByHeight = false;
function toggleDark() {
  document.body.classList.toggle('dark');
}
function toggleMinimal() {
  document.body.classList.toggle('minimal');
}
if (window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches) {
  toggleDark();
  document.querySelector('#darkcheck').checked = true;
}
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
</script>
<details class='image-list'>
<summary>List of files</summary>"
  echo "<div>"
  make_sheet_list "$dir" $files
  echo "</div>"
  echo "</details>"
  echo "<div class='images'>"
  make_sheet_images "$dir" "$full_dir" $files
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
    set furl "$pathprefix/$f"
    set alt (basename "$f")
    echo "<div class='image-outer' id='f$n'><div class='image'><img src='file://$furl' alt='$alt'><p>$alt</p></div></div>"
  end
end

function main --argument-names dir
  if [ -z "$dir" ]
    set dir "."
  end
  set fn "$TMPDIR"(randstr)".html"
  set exts (string join \| $_image_exts)
  set html (make_sheet "$dir" "$exts")
  echo "$html" > "$fn"
  open "$fn"
end

main $argv
