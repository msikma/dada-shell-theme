#!/usr/bin/env fish

set site 'google.com'
set ip (dig +short $site)
echo (set_color cyan)"Checking "(set_color yellow)"$site"(set_color cyan)" ($ip) for connectivity"(set_color normal)
ping -i 2 $ip 2>&1 | perl -nle 'print scalar(localtime), " ", $_'

