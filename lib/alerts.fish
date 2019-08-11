# Dada Shell Theme © 2019

# Note: some of these functions require GNU Date (via 'coreutils' on Brew).

# Box drawing characters for displaying alert boxes.
set -g _alerts_tl "╭"
set -g _alerts_t "─"
set -g _alerts_tr "╮"
set -g _alerts_l "│ "
set -g _alerts_r " │"
set -g _alerts_bl "╰"
set -g _alerts_b "─"
set -g _alerts_br "╯"

set -g _alerts_dh_tl "╒"
set -g _alerts_dh_t "═"
set -g _alerts_dh_tr "╕"
set -g _alerts_dh_l "│ "
set -g _alerts_dh_r " │"
set -g _alerts_dh_bl "╘"
set -g _alerts_dh_b "═"
set -g _alerts_dh_br "╛"

set -g _alerts_d_tl "╔"
set -g _alerts_d_t "═"
set -g _alerts_d_tr "╗"
set -g _alerts_d_l "║ "
set -g _alerts_d_r " ║"
set -g _alerts_d_bl "╚"
set -g _alerts_d_b "═"
set -g _alerts_d_br "╝"

function _get_alert_unix_time \
  --argument-names filepath \
  --description "Prints the Unix time for when an alert was generated"
  if ! test -e $filepath; return; end
  set ts (echo $filepath | grep -io "_[0-9]\+")
  set ts (string sub -s 2 $ts)

  echo $ts
end

function _find_new_alerts_in_dir \
  --argument-names srcdir \
  --description "Returns a list of new alert files to display in a specific directory"
  set afiles (ls $srcdir/alert_*)
  for afile in $afiles
    if ! test -e "$afile"; continue; end
    echo $afile
  end
end

function _make_alert_in_dir \
  --argument-names filename name level content dstdir \
  --description "Creates a new alert to be displayed on login"
  set unixts (date +"%s")
  set fname "$dstdir""/alert_"$filename"_"$unixts
  touch $fname
  echo "$name" >> "$fname"
  echo "$level" >> "$fname"
  echo "$content" >> "$fname"
end

function _alerts_ensure_dir \
  --description "Ensures that the alerts dirs are available"
  mkdir -p $alerts_dir
  mkdir -p $alerts_read_dir
  mkdir -p $alerts_archive_dir
end
