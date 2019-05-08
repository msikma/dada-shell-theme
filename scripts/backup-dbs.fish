#!/usr/bin/env fish

set name "backup-dbs"
set purpose "databases"

set dst "/Volumes/Files/Backups/$dada_hostname/Databases"

check_hostname $name
check_needed_dirs $name 'target' $dst

print_backup_start $purpose $name
print_last_backup_time $name
print_backup_dir 'MySQL databases' $dst

# Check whether to backup using the MAMP binaries or the regular ones.
set mamp_dir "/Applications/MAMP/Library/bin"

if test -d $mamp_dir
  # MAMP detected; use that.
  set user "root"
  set pass "root"
  set sqlcmd "$mamp_dir/mysql"
  set dumpcmd "$mamp_dir/mysqldump"
else
  # No MAMP; use the default MySQL binaries.
  set user "root"
  set pass "root"
  set sqlcmd "mysql"
  set dumpcmd "mysqldump"
end

# Check if we have access with the standard credentials.
if not eval $sqlcmd -u$user -p$pass -e "help;" > /dev/null
  backup_error_exit $name "Could not login using given credentials"
end

# Generate a list of databases we'll back up.
set databases (eval $sqlcmd -u$user -p$pass -e "'show databases;'" 2> /dev/null | grep -Ev "(mysql|Database|information_schema|performance_schema)")
set db_count (count $databases)
set db_plural "s"
if test $db_count -eq 1
  set db_plural ""
end
echo (set_color yellow)"Backing up $db_count database$db_plural."(set_color normal)

# Dump every database and gzip it, saving it to the destination directory.
for db in $databases
  set file "$dst/$db.sql.gz"
  eval $dumpcmd --force -u$user -p$pass --databases $db 2> /dev/null | gzip > "$file"
  du -h "$file"
end
set db_files (ls $dst)
echo (set_color green)(du -h "$dst") (set_color yellow)"("(count $db_files)" databases)"(set_color normal)

print_backup_finish $name
set_last_backup $name
