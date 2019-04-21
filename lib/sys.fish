# Dada Shell Theme © 2019

# Prints the OSX version, like "10.13.6"
function get_osx_version --description "Prints OSX version string"
  defaults read loginwindow SystemVersionStampAsString
end

# Prints a shortened Darwin version string, without the build date.
# E.g. "Darwin Kernel Version 17.7.0; root:xnu-4570.71.35~1/RELEASE_X86_64"
function get_darwin_version --description "Prints Darwin kernel version"
  uname -v | sed -e 's/:.*;/;/g'
end

# Prints the current local IP, e.g. "10.0.1.5"
function get_curr_ip --description "Prints current local IP"
  ifconfig | grep inet | grep broadcast | cut -d' ' -f 2 | head -n 1
end
