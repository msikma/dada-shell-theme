#!/usr/bin/env fish


# If the user passes -n or --no-ignore, we won't use
# the .gitignore file if this is being run inside a Git project.
[ "$argv[1]" = "-n" ]; or [ "$argv[1]" = "--no-ignore" ]
and set no_ign 1
or set no_ign 0

if in_git_dir
  if [ $no_ign -eq 0 ]
    # Use 'git ls-files' to ignore the .git directory itself and also ignored directories/files.
    echo "ftypes: not listing files ignored by .gitignore (avoid this using -n/--no-ignore)" 1>&2
  end
  git ls-files | sed 's/.*\.//'| sort | uniq -c | sort -r | grep "^ *\([0-9]\{2,\} \|[2-9]\{1\} \)"
else
  find . -type f | sed 's/.*\.//' | sort | uniq -c | sort -r | grep "^ *\([0-9]\{2,\} \|[2-9]\{1\} \)"
end
