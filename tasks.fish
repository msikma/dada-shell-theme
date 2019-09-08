# Dada Shell Theme © 2019

# Alerts directory and the archive.
set -g jira_data_cache $home"/.cache/dada/jira.json"
set -g github_contribs_cache $home"/.cache/dada/contribs.json"

function _get_jira_list
  cat "$jira_cache"
end

function _cache_tasks
  # Cache the list of Jira tasks and various other things.
  ms-jira-cli --action data --output json > "$jira_data_cache"
  github-contribs-cli --username msikma --action data --output json > "$github_contribs_cache"
end

function get_tasks
  set out (_get_jira_list)
  for task in $out
    set code (echo $task | gawk -F@%@ '{print $1}')
    set type (echo $task | gawk -F@%@ '{print $2}')
    set title (echo $task | gawk -F@%@ '{print $3}')
    set link (echo $task | gawk -F@%@ '{print $4}')
    set priority (echo $task | gawk -F@%@ '{print $5}')
    set tstatus (echo $task | gawk -F@%@ '{print $6}')
    set assigned (echo $task | gawk -F@%@ '{print $7}')
    echo $assigned "-" $title "-" $code "-" $tstatus
  end
end
