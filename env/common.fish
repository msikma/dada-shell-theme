# Dada Shell Theme © 2019, 2020

set IS_DADA_SERVER (if test -e ~/".dada-server"; echo "1"; end)

# Various systems/languages
set PATH ~/.cargo/bin $PATH            # Rust
set PATH ./node_modules/.bin $PATH     # Local Node bins

# Dada theme scripts (e.g. those referenced in aliases.fish)
set PATH ~/.config/dada/bin $PATH      # for larger scripts, with extension
set PATH ~/.config/dada/scripts $PATH  # for smaller scripts/commands

set -gx LESS_TERMCAP_md (printf "\e[01;31m")
set -gx LESS_TERMCAP_me (printf "\e[0m")
set -gx LESS_TERMCAP_se (printf "\e[0m")
set -gx LESS_TERMCAP_so (printf "\e[01;44;33m")
set -gx LESS_TERMCAP_ue (printf "\e[0m")
set -gx LESS_TERMCAP_us (printf "\e[01;32m")

set -x EDITOR nano
set -x GIT_EDITOR nano
set -x LC_ALL en_US.UTF-8

# Enable GNU Privacy Guard.
set -gx GPG_TTY (tty)

# Include machine-specific env settings if any.
if [ -e ~/".config/env.fish" ]
  source ~/".config/env.fish"
end
