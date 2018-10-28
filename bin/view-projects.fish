#!/usr/bin/env fish

set home "/Users/"(whoami)
set orig (pwd)
set cols (tput cols)
# Subtract the width for the day, the author name, and the rel. time.
set daylen 10
set namelen 16
set rellen 15
set desclen (math $cols - $daylen - $namelen - $rellen - 1)

# Lists project directory names. Projects are stored in
# two directories: ~/Projects/ and ~/Client projects/; with
# the only exception being the Syft directory: ~/Projects/syft/.
# Projects are listed with their entire path.
function __get_project_names --description 'Retrieve all project directory names'
  ls -d "$home/Projects/"*/
  ls -d "$home/Client projects/"*/
  ls -d "$home/Projects/syft/"*/
end

# Lists commits from a given project. Commits are counted as "today"
# if they were made after 5 AM (midnight commits count for the previous day).
function __get_commits --description 'Returns commits from today'
  git log --since="last monday" --pretty="format:%cd|%ar|%cn|%s" -n 5 --date=format:'%A'
end

# Get list of project directory names.
set projs (__get_project_names)

echo
echo "Projects with recent commits on "(set_color red)$hostname(set_color normal)

# Temporarily turn off the dirprev hook that runs when changing directories.
set -x NO_DIRPREV_HOOK 1
for proj in $projs
  # Skip all items that aren't actually Git repos.
  if not test -f $proj"/.git/index"
    continue
  end
  
  set name (basename $proj)
  set pkgfile $proj"/package.json"
  if test -e $pkgfile
    set pkgdesc (cat $pkgfile | grep "description\":" | awk '{ $1 = ""; gsub("^ *\"|\" *,?$", ""); print $0 }')
  else
    set pkgdesc 0
  end
  cd $proj
  set commits (__get_commits)
  
  # Skip if there are no commits.
  if test -z "$commits"
    continue
  end
  
  echo
  echo -n (set_color yellow)$name(set_color normal)
  if test -n "$pkgdesc"
    set pkgdesclen (math $cols - (string length $name) - 4)
    set pkgdescout (string sub -s 1 -l $pkgdesclen $pkgdesc)
    if test (string length $pkgdesc) -ge $pkgdesclen
      set pkgdescout $pkgdescout"…"
    end
    printf (set_color yellow)" - "(set_color cyan)"%-"$pkgdesclen"s"(set_color normal) $pkgdescout
  end
  echo
  for c in $commits
    set day (echo $c | cut -d'|' -f1)
    set rel (echo $c | cut -d'|' -f2)
    set name (echo $c | cut -d'|' -f3)
    set desc (echo $c | cut -d'|' -f4)
    set desclimit (string sub -s 1 -l $desclen $desc)
    
    # Add an ellipsis if the description is longer than permitted.
    if test (string length $desc) -gt $desclen
      set desclimit (string sub -s 1 -l (math $desclen - 1) $desclimit)"…"
    end
    
    if [ "$name" = "$prevname" ]
      set displayname (echo '~')
    else
      if test (string length $name) -ge $namelen
        set displayname (string sub -s 1 -l (math $namelen - 2) $name)"…"
      else
        set displayname (string sub -s 1 -l (math $namelen - 1) $name)
      end
    end
    set rel "21 minutes ago"
    printf (set_color green)'%-'$daylen's'(set_color normal)'%-'$desclen's '(set_color blue)'%-'$namelen's'(set_color purple)'%-'$rellen's\n' $day $desclimit $displayname $rel
    set prevname (echo $name)
  end
  set prevname 0
end
echo
cd $orig
set -x NO_DIRPREV_HOOK 0

