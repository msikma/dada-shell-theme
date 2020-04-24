#!/usr/bin/env fish

# Welcome message for new logins to a server.
# Displays Ubuntu system information if available.

if type -q landscape-sysinfo
  landscape-sysinfo
end

if test -e /var/lib/update-notifier/updates-available
  cat /var/lib/update-notifier/updates-available
end
