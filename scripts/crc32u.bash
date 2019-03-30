#!/usr/bin/env bash
crc32 "$@" | awk '{s = ""; for (i = 1; i <= NF; i++) s = ((i==1) ? toupper(s $i) : s $i) " "; print s}'
