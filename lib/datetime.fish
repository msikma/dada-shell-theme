# Dada Shell Theme © 2019

# Duration of various time units in seconds
set -g year_l 31536000
set -g month_l 2628000
set -g week_l 604800
set -g day_l 86400
set -g hour_l 3600
set -g minute_l 60

# Used for the timer
set -g a_secs
set -g a_ms

function timer_start --description "Saves the current time in ms to compare later"
  set a_secs (gdate +%s)
  set a_ms (gdate +%N)
end

function timer_end --description "Prints the difference between timer_start and now"
  set b_secs (gdate +%s)
  set b_ms (gdate +%N)

  awk "BEGIN{ print $b_secs.00$b_ms - $a_secs.00$a_ms; }"
end

function duration_humanized \
  --argument-names sec \
  --description 'Prints out a humanized duration of a time in seconds'
  _time_unit $sec
end

# Prints out a nice, human-readable time for a given timestamp.
function format_full_timestamp \
  --argument-names ts \
  --description "Returns a complete timestamp that can be displayed verbatim"
  set now (gdate +"%s")
  set abs (format_full_timestamp_abs $ts)

  # If our date is within two days, we would like to specifically display
  # the amount of hours ago it was; rather than the regular time_ago function.
  # This is to avoid situations like "Yesterday (1 day ago)".
  set is_today (_is_today $ts)
  set is_yday (_is_yesterday $ts)
  if [ $is_today -eq 1 -o $is_yday -eq 1 ]
    set rel (hours_ago $now $ts)
  else
    set rel (time_ago $now $ts)
  end
  echo "$abs ($rel)"
end

# Formats the absolute part of the abs+rel timestamp.
function format_full_timestamp_abs \
  --argument-names ts \
  --description "Returns the absolute part of a full human-readable date"
  set is_today (_is_today $ts)
  set is_yday (_is_yesterday $ts)
  set is_tw (_is_this_week $ts)
  set is_lw (_is_last_week $ts)
  _format_date_abs $ts $is_today $is_yday $is_tw $is_lw
end

# Calculates the relative difference between two Unix times.
# The difference is returned in a human-readable format,
# e.g. '5 years ago', '2 days ago', '20 minutes ago'.
function time_ago \
  --argument-names date1 date2 \
  --description 'Formats the relative difference between two dates'
  set diff (math "$date1 - $date2")
  set unit (_time_unit $diff)
  echo "$unit ago"
end

# Special version of _time_unit that only displays hours.
# Meant to be used when displaying relative time for a date that is
# known to be within one or two days (up to 48 hours).
function hours_ago \
  --argument-names now ts \
  --description "Prints the amount of hours ago the time stamp was"
  set diff (math "$now - $ts")
  set hours (math "floor($diff / $hour_l)")
  set unit (_time_unit_echo $hours "hour" "hours")
  echo "$unit ago"
end

# Formatting function for absolute times.
function _format_date_abs \
  --argument-names ts is_today is_yday is_tw is_lw \
  --description "Returns a formatted date for a timestamp"
  if [ $is_today -eq 1 ]
    gdate -d "@$ts" +"%H:%m"
    return
  end
  if [ $is_yday -eq 1 ]
    gdate -d "@$ts" +"Yesterday at %H:%m"
    return
  end
  if [ $is_tw -eq 1 ]
    gdate -d "@$ts" +"Last %A at %H:%m"
    return
  end
  if [ $is_lw -eq 1 ]
    gdate -d "@$ts" +"Last week %A at %H:%m"
    return
  end
  # If it's longer ago than two weeks:
  gdate -d "@$ts" +"%Y-%m-%d %H:%m"
end

function _get_week_start_unix_time \
  --argument-names offset \
  --description "Prints the Unix time of the start of a week"
  # We'll calculate last week's first day by first getting the first Monday of the year,
  # and then adding (current week number - 1) to that.

  # First we need to know what date was the first Monday of the year,
  # or the last Monday of last year if week 1 overlaps with it.
  # 'first_day' is set to the weekday of Jan 1 as 1..7.
  # E.g. if it Jan 1 was on a Tuesday, it will be 2.
  set first_day (gdate -d (date +%Y)"-01-01" +"%u")

  # Now get the first Monday's date by subtracting days from Jan 1.
  set first_monday (gdate -d (date +%Y)"-01-01 -"(math $first_day - 1)" days" +"%Y-%m-%d")

  # Get current week number; it's 0-indexed, meaning week 32 will be 31.
  set week (math (gdate +"%W") - $offset)

  # Finally, add the appropriate amount of weeks.
  gdate -d "$first_monday +$week weeks" +"%s"
end

function _is_this_week \
  --argument-names ts \
  --description "Prints 1 if a given timestamp is within this week, 0 otherwise"
  set start (_get_week_start_unix_time "0")
  if [ $ts -lt $start ]; echo "0"; else; echo "1"; end
end

function _is_last_week \
  --argument-names ts \
  --description "Prints 1 if a given timestamp is within last week, 0 otherwise"
  set start (_get_week_start_unix_time "1")
  if [ $ts -lt $start ]; echo "0"; else; echo "1"; end
end

function _is_today \
  --argument-names ts \
  --description "Prints 1 if a given timestamp is today, or 0 if it's earlier or later"
  set then (gdate -d "@$ts" +"%Y-%m-%d")
  set now (gdate +"%Y-%m-%d")
  if [ "$then" = "$now" ]; echo "1"; else; echo "0"; end
end

function _is_yesterday \
  --argument-names ts \
  --description "Prints 1 if a given timestamp was yesterday, or 0 if it's earlier or later"
  set then (gdate -d "@$ts" +"%Y-%m-%d")
  set yday (gdate -d "-1 day" +"%Y-%m-%d")
  if [ "$then" = "$yday" ]; echo "1"; else; echo "0"; end
end

# Converts seconds to a higher time unit.
# E.g. 60 seconds -> 1 minute
function _time_unit \
  --argument-names sec \
  --description "Converts seconds to a higher time unit"
  set years (math "floor($sec / $year_l)")
  if [ $years -gt 0 ]
    _time_unit_echo $years "year" "years"
    return
  end
  set months (math "floor($sec / $month_l)")
  if [ $months -gt 0 ]
    _time_unit_echo $months "month" "months"
    return
  end
  set weeks (math "floor($sec / $week_l)")
  if [ $weeks -gt 0 ]
    _time_unit_echo $weeks "week" "weeks"
    return
  end
  set days (math "floor($sec / $day_l)")
  if [ $days -gt 0 ]
    _time_unit_echo $days "day" "days"
    return
  end
  set hours (math "floor($sec / $hour_l)")
  if [ $hours -gt 0 ]
    _time_unit_echo $hours "hour" "hours"
    return
  end
  set minutes (math "floor($sec / $minute_l)")
  if [ $minutes -gt 0 ]
    _time_unit_echo $minutes "minute" "minutes"
    return
  end
  set ms (math "floor($sec * 1000)")
  if [ $ms -lt 1000 ]
    if [ $ms -lt 1 ]
      echo -n ">"
      _time_unit_echo "1" "ms" "ms"
    else
      _time_unit_echo $ms "ms" "ms"
    end
    return
  end
  
  _time_unit_echo $sec "second" "seconds"
end


# Prints out a single time unit, either using the singular or the plural word.
function _time_unit_echo \
  --argument-names value singular plural \
  --description "Prints a time unit in singular or plural"
  echo -n $value
  if [ "$value" -eq 1 ]
    echo -n " $singular"
  else
    echo -n " $plural"
  end
end
