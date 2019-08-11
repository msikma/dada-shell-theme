# Dada Shell Theme © 2019

# Alerts directory and the archive.
set -g alerts_dir $home"/.cache/dada/alerts"
set -g alerts_read_dir $alerts_dir"/read"
set -g alerts_archive_dir $alerts_dir"/archive"

# Standard width to display alerts at.
set -g alerts_width "92"

function find_new_alerts \
  --description "Returns a list of new alert files to display"
  _find_new_alerts_in_dir $alerts_dir
end

function make_alert \
  --argument-names slug name level content \
  --description "Creates a new alert"
  _make_alert_in_dir $slug $name $level $content $alerts_dir
end

function print_alert \
  --argument-names filepath \
  --description "Prints the contents of an alert"
  set lines (cat $filepath)
  set name $lines[1]
  set level $lines[2]
  set content $lines[3..(count $lines)]
  set skip_first 0

  if [ "$level" = "warning" ];      set color1 (set_color yellow); set color2 (set_color bryellow); set linetype "single"; end
  if [ "$level" = "success" ];      set color1 (set_color green);  set color2 (set_color brgreen);  set linetype "single"; end
  if [ "$level" = "error" ];        set color1 (set_color red);    set color2 (set_color brred);    set linetype "single"; end
  if [ "$level" = "error_double" ]; set color1 (set_color red);    set color2 (set_color brred);    set linetype "double"; end

  if [ "$linetype" = "single" ]
    set _tl $_alerts_tl
    set _t $_alerts_t
    set _tr $_alerts_tr
    set _l $_alerts_l
    set _r $_alerts_r
    set _bl $_alerts_bl
    set _b $_alerts_b
    set _br $_alerts_br
  end
  if [ "$linetype" = "double_h" ]
    set _tl $_alerts_dh_tl
    set _t $_alerts_dh_t
    set _tr $_alerts_dh_tr
    set _l $_alerts_dh_l
    set _r $_alerts_dh_r
    set _bl $_alerts_dh_bl
    set _b $_alerts_dh_b
    set _br $_alerts_dh_br
  end
  if [ "$linetype" = "double" ]
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

  # Time display needs extra width to compensate for the escape sequences.
  set atime_w (math $alerts_width + 14)
  set top_w (math $alerts_width - 2)
  set line_w (math $alerts_width - 4)

  # If the 'name' variable is '-' (just a dash), we won't print a title.
  # Instead we'll print the first line of the message.
  if [ $name = "-" ]
    set title $content[1]
    set content $content[2..(count $content)]
    # If this leaves only a single line...
    if [ $title = $content[1] ]
      set skip_first 1
    end
  else
    set title (set_color blue)"Alert from "(set_color magenta)$name
  end
  set atime "$color1""$alert_ts"(set_color normal)

  echo "$color1""$_tl"(seq -f '' -s$_t $top_w)"$_tr""$normal"
  printf "%"$atime_w"s%s%s%s\n" $atime $color1 $_r $normal
  echo -en "\033[1A"
  printf "%s%s%s\n" $color1 $_l $title
  if not [ $skip_first -eq 1 ]
    for line in $content
      printf "%s%s%s%-"$line_w"s%s%s%s\n" $color1 $_l $color2 $line $color1 $_r $normal
    end
  end
  echo "$color1""$_bl"(seq -f '' -s$_b $top_w)"$_br""$normal"
end

function archive_alert \
  --argument-names filepath \
  --description "Moves an alert into the archive directory"
  mv $filepath $alerts_archive_dir
end
