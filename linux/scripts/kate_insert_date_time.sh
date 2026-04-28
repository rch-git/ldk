#!/usr/bin/env bash
# run this to make the script executable - chmod +x ~/git/ldk/linux/scripts/kate_insert_date_time.sh
# printf "%s" "$(date '+%b %d, %Y %A %I:%M:%S %p %Z')"
printf "%s" "$(date '+%A, %B %-d, %Y, %-I:%M %p %Z')"
