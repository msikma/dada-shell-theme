function gc
  echo "gb      - shows last commits per branch"
  echo "gits    - git status"
  echo "gl      - git log with merge lines"
  echo "gsl     - git short log (one liners)"
end
alias gb="git for-each-ref --count=12 --sort=-committerdate refs/heads/ --format='%(HEAD) %(color:yellow)%(refname:short)%(color:reset) - %(color:red)%(objectname:short)%(color:reset) - %(contents:subject) - %(authorname) (%(color:green)%(committerdate:relative)%(color:reset))'"
alias gits="git status"
alias gl="git log --pretty --oneline --graph"
alias gsl="git log --oneline --decorate --color | head"
