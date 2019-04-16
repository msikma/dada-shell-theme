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
  "cssb64"            "Outputs an image as Base64 CSS" \
  "scrapemp3s"        "Scrapes MP3 files from a URL" \
  "streamlink"        "Opens internet streams in VLC" \
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
  "pinger"            "Continuously if we are online" \

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

function help
  set neutral (set_color normal)

  # Merge all various command lists together and add colors.
  set _cmd_all
  set -a _cmd_all (_add_cmd_colors (set_color blue) $cmd_regular)
  set -a _cmd_all (_add_cmd_colors (set_color yellow) $cmd_scripts)
  set -a _cmd_all (_add_cmd_colors (set_color purple) $cmd_git)
  set -a _cmd_all (_add_cmd_colors (set_color red) $cmd_backup)
  set -a _cmd_all (_add_cmd_colors (set_color green) $cmd_project)
  set -a _cmd_all (_add_cmd_colors (set_color cyan) $cmd_network)
  set -a _cmd_all (_add_cmd_colors (set_color brblack) $cmd_dada)

  echo
  echo "The following commands are available:"
  echo

  # Iterate through our merged list and print the command name and description.
  set m 0
  set total (math 4 + (count $_cmd_all))
  set half (math "(floor($total / 8) * 4)")
  for n in (seq 1 4 (math $half))
    set m (math $m + 1)

    set l_color $_cmd_all[$n]
    set l_cmd_n $_cmd_all[(math $n + 1)]
    set l_cmd_d $_cmd_all[(math $n + 3)]

    set r_color $_cmd_all[(math $n + $half)]
    set r_cmd_n $_cmd_all[(math $n + $half + 1)]
    set r_cmd_d $_cmd_all[(math $n + $half + 3)]

    printf "%s%-16s%s%-34s%s%-16s%s%-34s\\n" $l_color $l_cmd_n $neutral $l_cmd_d $r_color $r_cmd_n $neutral $r_cmd_d
  end

  echo
end

# Injects colors into a list of commands
function _add_cmd_colors
  set color $argv[1]
  set neutral (set_color normal)

  set items (math (count $argv[2..-1]) + 1)
  for n in (seq 2 2 $items)
    echo $color
    echo $argv[$n]
    echo $neutral
    echo $argv[(math $n + 1)]
  end
end


