#!/usr/bin/env fish

set orig (pwd)
set home "/Users/"(whoami)

# See view-projects.fish.
function __get_project_names --description 'Retrieve all project directory names'
  ls -d "$home/Projects/"*/
  ls -d "$home/Client projects/"*/
  ls -d "$home/Projects/syft/"*/
end

set projs (__get_project_names)
set projamount (count $projs)

echo
echo "Updating $projamount projects"
echo

# Temporarily turn off the dirprev hook that runs when changing directories.
set -x NO_DIRPREV_HOOK 1
for proj in $projs
  if not test -f $proj"/.git/index"
    continue
  end
  
  set name (basename $proj)
  cd $proj
  
  # Determine current state of the repo.
  set old_count (git rev-list head --count)
  set old_hash (git rev-parse --short head)
  set branch (git describe --all | sed s@heads/@@)
  
  # Pull and capture all output.
  set output (git pull ^&1)
  
  # How many commits did we add since pulling?
  set new_count (git rev-list head --count)
  
  set msg ""
  switch "$output"
  case "Already up to date."
    set msg (set_color yellow)" is already up to date (commit #$old_count, $old_hash)."
  case "fatal: No remote repository specified.*"
    set msg (set_color cyan)" - "(set_color red)"fatal: No remote repository specified."
  case "fatal:*"
    set msg (set_color cyan)" - "(set_color red)"$output"
  case "*->*"
    set new_hash (git rev-parse --short head)
    set commits (math $new_count - $old_count)
    set commits_sfx "commits"
    if [ "$commits" -eq 1 ]
      set commits_sfx "commit"
    end
    set msg (set_color green)" has been updated (+$commits $commits_sfx; commit #$new_count, $new_hash)."
  end
  
  echo (set_color cyan)"$name$msg"(set_color normal)
end
echo
cd $orig
set -x NO_DIRPREV_HOOK 0
