# Dada Shell Theme © 2019, 2020

# Returns Git version (e.g. master-23 [a4fd3c]).
function get_version --description 'Returns version identifier string'
  set branch (git describe --all | sed s@heads/@@)
  set hash (git rev-parse --short HEAD)
  set commits (git rev-list HEAD --count)
  echo $branch-$commits [$hash]
end

# Returns Git version, without hash.
function get_version_short --description 'Returns version identifier string'
  set branch (git describe --all | sed s@heads/@@)
  set commits (git rev-list HEAD --count)
  echo $branch-$commits
end

# Returns only the Git hash.
function get_version_hash --description 'Returns version identifier string'
  set hash (git rev-parse --short HEAD)
  echo $hash
end

# Last commit date in short format (YYYY-mm-dd).
function get_last_commit --description 'Returns last Git commit date'
  echo (git log -n 1 --date=format:%s --pretty=format:%cd --date=short)
end

# Last commit date in relative format ('x days ago').
function get_last_commit_rel --description 'Returns last Git commit date in relative format'
  echo (git log -n 1 --pretty=format:%cd --date=relative)
end

function in_git_dir --description "Returns whether we're inside of a Git project"
  test -f ./.git/index
end

# A slightly optimized helper function for VCS.
# Displaying the VCS part of the prompt is quite slow,
# so we check to see if .git exists in the current dir or two dirs down.
# If not, we exit early. This is a decent trade-off for the extra speed
# in most cases. (Works for most regular repos and monorepos.)
function in_git_dir_or_subdir
  # Speed up non-Git folders a bit
  if not test -d ./.git; and not test -d ../.git; and not test -d ../../.git
    return
  end
  __fish_vcs_prompt
end
