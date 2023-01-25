#!/usr/bin/env bash

# Retrieves the mime type, e.g. 'image/png'
mime=$(file -bN --mime-type "$1")
# Converts the file itself to Base64
content=$(base64 -b0 < "$1")
# Detect file dimensions.
width=$(identify -ping -format "%w" "$1"[0])
height=$(identify -ping -format "%h" "$1"[0])

printf "<img src=\"data:%s;base64,%s\" width=\"$width\" height=\"$height\" />\n" $mime $content
