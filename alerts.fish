# Dada Shell Theme © 2019

# Standard width to display alerts at.
set -g alerts_width "92"

# Each line needs a slightly different width due to the escape sequences.
set -g atime_w (math $alerts_width + 14)
set -g fn_w (math $alerts_width + 15)
set -g title_w (math $alerts_width - 4)
set -g top_w (math $alerts_width - 2)
set -g line_w (math $alerts_width - 4)
set -g link_w (math $alerts_width + 7)
set -g fold_w (math $alerts_width - 4)

# Alert colors
set warn_c1 (set_color yellow)
set warn_c2 (set_color bryellow)
set warn_c3 (set_color -u yellow)
set warn_lt "single"
set scss_c1 (set_color green)
set scss_c2 (set_color brgreen)
set scss_c3 (set_color -u green)
set scss_lt "single"
set erro_c1 (set_color red)
set erro_c2 (set_color brred)
set erro_c3 (set_color -u red)
set erro_lt "single"
set errd_c1 (set_color red)
set errd_c2 (set_color brred)
set errd_c3 (set_color -u red)
set errd_lt "double"

function find_new_alerts \
  --description "Returns a list of new alert files to display"
  _find_new_alerts_in_dir $alerts_dir
end

function make_alert \
  --argument-names slug name level link timer content \
  --description "Creates a new alert"
  _make_alert_in_dir $slug $name $level $link $timer $content $alerts_dir
end

function print_and_log_alert \
  --argument-names filepath show_fn \
  --description "Prints an alert and saves it to the log"
  if [ ! -n "$show_fn" ]; set show_fn '0'; end
  print_alert $filepath $show_fn '1'
end

function print_alert \
  --argument-names filepath show_fn add_to_log \
  --description "Prints the contents of an alert"
  set orig_filepath $filepath
  if [ ! -n "$show_fn" ]; set show_fn '0'; end
  if [ ! -n "$add_to_log" ]; set add_to_log '0'; end
  if ! test -e $filepath
    # If we can't find the file, try searching for /alerts_dir/<file>.txt first.
    set filepath "$alerts_dir""/""$filepath"".txt"
  end
  if ! test -e $filepath
    print_error 'print_alert' "could not find alert file: "(basename "$orig_filepath")
    return
  end
  set lines (cat $filepath)
  set name $lines[1]
  set level $lines[2]
  set link $lines[3]
  set content $lines[4..(count $lines)]
  set skip_first 0

  # Fallback values for the color.
  set c1 (set_color white)
  set c2 (set_color brwhite)
  set c3 (set_color -u brwhite)
  set lt "single"

  if [ "$level" = "warning" ];      set c1 $warn_c1; set c2 $warn_c2; set c3 $warn_c3; set lt $warn_lt; end
  if [ "$level" = "success" ];      set c1 $scss_c1; set c2 $scss_c2; set c3 $scss_c3; set lt $scss_lt; end
  if [ "$level" = "error" ];        set c1 $erro_c1; set c2 $erro_c2; set c3 $erro_c3; set lt $erro_lt; end
  if [ "$level" = "error_double" ]; set c1 $errd_c1; set c2 $errd_c2; set c3 $errd_c3; set lt $errd_lt; end

  if [ "$lt" = "single" ]
    set _tl $_alerts_tl
    set _t $_alerts_t
    set _tr $_alerts_tr
    set _l $_alerts_l
    set _r $_alerts_r
    set _bl $_alerts_bl
    set _b $_alerts_b
    set _br $_alerts_br
  end
  if [ "$lt" = "double_h" ]
    set _tl $_alerts_dh_tl
    set _t $_alerts_dh_t
    set _tr $_alerts_dh_tr
    set _l $_alerts_dh_l
    set _r $_alerts_dh_r
    set _bl $_alerts_dh_bl
    set _b $_alerts_dh_b
    set _br $_alerts_dh_br
  end
  if [ "$lt" = "double" ]
    set _tl $_alerts_d_tl
    set _t $_alerts_d_t
    set _tr $_alerts_d_tr
    set _l $_alerts_d_l
    set _r $_alerts_d_r
    set _bl $_alerts_d_bl
    set _b $_alerts_d_b
    set _br $_alerts_d_br
  end

  set normal (set_color normal)

  # Determine the timestamp to display. The formatting depends on how recent the alert is.
  set alert_x (_get_alert_unix_time $filepath)
  set alert_ts (format_full_timestamp $alert_x)

  # Path to the current log file.
  set logfile (alerts_log_path)

  # If the 'name' variable is '-' (just a dash), we won't print a title.
  # Instead we'll print the first line of the message.
  if [ $name = "-" ]
    set title $content[1]
    set content $content[2..(count $content)]
    # If this leaves only a single line...
    if [ $title = $content[1] ]
      set skip_first 1
    end
    # Now fold the content to the appropriate line width.
    set content (echo "$content" | fold -sw $fold_w)
  else
    set title (set_color blue)"Alert from "(set_color magenta)$name
  end
  set atime "   ""$alert_ts"

  # Print the title and the timestamp next to each other.
  # We need to calculate exactly how long the title can be, subtracting the timestamp.
  # If the title is longer than the max length, we add an ellipsis at the end.
  set atime_w (string length "$atime")
  set atitle_full (string length "$title")
  set atitle_w (math "$title_w" - "$atime_w")
  set atitle_w_culled (math "$atitle_w" - 1)

  # Pad title to max length, then crop it to max length (possibly with ellipsis).
  set title (printf "%-""$atitle_w""s" $title)
  if [ $atitle_w -lt $atitle_full ]
    set alert_title (string sub -s 1 -l "$atitle_w_culled" $title)"…"
  else
    set alert_title (string sub -s 1 -l "$atitle_w" $title)
  end

  # Removes the path and extension from the file name.
  set alert_fn (basename $filepath | strip_ext)

  print_alert_log_header $alert_fn $logfile
  print_alert_fn $show_fn $fn_w $c1 $alert_fn $normal $logfile
  print_alert_top_section $c1 $_tl $_t $top_w $_tr $normal $_l $alert_title $atime $_r $logfile
  if not [ $skip_first -eq 1 ]
    for line in $content
      print_alert_body $line_w $c1 $_l $c2 $line $_r $normal $logfile
    end
  end
  # Print the link, unless we don't have one.
  if [ $link != "-" ]
    print_alert_link $link_w $c1 $_l $c3 "$link"(set_color normal) $_r $normal $logfile
  end
  print_alert_bottom_section $c1 $_bl $_b $top_w $_br $normal $logfile
  print_alert_padding $show_fn $logfile
end

function alerts \
  --description "Prints the last alerts we've read"
  _find_read_alerts_in_dir $alerts_read_dir
end

function alert-log \
  --description "Opens the latest alerts log"
  _alerts_ensure_dir
  tail -n 100 -f (alerts_log_path)
end
