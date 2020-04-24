# Dada Shell Theme © 2019, 2020

set -g _assert_n "0"
set -g _assert_success "0"
set -g _assert_fail "0"

function assert_equal \
  --argument-names actual expected fn
  set _assert_n (math "$_assert_n + 1")
  if [ "$actual" = "$expected" ]
    set _assert_success (math "$_assert_success + 1")
  else
    set _assert_fail (math "$_assert_fail + 1")
    print_assert_error $actual $expected $fn
  end
end

function print_assert_error \
  --argument-names actual expected fn
  echo (set_color red)"Assert failure: "(set_color -u red)"$fn"(set_color normal)(set_color red)" - expected \""(set_color yellow)"$expected"(set_color red)"\", received \""(set_color brred)"$actual"(set_color red)"\""
end

function assert_start
  set _assert_n "0"
end

function assert_report \
  --argument-names fn
  echo (set_color blue)Test results: (set_color -u blue)$fn(set_color normal)
  if [ $_assert_n -ne "1" ]; set n_s "s"; else; set n_s ""; end
  set perc (math "$_assert_success / $_assert_n * 100")
  if [ "$perc" -lt 30 ]
    set perc_color (set_color red)
  else if [ "$perc" -gt 70 ]
    set perc_color (set_color green)
  else
    set perc_color (set_color yellow)
  end
  echo (set_color yellow)"Ran "(set_color blue)"$_assert_n assert$n_s"(set_color yellow)": "(set_color green)"$_assert_success pass"(set_color yellow)", "(set_color red)"$_assert_fail fail"(set_color yellow)" - $perc_color$perc%"(set_color normal)
end
