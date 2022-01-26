#!/usr/bin/env fish

# Welcome message for new logins to a server.

serverinfo

echo "   Other information:"
echo ""

# Print the 'reboot required' message if it exists.
if [ -e /var/run/reboot-required ]
  echo (set_color red)(cat /var/run/reboot-required)(set_color normal)
end

# Show any updates that are available.
if [ -e /var/lib/update-notifier/updates-available ]
  cat /var/lib/update-notifier/updates-available
end

# Display screen sessions, if any.
if type -q screen
  screen -ls
end
