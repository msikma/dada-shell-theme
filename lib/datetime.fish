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
