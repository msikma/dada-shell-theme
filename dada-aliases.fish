alias fdupes="jdupes"
alias composer="php ~/.bin/composer.phar"
alias md5sum="gmd5sum"
alias sha1sum="gsha1sum"
alias streamlink="streamlink --default-stream best --player '/Applications/VLC3.app/Contents/MacOS/VLC --file-caching 10000 --network-caching 10000'"
alias livestreamer="streamlink --default-stream best"
alias scrip="youtube-dl -w -c --add-metadata"
alias youtube-wav="youtube-dl -x --add-metadata --audio-format wav"
alias youtube-mp3="youtube-dl -x --add-metadata --audio-format mp3"
alias youtube-audio="youtube-dl --audio-format best -x"
alias chrome="open -a Google\ Chrome\ Canary"
alias vlc="/Applications/VLC.app/Contents/MacOS/VLC"
alias ls="exa"
alias l='exa -la --git -I Icon\r"|.DS_Store"'
alias ll='exa -lah --git'
alias tree="exa -Tla --git-ignore -I .git"
alias wget="wget --no-check-certificate"
alias latest="ls -1t | head -5"
alias wifireset="networksetup -setairportpower en0 off & networksetup -setairportpower en0 on"
alias ncdu="ncdu --color dark -q -r"
#alias code="if test -d code-insiders"
function code
  if not test -d "$argv"
    echo "code: Error: can't find ""$argv"
    return 1
  end
  code-insiders $argv
end
alias colortest="terminal-colors --rgb; terminal-colors --ansicodes"

# Bin
alias encflac="enc-flac.bash"
alias jira="git-jira.fish"
alias proj="node-project.js"
alias projects="view-projects.fish"
alias updrepos="update-projects.fish"
alias imgfloppy="image-floppy.fish"
alias tasks="jira-list.js"
alias wikipotd="wiki-potd.js"
alias cutvid="cutvid.py"

# Scripts
alias backup-3ds="backup-3ds.fish"
alias backup-config="backup-config.fish"
alias backup-dbs="backup-dbs.fish"
alias backup-files="backup-files.fish"
alias backup-ftp="backup-ftp.fish"
alias backup-games="backup-games.fish"
alias backup-music="backup-music.fish"
alias backup-src="backup-src.bash"
alias backup-zoo="backup-zoo.fish"
alias color="color.fish"
alias crc32u="crc32u.bash"
alias ftypes="ftypes.fish"
alias setssh="setssh.fish"

function doc
  mdv $argv | less -r
end
