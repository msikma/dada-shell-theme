function gc
  set c2 (set_color purple)
  set c1 (set_color white)
  draw_columns $c2"gb$c1              Shows last commits per branch"\
               $c2"gits/g$c1          Git status"\
               $c2"gl$c1              Git log with merge lines"\
               $c2"gr$c1              Prints the repo remote URL"\
               $c2"gsl$c1             Git short log (one liners)"\
               $c2"gd$c1              Runs 'git diff --cached'"\
               $c2"git summary$c1     Summary of repo and authors"
end
alias gb="git for-each-ref --count=25 --sort=-committerdate refs/heads/ --format='%(HEAD) %(color:yellow)%(refname:short)%(color:reset) - %(color:red)%(objectname:short)%(color:reset) - %(contents:subject) - %(authorname) (%(color:green)%(committerdate:relative)%(color:reset))'"
alias gits="git status"
alias g="git status"
alias gd="git diff --cached"
alias gl="git log --pretty --oneline --graph"
alias gsl="git log --oneline --decorate --color | head"
alias gr="git remote get-url --all origin"