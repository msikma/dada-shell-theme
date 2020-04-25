#!/usr/bin/env fish

# Welcome message for new logins to a server.

serverinfo

if test -e /var/lib/update-notifier/updates-available
  cat /var/lib/update-notifier/updates-available
end

# Display screen sessions, if any.
if type -q screen
  screen -ls
end
