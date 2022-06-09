# Dada Shell Theme © 2019-2021

set cmd_regular \
  "tree"              "Runs ls with tree structure" \
  "headers <url>"     "Displays headers for a URL" \
  "crc32u <file>"     "Prints CRC32 hash of file" \
  "help"              "Displays this command list" \
  "scripts"           "Lists the available scripts" \
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
  "jq <json>"         "Parses and filters JSON data" \
  "fd <str>"          "Searches for files (alt. to find)" \
  "ip"                "Prints out the current local IP" \
  "randstr"           "Prints a random string of chars" \
  "doc <file>"        "Reads Markdown file in terminal" \
  "setssh"            "Turns remote SSH access on/off" \
  "zipdir{n} <dir>"   "Zips a directory (compr. 0-9)" \
  "urlredirs <url>"   "Displays what redirects a URL has" \
  "screenres"         "Prints current screen resolutions" \
  "bat"               "Improved version of cat" \
  "unar"              "Universal unarchiving utility" \
  "findext"           "Finds all files with a given ext" \
  "cclear"            "Clears the screen and text buffer" \
  "open_npm"          "Opens npm page for this package" \

set cmd_images \
  "img_jpeg <img>"    "Converts images to jpeg" \
  "img_trim <img>"    "Trims the border off an image" \
  "img_r50p <img>"    "Resizes an image to 50% size" \
  "img_r200p <img>"   "Resizes an image to 200% size" \
  "img_r400p <img>"   "Resizes an image to 400% size" \
  "img_res_set"       "Sets an image's resolution value" \
  "enc_x265_hq"       "Encode to high quality x265" \
  "enc_vg_up4x"       "Encode 4x upscaled for video games" \
  "enc_old_anime4k"   "Encode old grainy 4K anime" \
  "enc_x264_y4ll"     "Encode to lossless x264 yuv444" \
  "enc_x264_rgbll"    "Encode to lossless x264 rgb" \
  "jpeg_scr"          "Converts desktop scrshots to jpeg" \
  #"img_isakura <i>"   "Processes iSakura TV screenshot" \

set cmd_conversions \
  "dmg2iso <file>"    "Converts a .dmg file to .iso" \
  "bin2iso <file>"    "Converts .bin/.cue files to .iso" \
  "ccd2iso <file>"    "Converts a .ccd file to .iso" \
  "mdf2iso <file>"    "Converts an .mdf file to .iso" \
  "ps2pdf <file>"     "Convert PS to PDF" \
  "prnpdf <dir>"      "Converts all .prn files to .pdf" \

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
  "youtube-dl"        "Downloads videos from URL" \
  "youtube-mp3"       "Runs youtube-dl for audio files" \
  "youtube-arcdl"     "Video downloader in archive mode" \
  "ascr"              "Downloads art from social media" \
  "ncdu"              "Shows directory disk space usage" \
  "vgmpfdl <url>"     "Downloads albums from vgmpf.com" \
  "rip-music <url>"   "Rips music files from a URL" \
  "color-dirs"        "Colorizes subdirs by tech" \
  "eatsql <file>"     "Shortcut to import SQL dumps" \
  "pinger"            "Checks if we are online" \
  "unecm"             "Converts ECM files to BIN" \
  "convert"           "Converts images other formats" \
  "mirror_website"    "Downloads an entire website copy" \
  "scrape_media"      "Scrapes media files from a url" \

set cmd_project \
  "proj"              "Displays current project info" \
  "jira"              "Lists Jira issue branches in repo" \
  "recentprojs"        "Prints recently edited projects" \
  "updrepos"          "Updates all project repos" \

set cmd_git_short \
  "g"                 "Git status" \
  "ghelp"             "Displays more Git commands help" \
  "gb"                "Last Git commits per branch" \

set cmd_backup \
  "backup"            "Displays backup commands and info" \
  "backup-config"     "Backs up ~/.config/ dirs" \
  "backup-dbs"        "Backs up MySQL databases" \
  "backup-files"      "Backs up ~/Files" \
  "backup-efi"        "Backs up EFI partition" \
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
  "cron-installed"         "Checks the Cron script's status" \

set scripts_regular \
  "collect_images.sh"         "Collects images from anywhere in the current directory" \
  "make_contact_sheet.sh"     "Opens a contact sheet html file for the current directory" \
  "convert_bryce.fish"        "Converts .bmp files in the Bryce dir to .png files" \
  "cutvid.py"                 "Script for cutting up videos" \
  "build-dosbox.sh"           "Builds the latest version of DOSBox-X and symlinks it" \
  "enc_flac.bash"             "Converts a .wav file to .flac" \
  "git_jira.bash"             "Lists a project's last 25 issue branches by commit order" \
  "image_floppy.fish"         "Images a floppy to .img file" \
  "img_twtr.bash"             "Adds a transparent pixel to an image for Twitter" \
  "img_downres.sh"            "Downscales images from a source resolution to a target resolution" \
  "import_music_subset.fish"  "Imports several music genres from the backup" \
  "makevids.sh"               "Turns a set of audio and image files into videos" \
  "serverinfo.fish"           "Displays info about the device's web server" \
  "update_projects.fish"      "Pulls the latest changes for all projects" \
  "view_projects.fish"        "Displays a list of projects with recent commits" \
  "wiki_potd.js"              "Retrieves the picture of the day from Wikipedia" \
  "iahtml.js"                 "Generates an HTML table of file information for the Internet Archive" \

set scripts_ia \
  "ia_scans.sh"               "Prints an Internet Archive description with a table of scans" \

set scripts_housekeeping \
  "clean_3ds.fish"            "Cleans up unneeded files from the 3DS" \
  "clean_screenshots.fish"    "Deletes screenshots from ~/Desktop/ except for \"(2)\" files" \
  "remove_dsstore.fish"       "Removes .DS_Store files from a given directory" \

function help \
  --description "Prints all available commands"
  # Merge all various command lists together and add colors.
  set _cmd_all
  set -a _cmd_all (_add_cmd_colors (set_color blue) $cmd_regular)
  set -a _cmd_all (_add_cmd_colors (set_color ff7e00) $cmd_images)
  set -a _cmd_all (_add_cmd_colors (set_color yellow) $cmd_scripts)
  set -a _cmd_all (_add_cmd_colors (set_color brgreen) $cmd_conversions)
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

function scripts \
  --description "Prints all available scripts"
  set _scripts_all
  set -a _scripts_all (_add_cmd_colors (set_color blue) $scripts_regular)
  set -a _scripts_all (_add_cmd_colors (set_color yellow) $scripts_ia)
  set -a _scripts_all (_add_cmd_colors (set_color green) $scripts_housekeeping)

  echo
  echo "The following scripts are available:"
  echo

  _iterate_list $_scripts_all

  echo
end
