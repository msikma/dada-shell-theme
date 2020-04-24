# Dada Shell Theme © 2019, 2020

function eatsql --description "Shortcut for importing SQL files into MariaDB"
  if not count $argv > /dev/null
    echo 'usage: eatsql source.sql [dbname]'
    return
  end

  timer_start

  set fn $argv[1]
  set db $argv[2]
  set size (_filesize $fn)
  set lines (_filelines $fn)

  if test -n "$db"
    echo "eatsql: Importing $fn into database $db ($size; $lines lines)"
    mysql -uroot -proot -e "create database if not exists `$db`; use `$db`; set autocommit=0; source $fn; commit;"
  else
    echo "eatsql: Importing $fn ($size; $lines lines)"
    mysql -uroot -proot -e "set autocommit=0; source $fn; commit;"
  end

  set result (timer_end)
  echo "Done in "$result"s."
end
