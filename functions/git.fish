# Dada Shell Theme © 2019

set cmd_git \
  "gith"              "Displays all Git commands" \
  "g"                 "Git status" \
  "gl"                "Git log with merge lines" \
  "gr"                "Shows the repo's current remotes" \
  "gru"               "Shows the repo remote origin URL" \
  "gsl"               "Git short log (one liners)" \
  "gd"                "Runs 'git diff --cached'" \
  "gb"                "Shows last Git commits per branch" \
  "gs"                "Shows list of commit messages" \
  "glb"               "Shows list of local-only branches" \

set cmd_git_scripts \
  "git summary"       "Summary of repo and authors" \
  "jira"              "Lists Jira issue branches" \

function gith \
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
  set hash (git rev-list --max-parents=0 head)
  git log $hash
end

function glb \
  --description "Shows list of local-only branches"
  git branch -vv | cut -c 3- | awk '$3 !~/\[/ { print $1 }'
end

alias g="git status"
alias gb="git for-each-ref --count=25 --sort=-committerdate refs/heads/ --format='%(HEAD) %(color:yellow)%(refname:short)%(color:reset) - %(color:red)%(objectname:short)%(color:reset) - %(contents:subject) - %(authorname) (%(color:green)%(committerdate:relative)%(color:reset))'"
alias gd="git diff --cached"
alias gl="git log --pretty --oneline --graph"
alias gr="git remote -v"
alias gru="git remote get-url --all origin"
alias gs="git log --pretty=oneline --abbrev-commit"
alias gsl="git log --oneline --decorate --color | head"
