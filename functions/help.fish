# Dada Shell Theme © 2019

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
  "newx <file>"       "Creates a new executable script" \
  "jv <file>"         "Displays JSON file content" \
  "fd <str>"          "Searches for files (alt. to find)" \
  "doc <file>"        "Reads Markdown file in terminal" \
  "setssh"            "Turns remote SSH access on/off" \
  "urlredirs <url>"   "Displays what redirects a URL has" \
  "bat"               "Improved version of cat" \
  "dmg2iso <file>"    "Converts a .dmg file to .iso" \
  "img_isakura <i>"   "Processes iSakura TV screenshot" \
  "img_trim <img>"    "Trims the border off an image" \

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
  "unecm"             "Converts ECM files to BIN" \
  "convert"           "Converts images other formats" \

set cmd_project \
  "proj"              "Displays current project info" \
  "jira"              "Lists Jira issue branches in repo" \
  "recentprojs"        "Prints recently edited projects" \
  "updrepos"          "Updates all project repos" \
  "tasks"             "Displays Theorycraft Jira tasks" \

set cmd_git_short \
  "g"                 "Git status" \
  "ghelp"             "Displays more Git commands help" \
  "gb"                "Last Git commits per branch" \

set cmd_backup \
  "backup"            "Displays backup commands and info" \
  "backup-config"     "Backs up ~/.config/ dirs" \
  "backup-dbs"        "Backs up MySQL databases" \
  "backup-files"      "Backs up ~/Files" \
  "backup-games"      "Backs up game content" \
  "backup-music"      "Backs up music" \
  "backup-src"        "Backs up source code dirs" \

set cmd_jira \
  'tasks'             "Lists tasks defined in Jira" \
  'projs'             "Lists projects and Github stats" \

set cmd_network \
  "devices"           "Displays local computers" \
  "servers"           "Displays a list of servers" \

set cmd_dada \
  "alert-log"         "Views the alert log for this month" \
  "dada-reload"       "Reloads the theme code" \
  "dada-cron"         "Runs the Cron script manually" \
  "dada-update"       "Updates Dada shell theme and bins" \
  #"cron-install"      "Installs the Cron script" \ # removed for brevity since it's only needed once; mentioned in the install.
  "cron-log"          "Views the Cron log for this month" \
  "cron-info"         "Checks the Cron script's status" \

function help \
  --description "Prints all available commands"
  # Merge all various command lists together and add colors.
  set _cmd_all
  set -a _cmd_all (_add_cmd_colors (set_color blue) $cmd_regular)
  set -a _cmd_all (_add_cmd_colors (set_color yellow) $cmd_scripts)
  set -a _cmd_all (_add_cmd_colors (set_color purple) $cmd_git_short)
  set -a _cmd_all (_add_cmd_colors (set_color red) $cmd_backup)
  set -a _cmd_all (_add_cmd_colors (set_color green) $cmd_project)
  set -a _cmd_all (_add_cmd_colors (set_color cyan) $cmd_network)
  set -a _cmd_all (_add_cmd_colors (set_color blue) $cmd_jira)
  set -a _cmd_all (_add_cmd_colors (set_color brblack) $cmd_dada)

  echo
  echo "The following commands are available:"
  echo

  _iterate_help $_cmd_all

  echo
end
