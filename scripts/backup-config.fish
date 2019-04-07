#!/usr/bin/env fish

timer_start

set err "backup-config: Error:"

set last_backup (backup_time_rel "/Users/"(whoami)"/.cache/dada/backup-config")
set src "/Users/"(whoami)"/.config/"
set dst "/Volumes/Files/Backups/$dada_hostname/Config"
set srcssh "/Users/"(whoami)"/.ssh/"
set dstssh "/Volumes/Files/Backups/$dada_hostname/SSH"

set do_not_backup "yarn"

if not test -d $src
  echo "$err Can't access source directory: "$src
  exit 1
end
if not test -d $dst
  echo "$err Can't access target directory: "$dst
  exit 1
end
if not test -d $srcssh
  echo "$err Can't access source directory: "$srcssh
  exit 1
end
if not test -d $dstssh
  echo "$err Can't access target directory: "$dstssh
  exit 1
end

echo
echo (set_color cyan)"Backup script for ~/.config/ files"(set_color normal)
echo (set_color green)"Last backup was "$last_backup"."(set_color normal)
echo (set_color green)"Backing up config files to: "(set_color yellow)"$dst"(set_color normal)
echo

set orig (pwd)
cd $src
set dirs (find . -type d -depth 1)

for dir in $dirs
  set full $src$dir
  set name (basename $dir)
  set zipname $dst"/"$name".zip"

  if contains $name $do_not_backup
    echo (set_color yellow)"Skipping: "(set_color blue)"$name"(set_color yellow)" (in ignore list)"(set_color normal)
    continue
  end

  set files (find $dir | wc -l | awk '{print $1}')
  set fsize (du -hs $dir | awk '{print $1}')
  zip -r9q $zipname $dir
  echo (set_color green)"Backed up: "(set_color blue)"$name"(set_color yellow)" ($fsize, $files files)"(set_color normal)
end

echo
echo (set_color green)"Backing up SSH keys to: "(set_color yellow)"$dstssh"(set_color normal)
echo

# Copy over everything. No deleting; merge everything together.
for sshfile in (ls $srcssh)
  cp $srcssh$sshfile $dstssh
  echo (set_color green)"Backed up: "(set_color blue)"$sshfile"(set_color normal)
end

cd $orig
echo

set result (timer_end)
echo (set_color cyan)"Done in $result ms."(set_color normal)
echo

# Save last backup timestamp.
mkdir -p ~/.cache/dada
echo (date +"%a, %b %d %Y %X %z") > ~/.cache/dada/backup-config
