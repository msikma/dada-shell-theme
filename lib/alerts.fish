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

# Maximum length of the title and preview.
set -g title_max (math $alerts_width - 14)
set -g preview_max "280"

# New mails are given as strings containing all relevant information.
# The strings use '@%@' as separator, and they contain the following data (in order):
# [id, unix_timestamp, sender, subject, preview, link]
function _make_new_alerts \
  --description "Loads 'ms-gmail-cli' and creates alerts for every new mail"
  _alerts_ensure_dir
  timer_start
  set out (ms-gmail-cli --action list)
  for mail in $out
    set timer (timer_end | sed -e 's/\./_/')
    set id (echo $mail | gawk -F@%@ '{print $1}')
    set unix_timestamp (echo $mail | gawk -F@%@ '{print $2}')
    set sender (echo $mail | gawk -F@%@ '{print $3}')
    set subject (echo $mail | gawk -F@%@ '{print $4}')
    set preview (echo $mail | gawk -F@%@ '{print $5}')
    set link (echo $mail | gawk -F@%@ '{print $6}')

    set preview_length (string length $preview)
    if [ "$preview_length" -gt "$preview_max" ]
      set mail_preview (string sub -s 1 -l "$preview_max" "$preview")"…"
    else
      set mail_preview "$preview"
    end
    set mail_title (string sub -s 1 -l "$title_max" "New mail from $sender: $subject")

    make_alert 'gmail' '-' 'success' "$link" "$timer" "$mail_title"\n"$mail_preview"
  end
end

function _get_alert_unix_time \
  --argument-names filepath \
  --description "Prints the Unix time for when an alert was generated"
  if ! test -e $filepath; return; end
  set ts (echo $filepath | grep -io "_[0-9]\+_")
  set ts (string sub -s 2 -l 10 $ts)

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
  --argument-names filename name level link timer content dstdir \
  --description "Creates a new alert to be displayed on login"
  set unixts (date +"%s")
  set fname "$dstdir""/alert_""$filename""_""$unixts""_""$timer"".txt"
  touch $fname
  echo "$name" >> "$fname"
  echo "$level" >> "$fname"
  echo "$link" >> "$fname"
  echo "$content" >> "$fname"
end

function _alerts_ensure_dir \
  --description "Ensures that the alerts dirs are available"
  mkdir -p $alerts_dir
  mkdir -p $alerts_read_dir
  mkdir -p $alerts_archive_dir
end
