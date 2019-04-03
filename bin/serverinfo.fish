#!/usr/bin/env fish

# e.g. fuji (used for: https://fuji.local/)
set address (echo "$hostname" | tr '[:upper:]' '[:lower:]')
set filepath (echo "/Users/"(whoami)"/Files/Sites")

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
