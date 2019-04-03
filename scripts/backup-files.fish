#!/usr/bin/env fish

timer_start

set err "backup-files: Error:"
set last_backup (backup_time_rel "/Users/"(whoami)"/.cache/dada/backup-files")

if not set -q hostname
  echo "$err \$hostname is not set"
  exit 1
end

set src \
~/"Files/" \
~/"Desktop/" \
~/"Documents/"

set dst \
"/Volumes/Files/Backups/$hostname/Files" \
"/Volumes/Files/Backups/$hostname/Desktop" \
"/Volumes/Files/Backups/$hostname/Documents"

for n in (seq (count $src))
  set s $src[$n]
  set d $dst[$n]
  if not test -d $s
    echo "$err Can't access source directory: "$s
    exit 1
  end
  if not test -d $d
    echo "$err Can't access target directory: "$d
    exit 1
  end
end

echo (set_color cyan)"Backup script for "(set_color blue)"~/Files/ "(set_color cyan)"and"(set_color blue)" ~/Documents/"(set_color normal)
echo (set_color yellow)"Last backup was "$last_backup"."(set_color normal)

for n in (seq (count $src))
  set s $src[$n]
  set d $dst[$n]
  echo "backup-files: Syncing: "$s" -> "$d

  # Note: excluding the following:
  # - OpenTTD, Games (use the backup-games script)
  # - Music (use the backup-music script)
  rsync -ahvrESH8 --delete --progress --stats --exclude="Music" --exclude="Games" --exclude="OpenTTD" --exclude=".*/" --exclude=".*" $s $d
end

set result (timer_end)
echo (set_color cyan)"Done in $result ms."(set_color normal)
echo

mkdir -p ~/.cache/dada
echo (date +"%a, %b %d %Y %X %z") > ~/.cache/dada/backup-files
