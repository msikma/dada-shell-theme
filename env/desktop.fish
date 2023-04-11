# Dada Shell Theme © 2019, 2020

source $DADA"env/common.fish"

function get_node_version --description "Returns our default Node version (assuming nvm is installed)"
  if test -e ~/.nvmrc
    cat ~/.nvmrc
  else
    node -v
  end
end

# Node path so we can import global packages. Be careful!
set -gx NODE_PATH /usr/local/lib/node_modules $NODE_PATH

# A ton of path segments to add
set PATH ~ $PATH
if test -d /usr/local/opt/node@8/bin
  set PATH /usr/local/opt/node@8/bin $PATH
end
set PATH /usr/bin $PATH
set PATH /bin /usr/sbin /sbin $PATH
set PATH /usr/local/sbin $PATH
set PATH /usr/local/bin $PATH
set PATH ~/.bin/ $PATH
set PATH ~/.bin/misc-scripts $PATH  # clone from https://github.com/msikma/misc-scripts
set PATH ~/.bin/misc-bin $PATH      # clone from https://bitbucket.org/msikma/misc-bin
if test -d /opt/homebrew/bin
  # Add Homebrew paths before everything else, so they have precedence.
  set PATH /opt/homebrew/bin $PATH
  # Add paths for Meson.
  set -x LIBRARY_PATH /opt/homebrew/lib $LIBRARY_PATH
  set -x CPATH /opt/homebrew/include $CPATH
  set -x LIBRARY_PATH /opt/homebrew/Cellar/molten-vk/1.1.10_1/lib $LIBRARY_PATH
  set -x CPATH /opt/homebrew/Cellar/molten-vk/1.1.10_1/include $CPATH
  # Other things needed to build.
  set -x Qt5_DIR /opt/homebrew/opt/qt5
end

if test -e ~/.config/fish/conf.d/nvm.fish
  # Hack: somehow 'nvm use' doesn't work when it's here.
  # nvm use 19
  set PATH ~/.local/share/nvm/(get_node_version)/bin $PATH
end

if test -d ~/.cargo/env
  set PATH ~/.cargo/env $PATH
end
if test -d ~/go/bin
  set PATH ~/go/bin $PATH
end

if test -d ~/Personal\ projects/liballeg.4.4.2-osx/tools
  set PATH ~/Personal\ projects/liballeg.4.4.2-osx/tools $PATH
end
if test -d ~/Source/liballeg.4.4.2-osx/tools
  set PATH ~/Source/liballeg.4.4.2-osx/tools $PATH
end
if test -d /usr/local/djgpp/bin/
  set PATH /usr/local/djgpp/bin/ $PATH
end
set PATH ~/.composer/vendor/bin $PATH

# game
if test -d ~/Projects/fishtetris
  set PATH ~/Projects/fishtetris $PATH
end

# 3DS development - DevkitPro and Citra
set -gx DEVKITPRO /opt/devkitpro
set -gx DEVKITARM "$DEVKITPRO/devkitARM"
set -gx CTRULIB "$DEVKITPRO/libctru"
set -gx CTRBANNERTOOL "/$UDIR/msikma/.bin/misc-bin/bannertool"
if test -d $DEVKITPRO
  set PATH $DEVKITPRO/tools/bin/ $PATH
  set PATH $DEVKITPRO/pacman/bin/ $PATH
end
if test -d $DEVKITARM/bin
  set PATH $DEVKITARM/bin $PATH
end
set -l CITRADIR /Applications/Citra
if test -e $CITRADIR/nightly/citra
  set PATH $CITRADIR/nightly/ $PATH
else if test -e $CITRADIR/canary/citra
  set PATH $CITRADIR/canary/ $PATH
end

set -gx FLOPPY_IMAGING_PATH ~/"Files/Floppy disk images/"

# For CeeGee
set -gx DEBUG 1;

set -gx CEEGEE_ROOT_DIR "/$UDIR/"(whoami)"/Personal projects/ceegee";
set -gx CEEGEE_BUILD_DEST_DIR "/$UDIR/"(whoami)"/Personal projects/ceegee_nightly";

set -x SCSCRAPE_DIR ~/Music/scscrape
set -x VAGRANT_DEFAULT_PROVIDER virtualbox

set MANPATH /opt/local/share/man $MANPATH
set -x DJGPP_PREFIX /usr/local/djgpp
set -x DJGPP_CC /usr/local/djgpp/bin/i586-pc-msdosdjgpp-gcc
set -x DJGPP_RANLIB /usr/local/djgpp/bin/i586-pc-msdosdjgpp-ranlib
set -x DJDIR /usr/local/djgpp/djgpp.env
set -x NIMLIB ~/Source/Nim/lib/

set -x LDFLAGS -L/usr/local/opt/qt5/lib
set -x CPPFLAGS -I/usr/local/opt/qt5/include

# For testing web scrapers projects and others
set -gx WEB_SCRAPERS_USE_SRC 1
set -gx MSIKMA_WEB_SCRAPERS_SRC 1
set -gx MSIKMA_USE_SRC 1
set -gx DADA_CATAWIKI_TLD NL

# For compiling DOSBox
set -gx DOSBOX_SRC_DIR "/$UDIR/msikma/Source/dosbox-code-0"
set -gx DOSBOX_APP_DIR "/$UDIR/msikma/Files/Games/DOSBox"
set -gx DADA_DOSBOX_DIR ~/"Games/DOSBox/"

# Bryce artwork directory
set -gx FUJI_BRYCE_DIR ~/"Files/VMs/FujiXP/Shared/Bryce/"
set -gx VESUVIUS_BRYCE_DIR ~/"Files/VMs/VesuviusXP/Files/Bryce/"
if [ -d "$FUJI_BRYCE_DIR" ]
  set -gx DADA_BRYCE_DIR "$FUJI_BRYCE_DIR"
else
  set -gx DADA_BRYCE_DIR "$VESUVIUS_BRYCE_DIR"
end

# Soulseek
set -gx SLSK_CHAT_LOGS_DIR_SRC ~/"Soulseek Chat Logs/"
set -gx SLSK_CHAT_LOGS_DIR_DST ~/"Files/Storage/Soulseek Chat Logs/"

# For Whisper
set -gx WHISPER_MODEL ~/".resources/models/whisper-ggml-large.bin"

# RPG Maker/EasyRPG Player
set -gx RPG2K_RTP_PATH ~/".config/rtp/2000"
set -gx RPG2K3_RTP_PATH ~/".config/rtp/2003"
