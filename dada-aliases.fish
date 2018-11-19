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
alias code="code-insiders"

# Dada scripts
alias proj="node-project.js"
alias jira="git-jira.fish"
alias projects="view-projects.fish"
alias updrepos="update-projects.fish"
alias imgfloppy="image-floppy.fish"
alias tasks="jira-list.js"

function doc
  mdv $argv | less -r
end
