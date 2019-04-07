#!/usr/bin/env fish

timer_start

set err "backup-games: Error:"
set last_backup (backup_time_rel "/Users/"(whoami)"/.cache/dada/backup-games")
set srcdir "/Users/"(whoami)"/Documents/OpenTTD" "/Users/"(whoami)"/Files/Games"
set dstdir "/Volumes/Files/Backups/Game data/" "/Volumes/Files/Backups/Game data/"
set srcdir_opt "/Users/"(whoami)"/Library/Application Support/Steam/userdata"
set dstdir_opt "/Volumes/Files/Backups/Steam userdata"
set amount (count $srcdir)
set amount_opt (count $srcdir_opt)

function test_existence
  set s $argv[1]
  set d $argv[2]
  if not test -d $s
    echo "$err Can't access source directory: "$s
    exit 1
  end
  if not test -d $d
    echo "$err Can't access target directory: "$d
    exit 1
  end
end

for n in (seq $amount)
  test_existence $srcdir[$n] $dstdir[$n]
end

echo
echo (set_color cyan)"Backing up video game content"(set_color normal)
echo (set_color green)"Last backup was "$last_backup"."(set_color normal)
echo

for n in (seq $amount)
  set s $srcdir[$n]
  set d $dstdir[$n]
  mkdir -p "$d"
  echo (set_color green)"Backing up ("$n"/"$amount"): "(set_color yellow)"$s"(set_color green)" to "(set_color yellow)"$d"(set_color normal)

  # Copy over everything. No deleting; merge everything together.
  rsync -ahvrESH8 --progress --stats --exclude=".*/" --exclude=".*" $s $d
end

for n in (seq $amount_opt)
  set s $srcdir_opt[$n]
  set d $dstdir_opt[$n]
  if not test -d $s
    continue
  end
  if not test -d $d
    continue
  end
  mkdir -p "$d"
  echo (set_color green)"Backing up optional directory ("$n"/"$amount_opt"): "(set_color yellow)"$s"(set_color green)" to "(set_color yellow)"$d"(set_color normal)

  # Copy over everything. No deleting; merge everything together.
  rsync -ahvrESH8 --progress --stats --exclude=".*/" --exclude=".*" $s $d
end

set result (timer_end)
echo
echo (set_color cyan)"Done in $result s."(set_color normal)
echo

# Save last backup timestamp.
mkdir -p ~/.cache/dada
echo (date +"%a, %b %d %Y %X %z") > ~/.cache/dada/backup-games
