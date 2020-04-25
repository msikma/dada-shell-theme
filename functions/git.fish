# Dada Shell Theme © 2019, 2020

set cmd_git \
  "ghelp"             "Displays all Git commands" \
  "g"                 "Git status" \
  "gb"                "Shows last Git commits per branch" \
  "gd"                "Runs 'git diff --cached'" \
  "gl"                "Git log with merge lines" \
  "glb"               "Shows list of local-only branches" \
  "glist"             "One-line Git log with merge lines" \
  "glog"              "Git log with extra information" \
  "gr"                "Shows the repo's current remotes" \
  "gclone <dir>"      "Prints a clone command for a repo" \
  "gru"               "Shows the repo remote origin URL" \
  "gsl"               "Git short log (one liners)" \

set cmd_git_scripts \
  "git summary"       "Summary of repo and authors" \
  "jira"              "Lists Jira issue branches" \
  "open_repo"         "Opens the repo's homepage" \

function ghelp \
  --description "Prints all available Git commands"
  # Merge all various command lists together and add colors.
  # See <lib/help.fish>.
  set -l _cmd_all
  set -a _cmd_all (_add_cmd_colors (set_color purple) $cmd_git)
  set -a _cmd_all (_add_cmd_colors (set_color yellow) $cmd_git_scripts)

  echo
  echo "The following Git commands are available:"
  echo

  _iterate_help $_cmd_all

  echo
end

function gitfirst \
  --description 'Returns the Git log for the first ever commit'
  set hash (git rev-list --max-parents=0 HEAD)
  git log $hash
end

function glb \
  --description "Shows list of local-only branches"
  git branch -vv | cut -c 3- | awk '$3 !~/\[/ { print $1 }'
end

function open_repo \
  --description "Opens up the main repository link in the browser"
  # Note: only supports Node package.json at the moment.
  set node_url (node -e "const a = require('./package.json'); a.homepage && console.log(a.homepage);" 2> /dev/null)
  set repo_url $node_url
  if [ -n "$repo_url" ]
    echo (set_color yellow)'Opening repo URL/homepage: '(set_color reset)(set_color -u)"$repo_url"
    open "$repo_url"
  else
    echo 'open_repo: could not find repository URL.'
    return 1
  end
end

function gclone \
  --description "Prints a git clone command for a given repo" \
  --argument-names dir
  if [ -z "$dir" ]
    set dir '.'
  end
  set path (realpath "$dir")
  set git (git --git-dir="$path/.git" remote -v | grep "fetch" | string sub -s 8 | cut -d ' ' -f1)
  echo "git clone $git"
end

alias gith="ghelp" # legacy alias
alias g="git status"
alias gb="git for-each-ref --count=25 --sort=-committerdate refs/heads/ --format='%(HEAD) %(color:yellow)%(refname:short)%(color:reset) - %(color:red)%(objectname:short)%(color:reset) - %(contents:subject) - %(authorname) (%(color:green)%(committerdate:relative)%(color:reset))'"
alias gd="git diff --cached"
alias gl="git log --name-status --graph"
alias glist="git log --pretty --oneline --graph"
alias gr="git remote -v"
alias gru="git remote get-url --all origin"
alias gsl="git log --oneline --decorate --color | head"
alias glog='git log --graph --abbrev-commit --decorate --all --format=format:"%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(red) - %an%C(reset) %C(bold green)(%ar)%C(reset)%C(bold yellow)%d%C(reset)%n %C(white)%s%C(reset)"'
