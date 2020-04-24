# Dada Shell Theme © 2019, 2020

# OSX applications
alias chrome="open -a Google\ Chrome\ Canary"
alias md="open -a MacDown"
alias vlc="/Applications/VLC.app/Contents/MacOS/VLC"

# OSX standard utilities
alias wifireset="networksetup -setairportpower en0 off & networksetup -setairportpower en0 on"

# Utilities installed with Brew
alias composer="php ~/.bin/composer.phar"
alias livestreamer="streamlink --default-stream best"
alias md5sum="gmd5sum"
alias ncdu="ncdu --color dark -q -r"
alias sha1sum="gsha1sum"
alias streamlink="streamlink --default-stream best --player '/Applications/VLC3.app/Contents/MacOS/VLC --file-caching 10000 --network-caching 10000'"
alias wget="wget --no-check-certificate"
alias youtube-audio="youtube-audio-dl 'best'" # note: see 'youtube-audio-dl' function
alias youtube-mp3="youtube-audio-dl 'mp3'"
alias youtube-wav="youtube-audio-dl 'wav'"

# Utilities in ~/.bin/
alias bfg="java -jar ~/.bin/bfg.jar"

# Utilities in ~/.bin/misc-bin/
alias colortest="terminal-colors --rgb; terminal-colors --ansicodes"
alias fdupes="jdupes"

# ls replacement exa
alias ls="exa"
alias l='exa -la --git -I Icon\r"|.DS_Store"' # remove pesky .DS_Store and Icon
alias ll='exa -lah --git' # like l but with all files, with header
alias le='exa -lah@ --git' # like le but with extended attributes
alias tree="exa -Tla --git-ignore -I .git" # displays a tree (ignoring .git dirs)
alias latest="ls -lah --git -s old --color=always | head -11" # shows 10 latest modifications

# Bin
alias cutvid="cutvid.py"
alias encflac="enc_flac.bash"
alias imgfloppy="image_floppy.fish"
alias jira="git_jira.bash"
alias proj="projinfo"
alias recentprojs="view_projects.fish"
alias tasks="$DADA/bin/jira-tasks/tasks.js"
alias projs="$DADA/bin/jira-tasks/projs.js"
alias updrepos="update_projects.fish"
alias wikipotd="wiki_potd.js"

# Scripts
alias backup-3ds="backup-3ds.fish"
alias backup-switch="backup-switch.fish"
alias backup-config="backup-config.fish"
alias backup-dbs="backup-dbs.fish"
alias backup-files="backup-files.fish"
alias backup-efi="backup-efi.fish"
alias backup-vms="backup-vms.fish"
alias backup-ftp="backup-ftp.fish"
alias backup-games="backup-games.fish"
alias backup-music="backup-music.fish"
alias backup-src="backup-src.fish"
alias backup-zoo="backup-zoo.fish"
alias color="color.fish"
alias color-dirs="color-dirs.fish"
alias crc32u="crc32u.bash"
alias cssb64="cssb64.bash"
alias ftypes="ftypes.fish"
alias pinger="pinger.fish"
alias serverinfo="serverinfo.fish"
alias setssh="setssh.fish"
