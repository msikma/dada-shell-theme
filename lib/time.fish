# Dada Shell Theme © 2019-2022

# Takes in Apache uptime formatted strings:
#
#   "2 days 3 hours 17 minutes 4 seconds"   -> "2 days 3:17:04"
#   "14 hours 17 minutes 4 seconds"         -> "14:17:04"
#   "22 days 15 hours 2 minutes 14 seconds" -> "22 days 15:02:14"
#   "22 days 6 minutes 14 seconds"          -> "22 days 0:06:14"
#   "4 seconds"                             -> "4 seconds"
#   "6 minutes 4 seconds"                   -> "0:06:04"
#   "1 hour 0 minutes 4 seconds"            -> "1:00:04"
#   "1 hour 4 seconds"                      -> "1:00:04"
#   ""                                      -> "(unknown)"
#   "1 days"                                -> "1 day 0 seconds"
# 
# Designed to be human readable.
function format_apache_timestr \
  --argument-names t \
  --description "Formats Apache uptime strings to shorter format"
  set days (echo "$t" | grep -io "[0-9]* day" | cut -d' ' -f1)
  set hours (echo "$t" | grep -io "[0-9]* hour" | cut -d' ' -f1)
  set minutes (echo "$t" | grep -io "[0-9]* minute" | cut -d' ' -f1)
  set seconds (echo "$t" | grep -io "[0-9]* second" | cut -d' ' -f1)
  set omit_days "0"

  if [ -n "$days" -a "$days" -gt 1 ]
    set days_plural "s"
  else
    set days_plural ""
  end
  if [ -z "$minutes" -a -n "$hours" ]
    set minutes "0"
  end
  if [ -z "$hours" -a -n "$minutes" ]
    set hours "0"
  end
  if [ -n "$minutes" ]
    set minutes (printf ":%02d" "$minutes")
    set seconds (printf "%02d" "$seconds")
    set seconds (printf ":%s" "$seconds")
  end
  if [ -z "$days" -a -z "$hours" -a -z "$minutes" -a -z "$seconds" ]
    printf "(unknown)"
    return
  end
  if [ -z "$seconds" ]
    set seconds "0"
  end
  if [ -z "$hours" -a -z "$minutes" ]
    set seconds (printf "%s seconds" "$seconds")
  end

  if [ -n "$days" ]
    set days_str (printf "%s day%s " "$days" "$days_plural")
  end

  printf "%s%s%s%s" "$days_str" "$hours" "$minutes" "$seconds"
end
