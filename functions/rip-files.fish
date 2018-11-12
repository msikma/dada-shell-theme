# Realistic user agent
set __moz_ag "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/64.0.3282.167 Safari/537.36"

# Alternative:
# "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.13; rv:63.0) Gecko/20100101 Firefox/63.0"

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
function rip_url_files --description "Rip audio files from a URL"
  set target $argv[1]
  set types $argv[2]
  if test -n "types"
    set types "--accept=$types"
  end
  wget --no-verbose \
       --no-clobber \
       --user-agent=$__moz_ag \
       --recursive \
       --level=0 \
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
  rip_url_files $argv[1] "mp3,flac,wmv,ogg,m4a,opus,rar"
end

# Rips all image files from a URL.
function rip_url_images --description "Rips image files from a URL"
  rip_url_files $argv[1] "jpg,jpeg,gif,png,bmp,tiff,psd"
end
