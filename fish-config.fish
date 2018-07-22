function drewdrew
  for x in (seq 500)
    set y (math $x + 1)
    ffmpeg -y -i drew$x.mp4 -vf fps=20,scale=320:-1:flags=lanczos,palettegen palette.png
    ffmpeg -i drew$x.mp4 -i palette.png -filter_complex "fps=20,scale=320:-1:flags=lanczos[x];[x][1:v]paletteuse" drew$x.gif
    rm palette.png
    ffmpeg -f gif -i drew$x.gif drew$y.mp4
  end
end

source ~/.dada/bobthefish-custom.fish

# Git commands/shortcuts
source ~/.dada/ms-git.fish
# API keys
source ~/.dada/secrets/keys.fish

set -gx LESS_TERMCAP_md (printf "\e[01;31m")
set -gx LESS_TERMCAP_me (printf "\e[0m")
set -gx LESS_TERMCAP_se (printf "\e[0m")
set -gx LESS_TERMCAP_so (printf "\e[01;44;33m")
set -gx LESS_TERMCAP_ue (printf "\e[0m")
set -gx LESS_TERMCAP_us (printf "\e[01;32m")

set -gx DEBUG 1;

set -gx CEEGEE_ROOT_DIR "/Users/msikma/Personal projects/ceegee";
set -gx CEEGEE_BUILD_DEST_DIR "/Users/msikma/Personal projects/ceegee_nightly";

set fish_greeting ""

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

function video2gif
    ffmpeg -y -i $argv[1] -vf fps=20,scale=320:-1:flags=lanczos,palettegen palette.png
    ffmpeg -i $argv[1] -i palette.png -filter_complex "fps=20,scale=320:-1:flags=lanczos[x];[x][1:v]paletteuse" $argv[1].gif
    rm palette.png
end

function scrapemp3s
    wget -r -l1 -H -t3 -nd -N -np -A.mp3 -erobots=off $argv
end

function findfile
    find / -name $argv 2> /dev/null
end

function headers
    curl -sILk $argv | sed '$d'
end

set -x SCSCRAPE_DIR ~/Music/scscrape
set VAGRANT_DEFAULT_PROVIDER virtualbox
set -x EDITOR nano
set -x GIT_EDITOR nano

set PATH ~ $PATH
set PATH /usr/bin $PATH
set PATH /bin /usr/sbin /sbin $PATH
set PATH /usr/local/bin $PATH
set PATH ~/.bin/ $PATH
set PATH ~/.bin/misc-scripts $PATH
set PATH ./node_modules/.bin $PATH
if test -d ~/Personal\ projects/liballeg.4.4.2-osx/tools
  set PATH ~/Personal\ projects/liballeg.4.4.2-osx/tools $PATH
end
if test -d /usr/local/djgpp/bin/
  set PATH /usr/local/djgpp/bin/ $PATH
end
set PATH ~/.composer/vendor/bin $PATH
set PATH ~/.cargo/bin $PATH

set -x LC_ALL en_US.UTF-8

set MANPATH /opt/local/share/man $MANPATH
set -x DJGPP_PREFIX /usr/local/djgpp
set -x DJGPP_CC /usr/local/djgpp/bin/i586-pc-msdosdjgpp-gcc
set -x DJGPP_RANLIB /usr/local/djgpp/bin/i586-pc-msdosdjgpp-ranlib
set -x DJDIR /usr/local/djgpp/djgpp.env
set -x NIMLIB ~/Source/Nim/lib/

set -x LDFLAGS -L/usr/local/opt/qt5/lib
set -x CPPFLAGS -I/usr/local/opt/qt5/include

alias ls="ls -G"
alias l="ls -lah"
alias wget="wget --no-check-certificate"
alias latest="ls -1t | head -5"
alias wifireset="networksetup -setairportpower en0 off & networksetup -setairportpower en0 on"

# Virtualfish (for real this time)
#eval (python -m virtualfish auto_activation global_requirements)
