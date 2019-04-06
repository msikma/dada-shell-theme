set cmd_regular \
  "tree"              "Runs ls with tree structure" \
  "headers <url>"     "Displays headers for a URL" \
  "crc32u <file>"     "Prints CRC32 hash of file" \
  "cdbackup"          "Changes directory to backup dir" \
  "color"             "Adds a colored icon to a folder" \
  "trash"             "Sends files to the OSX trash" \
  "tldr <cmd>"        "Displays simple command help" \
  "fdupes"            "Finds duplicate files by hash" \
  "ftypes"            "Lists files grouped by filetype" \
  "keys"              "Lists installed SSH keys" \
  "code <dir>"        "Opens file/directory in VS Code" \
  "bbedit <dir>"      "Opens file/directory in BBEdit" \
  "md <file>"         "Opens file in MacDown" \
  "newfish <file>"    "Creates a new Fish script" \
  "jv <file>"         "Displays JSON file content" \
  "fd <str>"          "Searches for files (alt. to find)" \
  "doc <file>"        "Reads Markdown file in terminal" \
  "setssh"            "Turns remote SSH access on/off" \
  "urlredirs <url>"   "Displays what redirects a URL has" \
  "bat"               "Improved version of cat" \

set cmd_scripts \
  "sphp"              "Changes PHP version" \
  "scrapemp3s <url>"  "Scrapes MP3 files from a URL" \
  "streamlink <url>"  "Opens internet streams in VLC" \
  "empty-trash"       "Empties the trash bin" \
  "weather"           "Displays the current weather" \
  "glances"           "Computer monitoring tool" \
  "khinsider"         "Downloads OSTs from khinsider.com" \
  "rip-imgs <url>"    "Rips image files from a URL" \
  "colortest"         "Tests Terminal color settings" \
  "imgfloppy"         "Copy floppy data to .img file" \
  "youtube-dl"        "Downloads videos from Youtube" \
  "ascr"              "Downloads art from social media" \
  "ncdu"              "Shows directory disk space usage" \
  "vgmpfdl <url>"     "Downloads albums from vgmpf.com" \
  "rip-music <url>"   "Rips music files from a URL" \
  "eatsql <file>"     "Shortcut to import SQL dumps" \
  "ps2pdf <file>"     "Convert PS to PDF; ps2pdf *.prn" \

set cmd_project \
  "proj"              "Displays current project info" \
  "jira"              "Lists Jira issue branches in repo" \
  "projects"          "Prints recently edited projects" \
  "updrepos"          "Updates all project repos" \
  "tasks"             "Displays Theorycraft Jira tasks" \

set cmd_git \
  "g"                 "Git status" \
  "gith"              "Displays more Git commands help" \
  "gb"                "Last Git commits per branch" \

set cmd_backup \
  "backup"            "Displays backup commands and info" \
  "backup-config"     "Backs up ~/.config/ dirs" \
  "backup-dbs"        "Backs up MySQL databases" \
  "backup-files"      "Backs up ~/Files" \
  "backup-games"      "Backs up game content" \
  "backup-music"      "Backs up music" \
  "backup-src"        "Backs up source code dirs" \

set cmd_network \
  "devices"           "Displays local computers" \
  "servers"           "Displays a list of servers" \

set cmd_dada \
  "update"            "Updates Dada shell theme and bins" \
  "dada-cron"         "Runs the theme hourly cron script" \

function ttestt
  print_cmd_lines (set_color blue) $cmd_regular
  print_cmd_lines (set_color yellow) $cmd_scripts
  print_cmd_lines (set_color green) $cmd_project
  print_cmd_lines (set_color purple) $cmd_git
  print_cmd_lines (set_color red) $cmd_backup
  print_cmd_lines (set_color cyan) $cmd_network
  print_cmd_lines (set_color brblack) $cmd_dada
end

function print_cmd_lines \
  --description "Iterates through a list of commands and prints the items as columns"
  set items (math (count $argv[2..-1]) / 2)
  set normal (set_color normal)
  set color $argv[1]

  for n in (seq $items)
    set offset (math $n \* 2 - 1)
    set name $color$argv[(math $offset + 1)]
    set desc $normal$argv[(math $offset + 2)]
    # Note: columns are 16 and 34, plus space for escape codes.
    printf "%-21s%-45s" "$name" "$desc"
    if [ (math $n \% 2) -eq 0 ]; or [ $n -eq $items ]
      echo -n \n
    end
  end
end

function print_cols \
  --argument-names lines \
  --description "Prints lines in columns"

end

