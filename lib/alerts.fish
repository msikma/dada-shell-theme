# Dada Shell Theme © 2019

# Alerts directory and the archive.
set -g alerts_dir $home"/.cache/dada/alerts"
set -g alerts_read_dir $alerts_dir"/read"
set -g alerts_archive_dir $alerts_dir"/archive"
set -g alerts_log_dir $alerts_dir"/log"

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

function _find_read_alerts_in_dir \
  --argument-names srcdir \
  --description "Returns a short list of read alerts"
  set files (ls --time-style full-iso -lars modified $srcdir/*.txt)

  echo "These are the last seen alerts for "(set_color green)"$dada_uhostname_local"(set_color normal)":"

  for n in (seq (count $files))
    set file $files[$n]

    # Timestamp is full ISO: "2019-08-13 11:50:45.834898001 +0200"
    set ts (echo $file | cut -f4-6 -d' ')
    set tsx (gdate -d "$ts" +"%s")
    set ts_formatted (format_full_timestamp $tsx)

    # Filename is the base without extension: "alert_gmail_1565689845_8_99865"
    set fn (basename (echo $file | cut -f7- -d' ') | strip_ext)

    printf '%4s. %-20s - %s\n' $n $fn $ts_formatted
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

function alerts_log_file \
  --description "Prints out the name of the current log file"
  echo "alerts_log_"(date +"%Y%m")".log"
end

function alerts_log_path \
  --description "Prints out the path of the current log file"
  echo $alerts_log_dir"/"(alerts_log_file)
end

function archive_alert \
  --argument-names filepath \
  --description "Moves an alert into the archive directory"
  mv $filepath $alerts_archive_dir
end

function _alerts_ensure_log \
  --description "Ensures that the log files are available"
  mkdir -p $alerts_log_dir
  touch (alerts_log_path)
end

function _alerts_ensure_dir \
  --description "Ensures that the alerts dirs are available"
  mkdir -p $alerts_dir
  mkdir -p $alerts_read_dir
  mkdir -p $alerts_archive_dir
  mkdir -p $alerts_log_dir
  _alerts_ensure_log
end

# Following are the functions used to print log entries.
# Each line in a log entry runs through one of the non-underscored functions,
# which then prints it to stdout and, if needed, pipes it into the logfile.

# Printing function: every one of the wrapper functions below goes through this.
function _print_alert_line \
  --argument-names str logfile padding
  echo $padding$str
  _print_alert_line_log $str $logfile
end

# Logging function: prints the alert line to the log.
function _print_alert_line_log \
  --argument-names str logfile
  if [ -z "$logfile" ]; return; end
  echo $str >> $logfile
end

# Wrapper functions that print a line to the screen, and optionally print it to the log:

function print_alert_top_section \
  --argument-names c1 _tl _t top_w _tr normal _l alert_title atime _r padding logfile
  set line (_print_alert_top_section $c1 $_tl $_t $top_w $_tr $normal $_l $alert_title $atime $_r)
  _print_alert_line $line[1] $logfile $padding
  _print_alert_line $line[2] $logfile $padding
end

function print_alert_fn \
  --argument-names show_fn fn_w c1 alert_fn normal padding logfile
  if [ $show_fn -ne 1 ]; return; end
  _print_alert_line (_print_alert_fn $fn_w $c1 $alert_fn $normal) $logfile $padding
end

function print_alert_body \
  --argument-names line_w c1 _l c2 line _r normal padding logfile
  _print_alert_line (_print_alert_body $line_w $c1 $_l $c2 $line $_r $normal) $logfile $padding
end

function print_alert_link \
  --argument-names link_w c1 _l c3 link _r normal padding logfile
  _print_alert_line (_print_alert_link $link_w $c1 $_l $c3 $link $_r $normal) $logfile $padding
end

function print_alert_bottom_section \
  --argument-names c1 _bl _b top_w _br normal padding logfile
  _print_alert_line (_print_alert_bottom_section $c1 $_bl $_b $top_w $_br $normal) $logfile $padding
end

function print_alert_padding \
  --argument-names show_fn padding logfile
  if [ $show_fn -ne 1 ]; return; end
  _print_alert_line (_print_alert_padding) $logfile $padding
end

function print_alert_log_header \
  --argument-names alert_fn padding logfile
  # Print only to the log, not to the screen.
  _print_alert_line_log (_print_alert_log_header $alert_fn) $logfile $padding
end

# Render functions that output lines to the screen:

function _print_alert_body \
  --argument-names line_w c1 _l c2 line _r normal
  printf "%s%s%s%-"$line_w"s%s%s%s\n" $c1 $_l $c2 $line $c1 $_r $normal
end

function _print_alert_fn \
  --argument-names fn_w c1 alert_fn normal
  printf "%"$fn_w"s" "$c1$alert_fn$normal"\n
end

function _print_alert_top_section \
  --argument-names c1 _tl _t top_w _tr normal _l alert_title atime _r
  echo "$c1""$_tl"(seq -f '' -s$_t $top_w)"$_tr""$normal"
  echo "$c1""$_l""$alert_title""$atime""$_r""$normal"
end

function _print_alert_link \
  --argument-names link_w c1 _l c3 link _r normal
  printf "%s%s%s%-"$link_w"s%s%s%s\n" $c1 $_l $c3 $link $c1 $_r $normal
end

function _print_alert_bottom_section \
  --argument-names c1 _bl _b top_w _br normal
  echo "$c1""$_bl"(seq -f '' -s$_b $top_w)"$_br""$normal"
end

function _print_alert_padding
  echo
end

function _print_alert_log_header \
  --argument-names alert_fn
  echo "["(date -u +"%Y-%m-%dT%H:%M:%SZ")"]" $alert_fn
end
