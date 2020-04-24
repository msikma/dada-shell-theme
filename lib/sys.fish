# Dada Shell Theme © 2019, 2020

# Prints the OSX version, like "10.13.6"
function get_osx_version --description "Prints OSX version string"
  defaults read loginwindow SystemVersionStampAsString
end

# Prints the system name and version, e.g. "OSX 10.13.6" or "Ubuntu 19.04"
function get_system_version
  if [ (command -v defaults) ]
    echo "OSX "(get_osx_version)
  else
    lsb_release -d | cut -d":" -f2 | xargs
  end
end

# Prints a shortened Darwin uname string. In case of Darwin, this hides the build date.
# E.g. "Darwin Kernel Version 17.7.0; root:xnu-4570.71.35~1/RELEASE_X86_64"
function get_short_uname --description "Prints Darwin kernel version"
  uname -v | sed -e 's/:.*;/;/g'
end

# Prints the current local IP, e.g. "10.0.1.5"
function get_curr_ip --description "Prints current local IP"
  if [ (command -v ifconfig) ]
    ifconfig | grep inet | grep broadcast | cut -d' ' -f 2 | head -n 1
  else
    hostname -I | xargs
  end
end
