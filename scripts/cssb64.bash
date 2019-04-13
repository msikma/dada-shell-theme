#!/usr/bin/env bash

# Retrieves the mime type, e.g. 'image/png'
mime=$(file -bN --mime-type "$1")
# Converts the file itself to Base64
content=$(base64 -b0 < "$1")

printf "url('data:%s;base64,%s')\n" $mime $content
