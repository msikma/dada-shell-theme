# Dada Shell Theme © 2019

function _test_format_full_timestamp
  # Tue Aug 13 23:37:33 CEST 2019
  set now "1565942253"
  set fn "format_full_timestamp"

  assert_start
  assert_equal (format_full_timestamp "1565942153" $now) "09:08 (1 minute ago)" "$fn"
  assert_equal (format_full_timestamp "1565932153" $now) "07:08 (2 hours ago)" "$fn"
  assert_equal (format_full_timestamp "1565922153" $now) "04:08 (5 hours ago)" "$fn"
  assert_equal (format_full_timestamp "1565822153" $now) "Yesterday at 00:08 (33 hours ago)" "$fn"
  assert_equal (format_full_timestamp "1565722153" $now) "Last Tuesday at 20:08 (2 days ago)" "$fn"
  assert_equal (format_full_timestamp "1565622153" $now) "Last Monday at 17:08 (3 days ago)" "$fn"
  assert_equal (format_full_timestamp "1565422153" $now) "Last week Saturday at 09:08 (6 days ago)" "$fn"
  assert_equal (format_full_timestamp "1565222153" $now) "Last week Thursday at 01:08 (1 week ago)" "$fn"
  assert_equal (format_full_timestamp "1564622153" $now) "2019-08-01 03:08 (2 weeks ago)" "$fn"
  assert_equal (format_full_timestamp "1564122153" $now) "2019-07-26 08:07 (3 weeks ago)" "$fn"
  assert_equal (format_full_timestamp "1563122153" $now) "2019-07-14 18:07 (1 month ago)" "$fn"
  assert_equal (format_full_timestamp "1553122153" $now) "2019-03-20 23:03 (4 months ago)" "$fn"
  assert_equal (format_full_timestamp "1453122153" $now) "2016-01-18 14:01 (3 years ago)" "$fn"
  assert_report "$fn"
end
