#!/usr/bin/env fish

timer_start

set err "backup-ftp: Error:"
set last_backup (backup_time_rel "/$UDIR/"(whoami)"/.cache/dada/backup-ftp")

set src "/$UDIR/"(whoami)"/Library/Group Containers/G69SCX94XU.duck/Library/Application Support/duck/Bookmarks"
set dst "/Volumes/Files/Backups/FTP"

set c1 (set_color blue)
set c2 (set_color normal)

if not test -d $dst
  echo "$err Can't access target directory: "$dst
  exit 1
end
if not test -d $src
  echo "$err Cyberduck is not installed."
  exit 1
end

echo
echo (set_color cyan)"Backup script for Cyberduck bookmarks"(set_color normal)
echo (set_color green)"Copying to: "(set_color yellow)"$dst"(set_color normal)
echo (set_color green)"Last backup was "$last_backup"."(set_color normal)
echo

for n in (ls $src/*)
  # Filename in $n, set $nn to the plain name of the bookmark.
  set nn (awk '/Nickname/,/string/' $n | grep -io "<string>.*</string>" | cut -d '>' -f2 | cut -d '<' -f1 | sed 's/\//-/g')
  echo "Backing up: $c1$nn$c2 ("(basename $n)")"
  cp $n $dst"/"$nn".duck"
end

set result (timer_end)
echo
echo (set_color cyan)"Done in $result s."(set_color normal)
echo

mkdir -p ~/.cache/dada
echo (date +"%a, %b %d %Y %X %z") > ~/.cache/dada/backup-ftp
