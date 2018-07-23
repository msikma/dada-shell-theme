# Prompt and other style things
source ~/.dada/dada-theme.fish
# source ~/.dada/bobthefish-custom.fish  # disabled for now.
# Git commands/shortcuts
source ~/.dada/ms-git.fish
# API keys
source ~/.dada/secrets/keys.fish
# Functions
source ~/.dada/dada-functions.fish

# A ton of path segments to add
set PATH ~ $PATH
set PATH /usr/bin $PATH
set PATH /bin /usr/sbin /sbin $PATH
set PATH /usr/local/bin $PATH
set PATH ~/.bin/ $PATH
set PATH ~/.bin/misc-scripts $PATH  # clone from https://github.com/msikma/misc-scripts
set PATH ~/.bin/misc-bin $PATH      # clone from https://bitbucket.org/msikma/misc-bin
set PATH ./node_modules/.bin $PATH
if test -d ~/Personal\ projects/liballeg.4.4.2-osx/tools
  set PATH ~/Personal\ projects/liballeg.4.4.2-osx/tools $PATH
end
if test -d /usr/local/djgpp/bin/
  set PATH /usr/local/djgpp/bin/ $PATH
end
set PATH ~/.composer/vendor/bin $PATH
set PATH ~/.cargo/bin $PATH

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
alias ls="ls -G"
alias l="ls -lah"
alias wget="wget --no-check-certificate"
alias latest="ls -1t | head -5"
alias wifireset="networksetup -setairportpower en0 off & networksetup -setairportpower en0 on"

set -gx LESS_TERMCAP_md (printf "\e[01;31m")
set -gx LESS_TERMCAP_me (printf "\e[0m")
set -gx LESS_TERMCAP_se (printf "\e[0m")
set -gx LESS_TERMCAP_so (printf "\e[01;44;33m")
set -gx LESS_TERMCAP_ue (printf "\e[0m")
set -gx LESS_TERMCAP_us (printf "\e[01;32m")

# For CeeGee
set -gx DEBUG 1;

set -gx CEEGEE_ROOT_DIR "/Users/msikma/Personal projects/ceegee";
set -gx CEEGEE_BUILD_DEST_DIR "/Users/msikma/Personal projects/ceegee_nightly";

set -x SCSCRAPE_DIR ~/Music/scscrape
set -x VAGRANT_DEFAULT_PROVIDER virtualbox
set -x EDITOR nano
set -x GIT_EDITOR nano

set -x LC_ALL en_US.UTF-8

set MANPATH /opt/local/share/man $MANPATH
set -x DJGPP_PREFIX /usr/local/djgpp
set -x DJGPP_CC /usr/local/djgpp/bin/i586-pc-msdosdjgpp-gcc
set -x DJGPP_RANLIB /usr/local/djgpp/bin/i586-pc-msdosdjgpp-ranlib
set -x DJDIR /usr/local/djgpp/djgpp.env
set -x NIMLIB ~/Source/Nim/lib/

set -x LDFLAGS -L/usr/local/opt/qt5/lib
set -x CPPFLAGS -I/usr/local/opt/qt5/include

# Virtualfish (for real this time)
#eval (python -m virtualfish auto_activation global_requirements)
