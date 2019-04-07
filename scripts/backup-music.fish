#!/usr/bin/env fish

timer_start

set err "backup-music: Error:"
set last_backup (backup_time_rel "/Users/"(whoami)"/.cache/dada/backup-music")
set src ~/"Files/Music/"
set dst "/Volumes/Files/Backups/$dada_hostname/Files/Music/"

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

echo
echo (set_color cyan)"Backup script for music"(set_color normal)
echo (set_color green)"Copying to: "(set_color yellow)"$dst"(set_color normal)
echo (set_color green)"Last backup was "$last_backup"."(set_color normal)
echo

rsync -ahvrESH8 --delete --progress --stats --exclude=".*/" --exclude=".*" $src $dst

set result (timer_end)
echo (set_color cyan)"Done in $result ms."(set_color normal)
echo

mkdir -p ~/.cache/dada
echo (date +"%a, %b %d %Y %X %z") > ~/.cache/dada/backup-music
