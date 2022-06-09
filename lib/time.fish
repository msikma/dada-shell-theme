# Dada Shell Theme © 2019-2022

# Takes in Apache uptime formatted strings, such as e.g.
# "2 days 3 hours 17 minutes 4 seconds",
# "14 hours 17 minutes 4 seconds"
# and outputs them in a shorter format, such as
# "2 days 3:17:04"
# "14:17:04"
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
  if [ -n "$minutes" ]
    set minutes (printf "%02d" "$minutes")
  end
  if [ -n "$seconds" ]
    set seconds (printf "%02d" "$seconds")
  end

  if [ -n "$days" ]
    set days_str (printf "%s day%s " "$days" "$days_plural")
  end

  printf "%s%s:%s:%s" "$days_str" "$hours" "$minutes" "$seconds"
end
