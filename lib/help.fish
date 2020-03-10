# Dada Shell Theme © 2019

function _iterate_help \
  --description "Iterate through and print a list of commands and descriptions"
  set _cmd_all $argv
  set neutral (set_color normal)

  # Iterate through our merged list and print the command name and description.
  set m 0
  set total (math 4 + (count $_cmd_all))
  set half (math "(floor($total / 8) * 4)")
  for n in (seq 1 4 (math $half))
    set m (math $m + 1)

    set l_color $_cmd_all[$n]
    set l_cmd_n $_cmd_all[(math $n + 1)]
    set l_cmd_d $_cmd_all[(math $n + 3)]

    set r_color $_cmd_all[(math $n + $half)]
    set r_cmd_n $_cmd_all[(math $n + $half + 1)]
    set r_cmd_d $_cmd_all[(math $n + $half + 3)]

    printf "%s%-16s%s%-34s%s%-16s%s%-34s\\n" $l_color $l_cmd_n $neutral $l_cmd_d $r_color $r_cmd_n $neutral $r_cmd_d
  end
end

function _iterate_list \
  --description "Iterate through and print a single column list of commands and descriptions"
  # Note: like _iterate_help, but single column.
  set _cmd_all $argv
  set neutral (set_color normal)
  for n in (seq 1 4 (count $_cmd_all))
    set l_color $_cmd_all[$n]
    set l_cmd_n $_cmd_all[(math $n + 1)]
    set l_cmd_d $_cmd_all[(math $n + 3)]
    printf "%s%-32s%s%-68s%s\\n" $l_color $l_cmd_n $neutral $l_cmd_d
  end
end

# Injects colors into a list of commands
function _add_cmd_colors
  set color $argv[1]
  set neutral (set_color normal)

  set items (math (count $argv[2..-1]) + 1)
  for n in (seq 2 2 $items)
    echo $color
    echo $argv[$n]
    echo $neutral
    echo $argv[(math $n + 1)]
  end
end


