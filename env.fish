# Dada Shell Theme © 2019

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
set PATH ~/.config/dada/bin $PATH      # for larger scripts, with extension
set PATH ~/.config/dada/scripts $PATH  # for smaller scripts/commands
set PATH ~/.bin/ $PATH
set PATH ~/.bin/misc-scripts $PATH  # clone from https://github.com/msikma/misc-scripts
set PATH ~/.bin/misc-bin $PATH      # clone from https://bitbucket.org/msikma/misc-bin
set PATH ./node_modules/.bin $PATH
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
set PATH ~/.cargo/bin $PATH
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

set -gx LESS_TERMCAP_md (printf "\e[01;31m")
set -gx LESS_TERMCAP_me (printf "\e[0m")
set -gx LESS_TERMCAP_se (printf "\e[0m")
set -gx LESS_TERMCAP_so (printf "\e[01;44;33m")
set -gx LESS_TERMCAP_ue (printf "\e[0m")
set -gx LESS_TERMCAP_us (printf "\e[01;32m")

# For CeeGee
set -gx DEBUG 1;

set -gx CEEGEE_ROOT_DIR "/$UDIR/"(whoami)"/Personal projects/ceegee";
set -gx CEEGEE_BUILD_DEST_DIR "/$UDIR/"(whoami)"/Personal projects/ceegee_nightly";

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

# For testing web scrapers projects and others
set -gx WEB_SCRAPERS_USE_SRC 1
set -gx MSIKMA_WEB_SCRAPERS_SRC 1
set -gx MSIKMA_USE_SRC 1
set -gx DADA_CATAWIKI_TLD NL

# For compiling DOSBox
set -gx DOSBOX_SRC_DIR "/$UDIR/msikma/Source/dosbox-code-0"
set -gx DOSBOX_APP_DIR "/$UDIR/msikma/Files/Games/DOSBox"

# Bryce artwork directory
set -gx FUJI_BRYCE_DIR ~/"Files/VMs/FujiXP/FujiXP HDD/Bryce/"
set -gx VESUVIUS_BRYCE_DIR ~/"Files/VMs/VesuviusXP/Files/Bryce/"
if [ -d "$FUJI_BRYCE_DIR" ];
  set -gx DADA_BRYCE_DIR "$FUJI_BRYCE_DIR"
else
  set -gx DADA_BRYCE_DIR "$VESUVIUS_BRYCE_DIR"
end
