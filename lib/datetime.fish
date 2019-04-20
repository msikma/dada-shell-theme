# Dada Shell Theme © 2019

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

# Prints out a single time value with 'ago' after it.
function time_ago_echo --description 'Prints out a time ago string'
  echo -n $argv[1]
  if [ $argv[1] -eq 1 ]
    echo -n " $argv[2]"
  else
    echo -n " $argv[3]"
  end
  echo " ago"
end

# Calculates the relative difference between two Unix times.
# The difference is returned in a human-readable format,
# e.g. '5 years ago', '2 days ago', '20 minutes ago'.
function time_ago --description 'Formats the relative difference between two dates'
  set date1 $argv[1]
  set date2 $argv[2]
  set diff (math "$date1 - $date2")

  set year_l 31536000
  set month_l 2628000
  set week_l 604800
  set day_l 86400
  set hour_l 3600
  set minute_l 60

  set years (math "floor($diff / $year_l)")
  if [ $years -gt 0 ]
    time_ago_echo $years "year" "years"
    return
  end
  set months (math "floor($diff / $month_l)")
  if [ $months -gt 0 ]
    time_ago_echo $months "month" "months"
    return
  end
  set weeks (math "floor($diff / $week_l)")
  if [ $weeks -gt 0 ]
    time_ago_echo $weeks "week" "weeks"
    return
  end
  set days (math "floor($diff / $day_l)")
  if [ $days -gt 0 ]
    time_ago_echo $days "day" "days"
    return
  end
  set hours (math "floor($diff / $hour_l)")
  if [ $hours -gt 0 ]
    time_ago_echo $hours "hour" "hours"
    return
  end
  set minutes (math "floor($diff / $minute_l)")
  if [ $minutes -gt 0 ]
    time_ago_echo $minutes "minute" "minutes"
    return
  end
  time_ago_echo $diff "second" "seconds"
end
