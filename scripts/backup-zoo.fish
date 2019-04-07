#!/usr/bin/env fish

timer_start
set last_backup (backup_time_rel "/Users/"(whoami)"/.cache/dada/backup-zoo")

set err "backup-zoo: Error:"
set src "/Users/"(whoami)"/Files/Music/Music"
set dst "/Volumes/happy zoo/dada/Music"

if not set -q dada_hostname
  echo "$err \$dada_hostname is not set"
  exit 1
end

if not test -d $src
  echo "$err Can't access source directory: $src"
  exit 1
end

if not test -d $dst
  echo "$err Can't access target directory: $dst"
  exit 1
end

echo (set_color cyan)"Backup script for Happy Zoo content"(set_color normal)
echo (set_color yellow)"Last backup was "$last_backup"."(set_color normal)

rsync -ahvrESH8 --delete --progress --stats --no-links --exclude=".*/" --exclude=".*" "$src/Tracker/" "/Volumes/happy zoo/dada/Music/Tracker/"
rsync -ahvrESH8 --delete --progress --stats --no-links --exclude=".*/" --exclude=".*" "$src/Game music covers/" "/Volumes/happy zoo/dada/Music/Game music covers/"
rsync -ahvrESH8 --delete --progress --stats --no-links --exclude=".*/" --exclude=".*" "$src/Game music/" "/Volumes/happy zoo/dada/Music/Game music/"
rsync -ahvrESH8 --delete --progress --stats --no-links --exclude=".*/" --exclude=".*" "$src/Classical/" "/Volumes/happy zoo/dada/Music/Classical/"

set result (timer_end)
echo (set_color cyan)"Done in $result ms."(set_color normal)
echo

mkdir -p ~/.cache/dada
echo (date +"%a, %b %d %Y %X %z") > ~/.cache/dada/backup-zoo
