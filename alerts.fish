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

  if [ "$level" = "warning" ];      set color (set_color yellow); set linetype "single"; end
  if [ "$level" = "success" ];      set color (set_color green);  set linetype "single"; end
  if [ "$level" = "error" ];        set color (set_color red);    set linetype "single"; end
  if [ "$level" = "error_double" ]; set color (set_color red);    set linetype "double"; end

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

  set nowdate (_get_now_date)
  set tdate (_get_alert_date $filepath)
  set ttime (_get_alert_time $filepath)
  set ttime_f "$ttime[1]":"$ttime[2]":"$ttime[3]"
  set abs (_get_alert_ts_abs $filepath)
  set rel (_get_alert_ts_rel $filepath)

  # Determine what sort of timestamp to display.
  # If the alert was made today, only the relative time is necessary.
  # For alerts within seven days, we'll display the name of the day.
  # Anything from further in the past than that gets a full timestamp.
  # TODO
  set ts ""
  if [ $tdate[1] -eq $nowdate[1] -a $tdate[2] -eq $nowdate[2] -a $tdate[3] -eq $nowdate[3] ]
    # Same date:
    set ts "at "$ttime_f
  end

  # Time display needs extra width to compensate for the escape sequences.
  set atime_w (math $alerts_width + 14)
  set top_w (math $alerts_width - 2)
  set line_w (math $alerts_width - 4)

  set title (set_color blue)"Alert from "(set_color magenta)$name
  set atime "$color""$rel"" ($ts)"(set_color normal)

  echo "$color""$_tl"(seq -f '' -s$_t $top_w)"$_tr""$normal"
  printf "%"$atime_w"s%s%s%s\n" $atime $color $_r $normal
  echo -en "\033[1A"
  printf "%s%s%s\n" $color $_l $title
  for line in $content
    printf "%s%s%-"$line_w"s%s%s\n" $color $_l $line $_r $normal
  end
  echo "$color""$_bl"(seq -f '' -s$_b $top_w)"$_br""$normal"
end

function archive_alert \
  --argument-names filepath \
  --description "Moves an alert into the archive directory"
  mv $filepath $alerts_archive_dir
end
