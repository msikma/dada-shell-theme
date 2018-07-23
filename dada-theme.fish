function fish_greeting
  set_color brblack
  echo (uname -n)  (uname -srmp)
  uptime
  set_color normal
end

function faster_vcs
  # Speed up non-Git folders a bit
  if not test -d ./.git; and not test -d ../.git
    return
  end
  __fish_vcs_prompt
end

set -g __fish_git_prompt_showdirtystate 1
set -g __fish_git_prompt_showstashstate 1
set -g __fish_git_prompt_showuntrackedfiles 1
set -g __fish_git_prompt_describe_style 'branch'
#set -g __fish_git_prompt_showcolorhints 1
set -g __fish_git_prompt_show_informative_status 1

# Copied from one of the default prompts and edited a bit.
function fish_prompt --description 'Write out the prompt'
  if not set -q __fish_prompt_normal
    set -g __fish_prompt_normal (set_color normal)
  end

  if not set -q __fish_prompt_cwd
    set -g __fish_prompt_cwd (set_color $fish_color_cwd)
  end

  echo -n -s "$__fish_prompt_cwd" (prompt_pwd) (faster_vcs) "$__fish_prompt_normal" '> '
end
