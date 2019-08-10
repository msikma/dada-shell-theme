# Dada Shell Theme © 2019

# Alerts directory and the archive.
set -g alerts_dir $home"/.cache/dada/alerts"
set -g alerts_archive_dir $alerts_dir"/archive"

# Standard width to display alerts at.
set -g alerts_width "92"

function find_new_alerts \
  --description "Returns a list of new alert files to display"
  _find_new_alerts_in_dir $alerts_dir
end

function make_alert \
  --argument-names name content \
  --description "Creates a new alert"
  _make_alert_in_dir $name $alerts_dir $content
end

function print_alert \
  --argument-names filepath \
  --description "Prints the contents of an alert"
  set lines (cat $filepath)
  set color (set_color red)
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

  # Title needs extra width to compensate for the escape sequences.
  set title_w (math $alerts_width + 42)
  set top_w (math $alerts_width - 2)
  set line_w (math $alerts_width - 4)

  set tl "+"
  set t "="
  set _tr "+"
  set l "| "
  set r " |"
  set bl "+"
  set b "="
  set br "+"

  set name "hello world"
  set title (set_color yellow)"New alert from "(set_color green)$name(set_color yellow)", "(set_color green)"$rel"(set_color yellow)" ("(set_color green)"$ts"(set_color yellow)")"(set_color normal)

  echo "$color""$tl"(seq -f '' -s$t $top_w)"$_tr""$normal"
  printf "%s%s%-"$title_w"s%s%s%s" $color $l $title $color $r $normal
  echo
  for line in $lines
    printf "%s%s%-"$line_w"s%s%s\n" $color $l $line $r $normal
  end
  echo "$color""$bl"(seq -f '' -s$b $top_w)"$br""$normal"
end

function archive_alert \
  --argument-names filepath \
  --description "Moves an alert into the archive directory"
  mv $filepath $alerts_archive_dir
end
