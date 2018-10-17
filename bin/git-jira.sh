#!/usr/bin/env bash

# This script displays the last 25 "issue branches" in order of last commit.
# An issue branch is a Git branch in the following format: bugfix/CMS2-123-fix-something,
# task/CMS2-234-new-feature, hotfix/CMS2-345-fix-crash, etc.
#
# These branches are displayed in a nice format with link to the Jira issue.
# Non issue branches (develop, master, etc.) are not displayed.
#
# Each issue branch line has the following format:
#
#        bugfix CMS2-853 food-safety    Check if the shift data is already loaded first  Michiel Sikma  2 weeks ago
#          task CMS2-745 overpayments   Implement overpayments CSV API                   Michiel Sikma  3 months ago
#             |        |          |     |                                                |              |
# 8 cols------+        |          |     |                                                |              |
# 8/9 cols-------------+          |     |                                                |              |
# 15 cols-------------------------+     |                                                |              |
# latest commit (var. width)------------+                                                |              |
# committer name, 16 cols----------------------------------------------------------------+              |
# latest commit rel. time, 14 cols----------------------------------------------------------------------+
#
# All fixed width items add up to 62 cols.
#
# Our Git command returns lines in the following format:
#
# bugfix/CMS2-853-food-safety|Check if the shift data is already loaded first|Michiel Sikma|6 days ago
# task/CMS2-745-overpayments|Implement overpayments CSV API|Michiel Sikma|3 weeks ago

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
YELLOW_BOLD='\033[1;33m'
BLUE='\033[0;34m'
BLUE_UNDERLINE='\033[4;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
CYAN_UNDERLINE='\033[4;36m'
NORMAL='\033[0m'

# Each issue type's color. Non issue lines don't have a color.
TYPE_TASK=$BLUE
TYPE_BUGFIX=$RED
TYPE_STORY=$GREEN
TYPE_EPIC=$PURPLE
TYPE_HOTFIX=$CYAN

# Width (number of cols) of the terminal window, and width minus fixed width items.
COLS=$(tput cols)
MSG_COLS=$((COLS-64))
HEADER_COLS=$((COLS-77))

JIRA_BASE="https://syftapp.atlassian.net/browse/"

# Print a header describing what each column means.
echo -ne "    ${CYAN_UNDERLINE}Type${NORMAL} ${CYAN_UNDERLINE}Issue${NORMAL}    ${CYAN_UNDERLINE}Name${NORMAL}          ${CYAN_UNDERLINE}Latest commit${NORMAL} "
printf "%${HEADER_COLS}s" " "
echo -ne "${CYAN_UNDERLINE}Committer${NORMAL}       ${CYAN_UNDERLINE}Time${NORMAL}"
echo

# Retrieve the raw information using Git.
# These lines get processed one by one and split by the '|' character.
git for-each-ref \
  --sort=-committerdate refs/heads/ \
  --count=25 \
  --format='%(refname:short)|%(contents:subject)|%(authorname)|%(committerdate:relative)' \
  | while IFS= read -r line; do
  IFS='|' read -ra ADDR <<< "$line"
  
  n=0
  for item in "${ADDR[@]}"; do
  
    # Issue information
    if [ "$n" -eq "0" ]; then
      type=$(echo $item | cut -f1 -d/) # 'task', 'bugfix', etc., or branch name if it isn't an issue branch.
      code=$(echo $item | cut -f2 -d/) # e.g. 'CMS2-123-fix-something', or branch name.
      
      # Don't print non-issue branches, which will have the same for $type and $code.
      [ "$type" = "$code" ] && continue
      
      # 'bugfix' is sometimes written as 'bug' or 'fix'.
      [[ $type =~ ^(bug|fix)$ ]] && type='bugfix'
      
      project=$(echo $code | cut -f1 -d-) # CMS2
      number=$(echo $code | cut -f2 -d-)  # 123
      rest=$(echo $code | cut -f3- -d-)   # fix-something
      
      # Used for setting the correct color. 'bug' and 'fix' are changed to 'bugfix'.
      # Indirection is used to grab the color variable.
      typevar=$(echo "$type" | tr [:lower:] [:upper:])
      color="TYPE_$typevar"
      color="${!color}"
      
      # Since $project and $number can technically be longer than other lines,
      # we need to limit this whole section to 32 characters. Plus extra bytes for the color codes.
      line=`printf "$color%8s ${YELLOW_BOLD}%s-%s ${NORMAL}%-15s" $type $project $number $rest`
      printf "%s${NORMAL}" "${line:0:50}" # column width plus color codes
    fi
    
    # Latest commit message
    if [ "$n" -eq "1" ]; then
      printf "%-${MSG_COLS}s " "${item:0:$MSG_COLS}"
    fi
    
    # Latest committer name
    if [ "$n" -eq "2" ]; then
      printf "${BLUE}%-16s" "$item"
    fi
    
    # Latest commit relative timestamp
    if [ "$n" -eq "3" ]; then
      printf "${PURPLE}%-14s\n" "$item"
    fi
    n=$((n+1))
  done
done
