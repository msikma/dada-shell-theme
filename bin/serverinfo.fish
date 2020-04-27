#!/usr/bin/env fish

if [ "$DADA_FISH_ENV" = "server" ]
  set apache_data (apache2ctl status | grep -i "requests/sec")

  set apache_version (apache2 -v | head -n1 | string sub -s 17)
  set apache_uptime (apache2ctl status | grep -i "server uptime" | cut -d':' -f2 | string sub -s 2)
  set apache_load (apache2ctl status | grep -i "server load" | cut -d':' -f2 | string sub -s 2)
  set apache_reqs_sec (echo $apache_data | cut -d'-' -f1 | string sub -s 4)
  set apache_b_sec (echo $apache_data | cut -d'-' -f2 | string sub -s 2)
  set apache_kb_req (echo $apache_data | cut -d'-' -f3 | string sub -s 2)
  set apache_ms_req (echo $apache_data | cut -d'-' -f4 | string sub -s 2)

  set apache_reqs_sec_fc (echo $apache_reqs_sec | string sub -s 1 -l 1)
  set apache_ms_req_fc (echo $apache_ms_req | string sub -s 1 -l 1)
  if [ "$apache_reqs_sec_fc" = "." ]
    set apache_reqs_sec "0$apache_reqs_sec"
  end
  if [ "$apache_ms_req_fc" = "." ]
    set apache_ms_req "0$apache_ms_req"
  end

  set apache_cols \
    "Apache version:" "$apache_version" \
    "Server uptime:"  "$apache_uptime" \
    "Server load:"  "$apache_load" \
    "Requests:"  "$apache_reqs_sec" \
    "Speed:"  "$apache_ms_req" \
    "Size:"  "$apache_kb_req" \
    "Traffic:"  "$apache_b_sec"

  set uptime_days (uptime | sed -e 's/^ [^ ]* up \([^,]*\).*/\1/') # Linux only
  set ipv4 (hostname -i | awk '{print $2}')
  set ipv6 (hostname -i | awk '{print $1}')
      
  set information_cols \
    "System uptime:"  "$uptime_days" \
    "IPv4 for eth0:"  "$ipv4" \
    "IPv6 for eth0:"  "$ipv6" \
    "" "" \
    "" "" \
    "" ""
  
  echo
  set cols_all
  set -a cols_all (_add_cmd_colors (set_color red) $apache_cols)
  set -a cols_all (_add_cmd_colors (set_color green) $information_cols)
  _iterate_help $cols_all
  echo
  echo "   Server configuration:"
  echo
  echo "/var/www/"(set_color yellow)"*"(set_color normal)"       served files"
  echo "/etc/apache2/    configuration"
  echo ""
  echo "   To control the Apache server:"
  echo ""
  echo "\$ sudo "(set_color cyan)"apache2ctl "(set_color green)"{"(set_color yellow)"start"(set_color green)", "(set_color yellow)"stop"(set_color green)", "(set_color yellow)"restart"(set_color green)", "(set_color yellow)"configtest"(set_color green)", "(set_color yellow)"status"(set_color green)"}"(set_color normal)
  echo "\$ sudo "(set_color cyan)"a2ensite "(set_color blue)"example.com.conf"(set_color normal)"    enable a site"
  echo "\$ sudo "(set_color cyan)"a2dissite "(set_color blue)"example.com.conf"(set_color normal)"   disable a site"
  echo 'TODO'
end

if [ "$DADA_FISH_ENV" = "desktop" ]
  # e.g. fuji (used for: https://fuji.local/)
  set address (echo "$dada_hostname" | tr '[:upper:]' '[:lower:]')
  set filepath (echo "/$UDIR/"(whoami)"/Files/Sites")

  # Retrieve version numbers for Apache, PHP and MySQL.

  # 2.4.37
  set ver_httpd (httpd -v | head -n 1 | grep -o "Apache\\/[0-9]\{1\}.[0-9]\{1\}.[0-9]\{1,2\}" | cut -f2 -d/)
  # 7.3.0
  set ver_php (php -v | head -n 1 | grep -o "PHP [0-9]\{1\}.[0-9]\{1\}.[0-9]\{1\}" | cut -f2 -d' ')
  # 10.3.11
  set ver_sql (mysql --version | grep -o "\([0-9]\{2\}.[0-9]\{1,2\}.[0-9]\{1,2\}\)-MariaDB" | cut -f1 -d-)

  # 7.3; PHP path (shorter version)
  set ver_php_short (echo $ver_php | cut -f1,2 -d.)

  # A column length is 50 characters (subtract one for spacing, add 21 for color codes).
  set head_httpd (printf "%-70s" (set_color blue)"Apache "(set_color cyan)$ver_httpd(set_color normal))
  set head_php (printf "%-49s" (set_color blue)"PHP "(set_color cyan)$ver_php(set_color normal))
  set head_sql (printf "%-49s" (set_color blue)"MySQL "(set_color cyan)$ver_sql(set_color blue)" (MariaDB)"(set_color normal))

  # Left column                                     Right column
  # ------------- --------------------------------- =============== =================================

  set col_color (set_color purple)
  set col_clean (set_color normal)
  set col_addr (set_color yellow)
  set col_addr_ul (set_color -u yellow)
  set col_port (set_color ff6600)
  set col_green (set_color green)
  set col_term (set_color brblack)

  echo ""
  echo "$head_httpd $head_php"
  echo $col_color"Running on: "$col_addr"https://$col_addr_ul$address.local$col_clean$col_yellow:"$col_port"443"$col_clean"                To upgrade:"
  echo "                                                  $col_term""brew upgrade php@$ver_php_short"
  echo $col_color"Info:"$col_addr"       https://$col_addr_ul$address.local/phpinfo.php"$col_clean
  echo $col_color"phpMyAdmin:"$col_addr" https://$col_addr_ul$address.local/phpMyAdmin$col_clean         $col_color""Files:"$col_addr"      /usr/local/etc/php/$ver_php_short$col_clean"
  echo "                                                  "$col_color"Config:"$col_addr"     /usr/local/etc/php/$ver_php_short/php.ini$col_clean"
  echo "To upgrade:"
  echo "$col_term""brew upgrade httpd$col_clean                                "$col_green"Switch PHP versions using "$col_addr"sphp "$col_port"<version>"$col_green","
  echo "                                                  "$col_green"where version is 5.6, 7.1, 7.2 or 7.3."
  echo $col_color"Root:"$col_addr"       $filepath"
  echo "                                                  $head_sql"
  echo $col_color"Files:"$col_addr"      /usr/local/etc/httpd/"$col_clean"                 To upgrade:"
  echo $col_color"Config:"$col_addr"      └─ httpd.conf"$col_clean"                        $col_term""brew upgrade mariadb"
  echo $col_color"Hosts:"$col_addr"       └─ extra/httpd-vhosts.conf"$col_clean
  echo $col_color"Error log:"$col_addr"  /usr/local/var/log/httpd/error_log"$col_clean"    $col_color""Files:"$col_addr"      /usr/local/opt/mariadb"
  echo $col_color"Access log:"$col_addr" /usr/local/var/log/httpd/access_log""   $col_color"$col_color"Config:"$col_addr"     /usr/local/etc/my.cnf.d/"$col_port"<*.cnf>"
  echo $col_color"Restart:"$col_addr"    $col_term""brew services restart httpd"$col_color"           Restart:"$col_addr"    $col_term""brew services restart mariadb"
  echo ""
end
