# Dada Shell Theme © 2019

# Alerts directory and the archive.
set -g alerts_dir $home"/.cache/dada/alerts"
set -g alerts_read_dir $alerts_dir"/read"
set -g alerts_archive_dir $alerts_dir"/archive"

# Standard width to display alerts at.
set -g alerts_width "92"

# Each line needs a slightly different width due to the escape sequences.
set atime_w (math $alerts_width + 14)
set top_w (math $alerts_width - 2)
set line_w (math $alerts_width - 4)
set link_w (math $alerts_width + 7)
set fold_w (math $alerts_width - 4)

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
  --argument-names slug name level link content \
  --description "Creates a new alert"
  _make_alert_in_dir $slug $name $level $link $content $alerts_dir
end

function print_alert \
  --argument-names filepath \
  --description "Prints the contents of an alert"
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
  set atime "$c1""$alert_ts"(set_color normal)

  echo "$c1""$_tl"(seq -f '' -s$_t $top_w)"$_tr""$normal"
  printf "%"$atime_w"s%s%s%s\n" $atime $c1 $_r $normal
  echo -en "\033[1A"
  printf "%s%s%s\n" $c1 $_l $title
  if not [ $skip_first -eq 1 ]
    for line in $content
      printf "%s%s%s%-"$line_w"s%s%s%s\n" $c1 $_l $c2 $line $c1 $_r $normal
    end
  end
  # Print the link, unless we don't have one.
  if [ $link != "-" ]
    set link "$link"(set_color normal)
    printf "%s%s%s%-"$link_w"s%s%s%s\n" $c1 $_l $c3 $link $c1 $_r $normal
  end
  echo "$c1""$_bl"(seq -f '' -s$_b $top_w)"$_br""$normal"
end

function archive_alert \
  --argument-names filepath \
  --description "Moves an alert into the archive directory"
  mv $filepath $alerts_archive_dir
end
