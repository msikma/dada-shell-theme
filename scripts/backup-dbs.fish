#!/usr/bin/env fish

timer_start

set err "backup-dbs: Error:"
set last_backup (backup_time_rel "/Users/"(whoami)"/.cache/dada/backup-dbs")

if not set -q dada_hostname
  echo "$err \$dada_hostname is not set"
  exit 1
end

echo
echo (set_color cyan)"Backing up MySQL databases for "(set_color red)$dada_hostname(set_color normal)
echo (set_color green)"Copying files to "(set_color yellow)"/Volumes/Files/Backups/"(set_color red)$dada_hostname(set_color yellow)"/Databases"(set_color normal)
echo (set_color green)"Last backup was "$last_backup"."(set_color normal)
echo

set ts (date "+%Y-%m-%d")
set dest "/Volumes/Files/Backups/$dada_hostname/Databases"
set mampsql "/Applications/MAMP/Library/bin/mysql"
set mampdump "/Applications/MAMP/Library/bin/mysqldump"

if test -f $mampsql
  set user "root"
  set pass "root"
  set sqlcmd "/Applications/MAMP/Library/bin/mysql"
  set dumpcmd "/Applications/MAMP/Library/bin/mysqldump"
else
  set user "root"
  set pass "root"
  set sqlcmd "mysql"
  set dumpcmd "mysqldump"
end

if not test -d "$dest"
  echo "$err could not access destination: $dest"
  exit 1
end

# Check if we have access with the provided credentials.
if not eval $sqlcmd -u$user -p$pass -e "help;" > /dev/null
  echo "$err could not login using given credentials"
  exit 1
end

set databases (eval $sqlcmd -u$user -p$pass -e "'show databases;'" 2> /dev/null | grep -Ev "(mysql|Database|information_schema|performance_schema)")
set dbcount (count $databases)
if test $dbcount -eq 1
  echo "Backing up $dbcount database."
else
  echo "Backing up $dbcount databases."
end

for i in $databases
  eval $dumpcmd --force -u$user -p$pass --databases $i 2> /dev/null | gzip > "$dest/$i.sql.gz"
  du -h "$dest/$i.sql.gz"
end
set oldcount (ls $dest)
echo (set_color green)(du -h "$dest") (set_color yellow)"("(count $oldcount)" databases)"(set_color normal)

set result (timer_end)
echo (set_color cyan)"Done in $result ms."(set_color normal)
echo

mkdir -p ~/.cache/dada
echo (date +"%a, %b %d %Y %X %z") > ~/.cache/dada/backup-dbs
