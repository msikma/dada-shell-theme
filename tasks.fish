# Dada Shell Theme © 2019

# Alerts directory and the archive.
set -g jira_list_cache $home"/.cache/dada/jira.txt"
set -g jira_data_cache $home"/.cache/dada/jira.json"

function _get_jira_list
  cat "$jira_cache"
end

function _cache_jira_tasks
  # Cache the list of Jira tasks.
  ms-jira-cli --action list > "$jira_list_cache"
  ms-jira-cli --action data --output json > "$jira_data_cache"
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
