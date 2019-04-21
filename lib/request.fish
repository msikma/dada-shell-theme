# Dada Shell Theme © 2019

# Realistic user agent. Alternative:
# "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.13; rv:63.0) Gecko/20100101 Firefox/63.0"
set __moz_ag "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/64.0.3282.167 Safari/537.36"

# Accept language string for getting localized content.
set -gx dada_acceptlang "ja,en-US;q=0.7,en;q=0.3"

# Rips all files from specific filetypes from a URL.
# Always only follows links on the given page (depth = 1).
#
# --no-verbose          display far less data than normal
# --no-clobber          don't download files that would overwrite an existing one
# --recursive           in case files are hosted on a different domain
# --level=1             just go one level deep (default: 5)
# --span-hosts          permit recursing into different domains
# --tries=1             only retry once; if it's not there it's not there
# --no-directories      don't create a directory structure for fetched files; keep them in cwd
# --timestamping        don't redownload files we already know we have (by timestamp)
# --no-parent           don't ascend to the parent directory (which prob. contains unrelated files only)
# --execute robots=off  totally ignore robots.txt telling us to fuck off (sorry)
# --accept <list>       accept only these filetypes
#
function rip_url_files --description "Rip files from a URL"
  set target $argv[1]
  set types $argv[2]
  set level 0  # hardcoded for now
  echo (set_color yellow)"Ripping files from URL: "(set_color blue)"$target"(set_color normal)
  echo (set_color yellow)"Saving file types: "(set_color purple)"$types"(set_color yellow)" (depth: $level)"(set_color normal)
  
  if test -n "types"
    set types "--accept=$types"
  end
  
  # If level is 0, we need to pass --page-requisites instead of --level;
  # a level value of 0 stands for 'infinite' otherwise.
  if [ "$level" = "0" ]
    set rec_opts "--page-requisites"
  else
    set rec_opts "--recursive" "--level=$level"
  end
  
  wget --no-verbose \
       --no-clobber \
       --user-agent=$__moz_ag \
       $rec_opts \
       --span-hosts \
       --tries=1 \
       --no-directories \
       #--timestamping \
       --no-parent \
       --execute robots=off \
       "$types" \
       "$target"
end

# Rips all music files from a URL.
function rip_url_music --description "Rips audio files from a URL"
  if test -z "$argv[1]"
    echo 'rip-music: error: no URL given'
    return 1
  end
  rip_url_files $argv[1] "mp3,flac,wmv,ogg,m4a,opus,rar"
end

# Rips all image files from a URL.
function rip_url_images --description "Rips image files from a URL"
  if test -z "$argv[1]"
    echo 'rip-imgs: error: no URL given'
    return 1
  end
  rip_url_files $argv[1] "jpg,jpeg,gif,png,bmp,tiff,psd"
end

# Shortcuts.
function rip-music
  rip_url_music $argv[1]
end

function rip-imgs
  rip_url_images $argv[1]
end
